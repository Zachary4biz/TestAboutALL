//
//  BaiduAPITestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/15.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "BaiduAPITestViewController.h"
#import "Assist.h"
#import "Masonry.h"


@interface BaiduAPITestViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, assign) APIType APIType;
@property (nonatomic, strong) UIButton *ocrGeneralBtn;
@property (nonatomic, strong)UIButton *faceDetectBtn;
@end

@implementation BaiduAPITestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *openCameraBtn = [self getQuickBtnWithTitle:@"Camera" andSelector:@selector(openCameraBtnHandler)];
    openCameraBtn.frame = CGRectMake(8, 44, 120, 30);
    [self.view addSubview:openCameraBtn];
    
    UIButton *openPhotoLibraryBtn = [self getQuickBtnWithTitle:@"Library" andSelector:@selector(openPhotoLibraryBtnHandler)];
    openPhotoLibraryBtn.frame = CGRectMake(8, 44+30+10, 120, 30);
    [self.view addSubview:openPhotoLibraryBtn];
    
    UIButton *openPhotoAlbumBtn = [self getQuickBtnWithTitle:@"Album" andSelector:@selector(openPhotoAlbumBtnHandler)];
    openPhotoAlbumBtn.frame = CGRectMake(8, 44+30+10+30+10, 120, 30);
    [self.view addSubview:openPhotoAlbumBtn];
    
