//
//  CubeTransformViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/14.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "CubeTransformViewController.h"

@interface CubeTransformViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerV;
@property (weak, nonatomic) IBOutlet UIView *V1;
@property (weak, nonatomic) IBOutlet UIView *V2;
@property (weak, nonatomic) IBOutlet UIView *V3;
@property (weak, nonatomic) IBOutlet UIView *V4;
@property (weak, nonatomic) IBOutlet UIView *V5;
@property (weak, nonatomic) IBOutlet UIView *V6;
- (IBAction)dismissBtn:(id)sender;
- (IBAction)testBtn:(id)sender;

@end

static CATransform3D baseTrans;
static CATransform3D panBaseTrans;
static CGFloat initialAngle = -M_PI_4;
@implementation CubeTransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTrans = CATransform3DIdentity;
    baseTrans.m34 = -1/500;
    
    //注意这些trans1都是基于baseTrans来做，所以他们并没有互相叠加
    //V1就是Z轴移动向前（向我们）移动50
    CATransform3D trans1 = CATransform3DTranslate(baseTrans, 0, 0, 50);
    _V1.layer.transform = trans1;
    
    //V2是X轴右移50，并且沿Y轴旋转90度
    trans1 = CATransform3DTranslate(baseTrans, 50, 0, 0);
    trans1 = CATransform3DRotate(trans1, M_PI_2, 0, 1, 0);
    _V2.layer.transform = trans1;
    
    //V3是Y轴上移50，沿X轴旋转90度
    trans1 = CATransform3DTranslate(baseTrans, 0, -50, 0);
    trans1 = CATransform3DRotate(trans1, M_PI_2 , 1 , 0 , 0);
    _V3.layer.transform = trans1;
    
    //V4是Y轴下移50，沿X轴旋转-90度（把带label的那一面朝下）
    trans1 = CATransform3DTranslate(baseTrans, 0, 50, 0);
    trans1 = CATransform3DRotate(trans1, -M_PI_2 , 1 , 0 , 0);
    _V4.layer.transform = trans1;
    
    //V5是X轴左移50，沿Y轴旋转-90度
    trans1 = CATransform3DTranslate(baseTrans, -50, 0, 0);
    trans1 = CATransform3DRotate(trans1, -M_PI_2 , 0 , 1 , 0);
    _V5.layer.transform = trans1;
    
    //V6是Z轴后移（远离我们）50，沿着Y轴旋转180度
    trans1 = CATransform3DTranslate(baseTrans, 0, 0, -50);
    trans1 = CATransform3DRotate(trans1, M_PI , 0 , 1 , 0);
    _V6.layer.transform = trans1;
    

    //设置containerV，让一开始的角度就有一定立体感
    CGFloat angle = initialAngle;
    //沿Y轴旋转-45度，再沿X轴旋转-45度
    baseTrans = CATransform3DRotate(baseTrans, angle, 0, 1, 0);
    baseTrans = CATransform3DRotate(baseTrans, angle, 1, 0, 0);
    //要用sublayerTransform，因为上面V1到V6都是containerV的subView,所以要一起变就可以用sublayerTransform
    _containerV.layer.sublayerTransform = baseTrans;
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [_containerV addGestureRecognizer:pan];
    
    panBaseTrans = CATransform3DIdentity;
    panBaseTrans.m34 = -1/500;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
static CGPoint lastP;
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint transP = [pan locationInView:pan.view];
//    CATransform3D tempTrans = _containerV.layer.sublayerTransform;
//    
//    tempTrans.m34 = -1/500;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            lastP = transP;
            break;
        case UIGestureRecognizerStateChanged:
        {
            //angle1是Y轴上旋转的角度，angle2是X轴上旋转的角度
            //transP.x就是横着滑动，横着滑动就是对应垂直转动，即沿Y轴旋转
//            CGFloat angle1 = initialAngle + transP.x/80;
//            CGFloat angle2 = initialAngle + transP.y/80;
            CGFloat angle1 = ((transP.x - lastP.x)/self.V1.frame.size.width) * M_PI_2;
            CGFloat angle2 = ((transP.y - lastP.y)/self.V1.frame.size.width) * M_PI_2;
            NSLog(@"angle1 %lf angle2 %lf",angle1,angle2);
            NSLog(@"%lf",_containerV.layer.sublayerTransform.m34);
            
            CATransform3D tempTrans = _containerV.layer.sublayerTransform;
            tempTrans.m34 = -1/500;
            //Y轴旋转
            tempTrans = CATransform3DRotate(tempTrans, angle1, 0, 1, 0);
            //X轴旋转
            tempTrans = CATransform3DRotate(tempTrans, -angle2, 1, 0, 0);
            _containerV.layer.sublayerTransform = tempTrans;
            
            lastP = transP;
            break;
        }
        default:
            break;
    }
    
//    _containerV.layer.sublayerTransform = tempTrans;
}

- (IBAction)dismissBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)testBtn:(id)sender {
    _containerV.layer.sublayerTransform = CATransform3DIdentity;
}
@end
