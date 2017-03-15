//
//  UploadImageViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/9.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "UploadImageViewController.h"
#import "PostBodyMakerUtil.h"
#import <Photos/Photos.h>


@interface UploadImageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadBtn:(id)sender;
- (IBAction)photosAlbumBtn:(id)sender;
- (IBAction)cameraBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *presentView;
- (IBAction)allThumbBtn:(id)sender;
- (IBAction)allOriginalBtn:(id)sender;


@property (nonatomic, strong) UIImagePickerController *p;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, strong) NSURL *serverAddress;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSMutableArray *imgArr;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation UploadImageViewController
- (NSMutableArray *)imgArr
{
    if(!_imgArr){
        _imgArr = [[NSMutableArray alloc]init];
    }
    return _imgArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _p = [[UIImagePickerController alloc]init];
    _serverAddress = [NSURL URLWithString:@"http://192.168.220.59:5000/image/"];
    _request = [NSMutableURLRequest requestWithURL:_serverAddress];
    _request.HTTPMethod = @"POST";
    _request.timeoutInterval = 3.0;
    _imgView.layer.borderWidth = 1.0;
    _imgView.layer.borderColor = [UIColor cyanColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Photo
//获取所有相簿的  原图
- (void)getOriginalImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:YES];
    }
    
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    // 遍历相机胶卷,获取大图
    [self enumerateAssetsInAssetCollection:cameraRoll original:YES];
}

//获取所有相簿的  缩略图
- (void)getThumbnailImages
{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in assetCollections) {
        [self enumerateAssetsInAssetCollection:assetCollection original:NO];
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
}

/*
 *  自定义的对某一个相簿进行遍历的方法
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            NSLog(@"%@", result);
            [self.imgArr addObject:result];
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = info[@"UIImagePickerControllerMediaType"];
    NSURL *url = info[@"UIImagePickerControllerReferenceURL"];
    NSLog(@"url is %@,type is %@",url,type);
    UIImage *originalIMG = info[@"UIImagePickerControllerOriginalImage"];
    UIImage *editedIMG = info[@"UIImagePickerControllerEditedImage"];
    if (editedIMG) {
        self.img = editedIMG;
    }else{
        self.img = originalIMG;
    }
    
    self.imgView.image = self.img;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BtnHandler
static NSString *boundary = @"BOUNDARY";
- (IBAction)uploadBtn:(id)sender {
    PostMakerParams *p = [[PostMakerParams alloc]initWithData:UIImageJPEGRepresentation(_img,0.5) name:@"image" fileName:@"file1.png" ContentType:@"image/jpeg"];
    [PostBodyMakerUtil makeBodyOfRequest:_request andParams:p];
    
    NSURLSessionDataTask *t = [[NSURLSession sharedSession] dataTaskWithRequest:_request
                                                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                 if (error) {
                                                                     NSLog(@"%@",error);
                                                                 }else{
                                                                     NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                                                 }
                                                             }];
    [t resume];
}


- (IBAction)photosAlbumBtn:(id)sender {
    _p.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _p.delegate = self;
    _p.allowsEditing = YES;
    
    [self presentViewController:_p animated:YES completion:nil];
}

- (IBAction)cameraBtn:(id)sender {
    _p.sourceType = UIImagePickerControllerSourceTypeCamera;
    _p.delegate = self;
    _p.allowsEditing = YES;
    
    [self presentViewController:_p animated:YES completion:nil];
}
- (IBAction)allThumbBtn:(id)sender {
    [self getThumbnailImages];
}

- (IBAction)allOriginalBtn:(id)sender {
    [self getOriginalImages];
}
@end
