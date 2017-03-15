//
//  GradientTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/15.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "GradientTestViewController.h"

@interface GradientTestViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) CAGradientLayer *gradTestLayer;
@property (nonatomic, strong) CAGradientLayer *gradMaskLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIVisualEffectView *visualView;

@property (nonatomic, assign) CGPoint controlP;
- (IBAction)testBtn:(id)sender;
- (IBAction)removeBtn:(id)sender;

@end

@implementation GradientTestViewController
- (CAGradientLayer *)gradMaskLayer
{
    if(!_gradMaskLayer){
        _gradMaskLayer = [CAGradientLayer layer];
        //起作用的是颜色的透明度
        [_gradMaskLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor yellowColor] colorWithAlphaComponent:1.0].CGColor,
                                                           (id)[[UIColor greenColor] colorWithAlphaComponent:1.0].CGColor,nil]];
        _gradMaskLayer.locations = @[@(0.0),@(1.0)];
        [_gradMaskLayer setStartPoint:CGPointMake(0, 0)];
        [_gradMaskLayer setEndPoint:CGPointMake(0, 1)];
    }
    return _gradMaskLayer;
}
- (CAGradientLayer *)gradTestLayer
{
    if(!_gradTestLayer){
        _gradTestLayer = [CAGradientLayer layer];
    }
    return _gradTestLayer;
}
- (CAShapeLayer *)shapeLayer
{
    if(!_shapeLayer){
        _shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.fillColor = [UIColor blueColor].CGColor;
        self.shapeLayer.strokeColor = [UIColor cyanColor].CGColor;
        self.shapeLayer.lineWidth = 3.0;
    }
    return _shapeLayer;
}
- (UIVisualEffectView *)visualView
{
    if(!_visualView){
        _visualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }
    return _visualView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:pan];
    
//    self.view.backgroundColor = [UIColor orangeColor];
}

static NSInteger thresHold = 80;
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint transP = [pan translationInView:pan.view];
    CGPoint locationP = [pan locationInView:pan.view];
    
    CGFloat yOfControlP = (thresHold+transP.y) > 2*thresHold ? 2*thresHold : thresHold+transP.y;
    _controlP = CGPointMake(locationP.x, yOfControlP);
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            self.visualView.frame = self.view.bounds;
            [self.view addSubview:self.visualView];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer.path = nil;
            NSLog(@"%@",NSStringFromCGPoint(_controlP));
            if (_controlP.y>thresHold) {
                NSLog(@"画曲线");
                self.path = [UIBezierPath bezierPath];
                [self.path moveToPoint:CGPointMake(0, thresHold)];
                [self.path addLineToPoint:CGPointZero];
                [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, 0)];
                [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, thresHold)];
                [self.path addCurveToPoint:CGPointMake(0, thresHold) controlPoint1:_controlP controlPoint2:_controlP];
                [self.path closePath];
            }else{
                NSLog(@"画矩形");
                self.path = [UIBezierPath bezierPath];
                [self.path moveToPoint:CGPointZero];
                [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, 0)];
                [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, _controlP.y)];
                [self.path addLineToPoint:CGPointMake(0, _controlP.y)];
                [self.path closePath];
            }
            self.shapeLayer.path = self.path.CGPath;
            [self.view.layer addSublayer:self.shapeLayer];
            
//            self.gradMaskLayer.frame = self.view.bounds;
//            self.gradMaskLayer.mask = self.shapeLayer;
//            [self.view.layer addSublayer:self.gradMaskLayer];
//            self.visualView.layer.mask = self.gradMaskLayer;
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer.path = nil;
            [self.gradMaskLayer removeFromSuperlayer];
            [self.visualView removeFromSuperview];
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)testBtn:(id)sender {
    
//    self.path = [UIBezierPath bezierPathWithRect:CGRectMake(20, 20, 300, 100)];
//    self.shapeLayer.fillColor = [UIColor blackColor].CGColor;
//    self.shapeLayer.path = self.path.CGPath;
//    [self.view.layer addSublayer:self.shapeLayer];
    
    /*
     * 这是学习、测试CAGradientLayer
     */
    

    self.gradTestLayer.frame = self.view.bounds;
    //分配颜色，这里使用clearColor配合透明度，来实现渐变隐藏、出现的效果
    [self.gradTestLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor clearColor] colorWithAlphaComponent:1.0].CGColor,
                                                        (id)[[UIColor clearColor] colorWithAlphaComponent:0.7].CGColor,
                                                        nil]];
    //设置渐变的区域，
    //如果只给一个值如0.5，表示第一个颜色纯色一直绘制到0.5，从0.5开始渐变到第二种
    //如果给两个值，如0.4,0.6表示在0.4~0.6之间进行渐变
    self.gradTestLayer.locations = @[@(0.3),@(1.0)];
    
    /*
     * GradientLayer的渐变方向就是根据这个坐标系来的
     *  __________________
     * |(0,0)           (1,0)
     * |
     * |
     * |
     * |
     * |
     * |(0,1)           (1,1)
     */
    //startP和endP直接决定颜色的绘制方向,startP是颜色开始渐变的点，默认是(0,0)左上角
    [self.gradTestLayer setStartPoint:CGPointMake(0, 0)];
    //endP默认是(1,1)
    [self.gradTestLayer setEndPoint:CGPointMake(0, 1)];

    [self.view.layer addSublayer:self.gradTestLayer];

    //通过shapeLayer来控制一下gradTestLayer的形状
//    self.gradTestLayer.mask = self.shapeLayer;
    
    //比如说要给这个imgV添加 渐变形式的 visualEffect,
    UIImageView *imgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Norway"]];
    imgV.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imgV];
    
    //1.第一种，imgV上面再放一个imgV2，对这个imgV2 渐变 并且 模糊
    UIImageView *imgV2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Norway"]];
    imgV2.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imgV2];
    imgV2.layer.mask = self.gradTestLayer;
    
    self.visualView.frame = imgV2.bounds;
    [imgV2 addSubview:self.visualView];
    
    
    
    //2.第二种，效果不好
//    self.visualView.frame = self.view.bounds;
//    [self.view addSubview:self.visualView];
//    self.visualView.layer.mask = self.gradTestLayer;
//    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    v.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:v];
//    v.layer.mask = self.gradTestLayer;
    

}

- (IBAction)removeBtn:(id)sender {
    self.imgView.hidden = !self.imgView.hidden;
}
@end