#pragma mark - 设置要用哪个API
    //default
    self.APIType = APITypeFace_Detect;
    
    _ocrGeneralBtn = [self getQuickBtnWithTitle:@"OCR_General" andSelector:@selector(ocrGeneralBtnHandler:)];
    _ocrGeneralBtn.frame = CGRectMake(self.view.frame.size.width-130, 44, 120, 30);
    [self.view addSubview:_ocrGeneralBtn];
    
    _faceDetectBtn = [self getQuickBtnWithTitle:@"Face_Detect" andSelector:@selector(faceDetectBtnHandler:)];
    _faceDetectBtn.frame = CGRectMake(self.view.frame.size.width-130, 44+30+10, 120, 30);
    [self.view addSubview:_faceDetectBtn];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)ocrGeneralBtnHandler:(UIButton *)btn
{
    self.APIType = APITypeOCR_General;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_faceDetectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)faceDetectBtnHandler:(UIButton *)btn
{
    self.APIType = APITypeFace_Detect;
    [_ocrGeneralBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

#pragma mark -
- (void)openCamera
{
    UIImagePickerController *thePicker = [self getTheImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    [self setUpOverlayView];
    thePicker.cameraOverlayView = self.overlayView;
    if ([self canUseCameraRear]) {
        [self presentViewController:thePicker animated:YES completion:^{
            NSLog(@"openCamera-- presentVC complition");
        }];
    }else{
        NSLog(@"不能使用Camera");
    }
}

- (void)openPhotoLibrary
{
    UIImagePickerController *thePicker = [self getTheImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if ([self canUsePhotoLibrary]) {
        [self presentViewController:thePicker animated:YES completion:^{
            NSLog(@"openPhotoLibrary-- presentVC complition");
        }];
    }else{
        NSLog(@"不能使用photoLibrary");
    }
}

- (void)openPhotoAlbum
{
    UIImagePickerController *thePicker = [self getTheImagePickerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    thePicker.allowsEditing = YES;
    if ([self canUsePhotoAlbum]) {
        [self presentViewController:thePicker animated:YES completion:^{
            NSLog(@"openPhotoAlbum-- presentVC complition");
        }];
    }else{
        NSLog(@"不能使用photoAlbum");
    }
}

#pragma mark - handler
- (void)openCameraBtnHandler
{
    [self openCamera];
}
- (void)openPhotoLibraryBtnHandler
{
    [self openPhotoLibrary];
}
- (void)openPhotoAlbumBtnHandler
{
    [self openPhotoAlbum];
}
#pragma mark - PickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"%@",info);
    UIImage *img = info[@"UIImagePickerControllerEditedImage"]?info[@"UIImagePickerControllerEditedImage"]:info[@"UIImagePickerControllerOriginalImage"];
    NSLog(@"%@",img);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImageView *imgViewTemp = [[UIImageView alloc]init];
        imgViewTemp.bounds = CGRectMake(0, 0, 0.5*self.view.frame.size.width, 0.5*self.view.frame.size.height);
        imgViewTemp.center = self.view.center;
        imgViewTemp.image = img;
        [self.view addSubview:imgViewTemp];
        [Assist getBaiduAPIType:self.APIType ResultWithImage:img withCompletion:^(NSDictionary *dict) {
            NSLog(@"dictResult %@",dict);
            if (dict) {
                if (dict[@"error_msg"]) {
                    [self alertVCWithTitle:dict[@"error_msg"]];
                }else{
                    [self dealTheAPIResultDictionart:dict OfImageView:imgViewTemp];
                }
            }else{
                [self alertVCWithTitle:@"JSON Error"];
            }

        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - handleResult
//处理字典
- (void)dealTheAPIResultDictionart:(NSDictionary *)dict OfImageView:(UIImageView *)imgViewTemp
{
    switch (self.APIType) {
        case APITypeOCR_General:
            //
            if ([dict[@"words_result_num"] integerValue] > 0){
                //检测到个数大于0
                NSArray *resultArr = dict[@"words_result"];
                //遍历
                for (int i=0; i<resultArr.count; i++) {
                    NSDictionary *resultDic = resultArr[i];
                    NSDictionary *locationDic = resultDic[@"location"];
                    [self drawOnImageView:imgViewTemp withLocationDic:locationDic];
                }
            }else{
                [self alertVCWithTitle:@"没有检测到文字"];
            }

            break;
        case APITypeOCR_IDCard:
            //
            break;
        case APITypeOCR_BankCard:
            //
            break;
        case APITypeFace_Detect:
            //
            if ([dict[@"result_num"] integerValue] > 0){
                //检测到个数大于0
                NSArray *resultArr = dict[@"result"];
                //遍历
                for (int i=0; i<resultArr.count; i++) {
                    NSDictionary *resultDic = resultArr[i];
                    NSDictionary *locationDic = resultDic[@"location"];
                    [self drawOnImageView:imgViewTemp withLocationDic:locationDic];
                }
            }else{
                [self alertVCWithTitle:@"没有检测到人脸"];
            }
            break;
        case APITypeFace_Verify:
            //
            break;
        default:
            //
            break;
    }
}
//绘图
- (void)OCRdrawOnImageView:(UIImageView *)imgViewTemp withLocationDic:(NSDictionary *)dict
{
    UIImage *img = imgViewTemp.image;
    //开始画图
    //给出画布
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(img.size.width, img.size.height),NO,0.0);
    [img drawAtPoint:CGPointMake(0, 0)];
    //获得一个图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext ();
    
    //画
    //1.直接画一个矩形
    CGRect rectangle = CGRectMake([dict[@"left"] floatValue], [dict[@"top"] floatValue], [dict[@"width"] floatValue], [dict[@"height"] floatValue]);
    //描边绘制
    CGContextSetStrokeColorWithColor(context, [UIColor cyanColor].CGColor);
    CGContextStrokeRectWithWidth(context, rectangle, 3);
    //2.通过路径画
    //    CGContextDrawPath (context, kCGPathStroke );
    
    // 返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    [imgViewTemp setImage:newImage];
    [self.view layoutIfNeeded];
}
- (void)drawOnImageView:(UIImageView *)imgViewTemp withLocationDic:(NSDictionary *)dict
{
    NSLog(@"**************************绘制开始");
    UIImage *img = imgViewTemp.image;
    //开始画图
    //给出画布
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(img.size.width, img.size.height),NO,0.0);
    [img drawAtPoint:CGPointMake(0, 0)];
    //获得一个图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext ();
    
    //画
    //1.直接画一个矩形
    CGRect rectangle = CGRectMake([dict[@"left"] floatValue], [dict[@"top"] floatValue], [dict[@"width"] floatValue], [dict[@"height"] floatValue]);
    //描边绘制
    CGContextSetStrokeColorWithColor(context, [UIColor cyanColor].CGColor);
    CGContextStrokeRectWithWidth(context, rectangle, 3);
    //2.通过路径画
//    CGContextDrawPath (context, kCGPathStroke );
  
    // 返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [imgViewTemp setImage:newImage];
    });
//    [imgViewTemp setNeedsDisplay];
    
    NSLog(@"**************************绘制结束");
}
//弹窗提示
- (void)alertVCWithTitle:(NSString *)title
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - OverlayView
- (void)setUpOverlayView
{
    self.overlayView = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 200, 310)];
    self.overlayView.backgroundColor = [UIColor cyanColor];
}


#pragma mark - SelfMade
- (UIButton *)getQuickBtnWithTitle:(NSString *)title andSelector:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark -
- (UIImagePickerController *)getTheImagePickerWithSourceType:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = type;
    return picker;
}
#pragma mark -
- (BOOL)canUseCameraRear
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
- (BOOL)canUsePhotoLibrary
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL)canUsePhotoAlbum
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
