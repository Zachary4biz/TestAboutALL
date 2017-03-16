//
//  AntiAliasingViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/16.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "AntiAliasingViewController.h"

@interface AntiAliasingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)antiAliasingBtn:(id)sender;
- (IBAction)closeBtn:(id)sender;
- (IBAction)resetBtn:(id)sender;

@end

@implementation AntiAliasingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imgView.userInteractionEnabled = YES;
    
    UIRotationGestureRecognizer *r = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rot:)];
    [self.imgView addGestureRecognizer:r];
}

static CGAffineTransform baseTrans;
- (void)rot:(UIRotationGestureRecognizer *)rot
{
    switch (rot.state) {
        case UIGestureRecognizerStateBegan:
            baseTrans = self.imgView.transform;
            break;
        case UIGestureRecognizerStateChanged:
            self.imgView.transform = CGAffineTransformRotate(baseTrans, rot.rotation);
            break;
        case UIGestureRecognizerStateEnded:
            break;
        default:
            break;
    }
    
}
/*
 * 其实就是把图像 重新绘制到一个四边都小一个像素的区域里面，这样四边都会被透明的像素填充一个。
 */
- (IBAction)antiAliasingBtn:(id)sender {
    CGRect imgRect = CGRectMake(0, 0, self.imgView.frame.size.width, self.imgView.frame.size.height);
    
//注意 UIGraphicsBeginImageContext(imgRect.size); 重绘可能导致模糊
//使用下面这个就不会了，跟scale有关
    UIGraphicsBeginImageContextWithOptions(imgRect.size, NO, [UIScreen mainScreen].scale);
    [self.imgView.image drawInRect:CGRectMake(1, 1, imgRect.size.width-2, imgRect.size.height-2)];
    self.imgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

- (IBAction)closeBtn:(id)sender {
    self.imgView.image = [UIImage imageNamed:@"Norway"];
}

- (IBAction)resetBtn:(id)sender {
    self.imgView.transform = CGAffineTransformIdentity;
}
@end
