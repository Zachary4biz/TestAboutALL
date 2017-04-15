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


@property (weak, nonatomic) IBOutlet UITextField *m11T;
@property (weak, nonatomic) IBOutlet UITextField *m12T;
@property (weak, nonatomic) IBOutlet UITextField *m13T;
@property (weak, nonatomic) IBOutlet UITextField *m14T;
@property (weak, nonatomic) IBOutlet UITextField *m21T;
@property (weak, nonatomic) IBOutlet UITextField *m22T;
@property (weak, nonatomic) IBOutlet UITextField *m23T;
@property (weak, nonatomic) IBOutlet UITextField *m24T;
@property (weak, nonatomic) IBOutlet UITextField *m31T;
@property (weak, nonatomic) IBOutlet UITextField *m32T;
@property (weak, nonatomic) IBOutlet UITextField *m33T;
@property (weak, nonatomic) IBOutlet UITextField *m34T;
@property (weak, nonatomic) IBOutlet UITextField *m41T;
@property (weak, nonatomic) IBOutlet UITextField *m42T;
@property (weak, nonatomic) IBOutlet UITextField *m43T;
@property (weak, nonatomic) IBOutlet UITextField *m44T;



- (IBAction)xRotateBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *angleXText;

- (IBAction)yRotateBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *angleYText;

- (IBAction)zRotateBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *angleZText;

- (IBAction)resteBtn:(id)sender;

@end

@implementation ThreeDTransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBezierPath *p = [UIBezierPath bezierPathWithRect:self.imgView.frame];
    CAShapeLayer *l = [CAShapeLayer layer];
    l.path = p.CGPath;
    l.strokeColor = [UIColor redColor].CGColor;
    l.fillColor = [UIColor clearColor].CGColor;
    l.lineWidth = 3.0;
    [self.view.layer addSublayer:l];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:pan];
}


static CGPoint lastP;
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint locationP = [pan locationInView:pan.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            lastP = locationP;
            
            break;
        case UIGestureRecognizerStateChanged:{
            CGFloat angle1 = ((locationP.x - lastP.x)/self.imgView.frame.size.width) * M_PI_2;
            CGFloat angle2 = ((locationP.y - lastP.y)/self.imgView.frame.size.width) * M_PI_2;
            CATransform3D tempTrans = self.imgView.layer.transform;
            tempTrans.m34 = -1/500;
            //Y轴旋转
            tempTrans = CATransform3DRotate(tempTrans, angle1, 0, 1, 0);
            //X轴旋转
//            tempTrans = CATransform3DRotate(tempTrans, -angle2, 1, 0, 0);
            self.imgView.layer.transform = tempTrans;
            
            lastP = locationP;
            
            [self kick];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
     * 1  = m41*x + m42*Y + m43*Z + m44
     * （根据测试出来的规律）
     * m34影响Y轴旋转的透视，配合绕Y轴旋转来用
     * m24影响X轴旋转的透视
     */
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = 1.0/500.0;//修改矩阵的值控制透视变换，一般是500~1000
//    transform3D.m11 = 0.5;
//    transform3D.m12 = 0.5;
//    transform3D.m33 = 0.5;
//    transform3D = CATransform3DRotate(transform3D, M_PI_4, 1, 0, 0);//绕X轴旋转45度
    transform3D = CATransform3DRotate(transform3D, M_PI_4, 0, 1, 0);//绕Y轴旋转45度
    self.imgView.layer.transform = transform3D;
    
    [self kick];
    
    for(id v in self.view.subviews)
    {
        if ([v isKindOfClass:[UITextField class]]) {
            UITextField *t = v;
            t.adjustsFontSizeToFitWidth = YES;
        }
    }
}
- (void)kick
{
    self.m11T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m11];
    self.m12T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m12];
    self.m13T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m13];
    self.m14T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m14];
    
    self.m21T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m21];
    self.m22T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m22];
    self.m23T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m23];
    self.m24T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m24];
    
    self.m31T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m31];
    self.m32T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m32];
    self.m33T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m33];
    self.m34T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m34];
    
    self.m41T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m41];
    self.m42T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m42];
    self.m43T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m43];
    self.m44T.text = [NSString stringWithFormat:@"%lf",self.imgView.layer.transform.m44];
}

- (IBAction)Btn2:(id)sender {
    [self presentViewController:[[CubeTransformViewController alloc]init] animated:YES completion:nil];
}

- (IBAction)Btn3:(id)sender {
    
}

- (IBAction)Btn4:(id)sender {
}
- (IBAction)xRotateBtn:(id)sender {
    CGFloat anglePI = [self.angleXText.text floatValue]/180 * M_PI;
    self.imgView.layer.transform = CATransform3DRotate(self.imgView.layer.transform, anglePI, 1, 0, 0);
    [self kick];
}

- (IBAction)yRotateBtn:(id)sender {
    CGFloat anglePI = [self.angleYText.text floatValue]/180 * M_PI;
    self.imgView.layer.transform = CATransform3DRotate(self.imgView.layer.transform, anglePI, 0, 1, 0);
    [self kick];
}

- (IBAction)zRotateBtn:(id)sender {
    CGFloat anglePI = [self.angleZText.text floatValue]/180 * M_PI;
    self.imgView.layer.transform = CATransform3DRotate(self.imgView.layer.transform, anglePI, 0, 0, 1);
    [self kick];
}

- (IBAction)resteBtn:(id)sender {
    self.imgView.layer.transform = CATransform3DIdentity;
    [self kick];
}
@end
