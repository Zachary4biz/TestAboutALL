//
//  ThreeDTransformViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/14.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "ThreeDTransformViewController.h"
#import "CubeTransformViewController.h"
@interface ThreeDTransformViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)Btn1:(id)sender;
- (IBAction)Btn2:(id)sender;
- (IBAction)Btn3:(id)sender;
- (IBAction)Btn4:(id)sender;

@end

@implementation ThreeDTransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgView.image = [UIImage imageNamed:@"APUS_Logo"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)Btn1:(id)sender {
    /*
     * [X Y Z 1] x [m11 m21 m31 m41] = [X' Y' Z' 1]
     *             [m12 m22 m32 m42]
     *             [m13 m23 m33 m43]
     *             [m14 m24 m34 m44]
     * （好像不是下面这样的）
     * X' = m11*X + m12*Y + m13*Z + m14
     * Y' = m21*X + m22*Y + m23*Z + m24
     * Z' = m31*X + m32*Y + m33*Z + m34
     * 1  = m41*x ...
     * （根据测试出来的规律）
     * m34影响Y轴旋转的透视，配合绕Y轴旋转来用
     * m24影响X轴旋转的透视
     */
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = 1.0/500.0;//修改矩阵的值控制透视变换，一般是500~1000
    transform3D = CATransform3DRotate(transform3D, M_PI_4, 0, 1, 0);//绕Y轴旋转45度
    self.imgView.layer.transform = transform3D;
    
}

- (IBAction)Btn2:(id)sender {
    [self presentViewController:[[CubeTransformViewController alloc]init] animated:YES completion:nil];
}

- (IBAction)Btn3:(id)sender {
}

- (IBAction)Btn4:(id)sender {
}
@end
