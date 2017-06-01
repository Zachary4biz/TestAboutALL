//
//  GradientTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/15.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "GradientTestViewController.h"
#import "ScrollInteractViewController.h"
@interface GradientTestViewController ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

//下拉效果
@property (nonatomic, strong) CAGradientLayer *gradMaskLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIVisualEffectView *visualView;
@property (nonatomic, assign) CGPoint controlP;
@property (nonatomic, strong) UIImageView *upPic;//下拉时，上面出现的图

//学习渐变layer
@property (nonatomic, strong) CAGradientLayer *gradTestLayer;
- (IBAction)testBtn:(id)sender;
- (IBAction)removeBtn:(id)sender;


//彩色进度条
@property (nonatomic, strong) CAGradientLayer *progressGLayer;
@property (weak, nonatomic) IBOutlet UIView *progressV;
- (IBAction)progressBtn:(id)sender;
- (IBAction)beginAnimationBtn:(id)sender;


//打开scroll形式的VC
- (IBAction)presentBtn:(id)sender;

@end

@implementation GradientTestViewController
#pragma mark - Lazy
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


#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    self.imgView.userInteractionEnabled = YES;
    [self.imgView addGestureRecognizer:pan];
    
    [self createProgressView];
}


#pragma mark - panGesture
static NSInteger thresHold = 80;
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint transP = [pan translationInView:pan.view];
    CGPoint locationP = [pan locationInView:pan.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            //下部模糊效果罩住原来的网页
            self.visualView.frame = self.view.bounds;
            [self.view addSubview:self.visualView];
            
            //上部渐变出现的背景图
            self.upPic = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BGI"]];
            self.upPic.frame = self.view.bounds;
            self.upPic.layer.mask = self.shapeLayer;
            [self.view addSubview:self.upPic];
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer.path = nil;
            if (transP.y>0) {
                if (transP.y>thresHold) {
                    //超过80，矩形结束，开始形变
                    self.path = [UIBezierPath bezierPath];
                    [self.path moveToPoint:CGPointMake(0, thresHold)];
                    [self.path addLineToPoint:CGPointZero];
                    [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, 0)];
                    [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, thresHold)];
                    
                    CGFloat yOfControlP = transP.y>2*thresHold?2*thresHold:transP.y;
                    CGPoint controlP = CGPointMake(locationP.x, yOfControlP);
                    [self.path addCurveToPoint:CGPointMake(0, thresHold) controlPoint1:controlP controlPoint2:controlP];
                    
                    [self.path closePath];
                }else{
                    //小于80，画矩形
                    self.path = [UIBezierPath bezierPath];
                    [self.path moveToPoint:CGPointZero];
                    [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, 0)];
                    [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, transP.y)];
                    [self.path addLineToPoint:CGPointMake(0, transP.y)];
                }
            }
            
            self.shapeLayer.path = self.path.CGPath;
            [self.view.layer addSublayer:self.shapeLayer];
            self.upPic.layer.mask = self.shapeLayer;
            
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer.path = nil;
            [self.gradMaskLayer removeFromSuperlayer];
            [self.visualView removeFromSuperview];
            [self.upPic removeFromSuperview];
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Btns
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
    [self.gradTestLayer setColors:[NSArray arrayWithObjects:
                                   (id)[[UIColor clearColor] colorWithAlphaComponent:1.0].CGColor,
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

static int judge = 0;
- (IBAction)beginAnimationBtn:(id)sender {
    judge=0;
}

- (IBAction)presentBtn:(id)sender {
    ScrollInteractViewController *s = [[ScrollInteractViewController alloc]init];
    [self presentViewController:s animated:YES completion:nil];
}

- (IBAction)progressBtn:(id)sender {
    judge=1;
    [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (judge) {
            [self animate];
        }else{
            [timer invalidate];
        }
    }];
    
}

#pragma mark - 封装
- (void)createProgressView
{
    CAGradientLayer *GLayer = [CAGradientLayer layer];
    GLayer.frame = self.progressV.bounds;
    [GLayer setStartPoint:CGPointMake(0.0, 0.5)];
    [GLayer setEndPoint:CGPointMake(1.0, 0.5)];
    
    //准备一个光谱颜色数组
    NSMutableArray *colorArrM = [NSMutableArray array];
    for (NSInteger hue = 0; hue <= 360; hue += 5) {
        
        UIColor *color;
        color = [UIColor colorWithHue:1.0 * hue / 360.0
                           saturation:1.0
                           brightness:1.0
                                alpha:1.0];
        [colorArrM addObject:(id)[color CGColor]];
    }
    [GLayer setColors:colorArrM];
    
    
    self.progressGLayer = GLayer;
    //如果 不 设置颜色的渐变区域
    [self.progressV.layer addSublayer:self.progressGLayer];
}
- (void)animate
{
    
//        NSLog(@"!!");
        //把最后一个颜色，移动到第一个
        NSMutableArray *colorArrM = [self.progressGLayer.colors mutableCopy];
        id lastColor = colorArrM.lastObject;
        [colorArrM removeLastObject];
        [colorArrM insertObject:lastColor atIndex:0];
        [self.progressGLayer setColors:colorArrM];
    
    

    
    
//    CABasicAnimation *animation;
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    animation = [CABasicAnimation animationWithKeyPath:@"colors"];
//    [animation setToValue:colorArrM];
//    [animation setDuration:0.5];
//    [animation setRemovedOnCompletion:YES];
//    [animation setFillMode:kCAFillModeForwards];
//    animation.removedOnCompletion = NO;
//    
//    animation.delegate = self;
//    [self.progressGLayer addAnimation:animation forKey:@"animateGradient"];
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [self animate];
    }
    
}
@end
