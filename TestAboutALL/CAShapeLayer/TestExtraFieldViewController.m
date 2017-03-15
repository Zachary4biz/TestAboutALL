//
//  TestExtraFieldViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/14.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TestExtraFieldViewController.h"

@interface TestExtraFieldViewController ()
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (nonatomic, strong) CAShapeLayer *drawLayer;
@property (nonatomic, strong) UIBezierPath *drawPath;
@property (nonatomic, strong) CAShapeLayer *maskDrawLayer;

@end

@implementation TestExtraFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.testView addGestureRecognizer:pan];
    
    _drawLayer = [CAShapeLayer layer];
    _drawLayer.frame = self.testView.bounds;
    _drawLayer.fillColor = [UIColor greenColor].CGColor;
    _drawLayer.strokeColor = [UIColor blueColor].CGColor;
    _drawLayer.lineWidth = 4.0;
#warning 画虚线
    _drawLayer.lineDashPattern = @[@2,@2];
    
    _drawPath = [UIBezierPath bezierPath];
    
    _maskDrawLayer = [CAShapeLayer layer];
    _maskDrawLayer.frame = _drawLayer.frame;
    _maskDrawLayer.fillColor = [UIColor greenColor].CGColor;
//    _maskDrawLayer.strokeColor = [UIColor blueColor].CGColor;
    _maskDrawLayer.lineWidth = 4.0;
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /*
     * 是可以画到View外面去的
     */
//    UIBezierPath *p = [UIBezierPath bezierPath];
//    [p moveToPoint:CGPointMake(0, 0)];
//    [p addLineToPoint:CGPointMake(200, 300)];
//    _drawLayer.path = p.CGPath;
    
}
-(void)pan:(UIPanGestureRecognizer *)pan
{
    [self animationOfPan:pan];
}
/*
 * 注意手势画线，要在begin的时候移动到当前点，然后change时 —— 先 addLineToPoint 完了之后再moveToPoint
 */

static CGPoint beginP; //用来控制消失（画和背景同色的线） 从beginP开始
static CGPoint endP;    //到endP结束  使用 CAShapeLayer 的 strokeStart和strokeEnd
static NSTimer *timer;
- (void)animationOfPan:(UIPanGestureRecognizer *)pan
{
//    CGPoint velocity = [pan velocityInView:pan.view];
    
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"begin");
            beginP = [pan locationInView:pan.view];
            [_drawPath moveToPoint:[pan locationInView:pan.view]];
            [self.testView.layer addSublayer:_drawLayer];
            [self.testView.layer addSublayer:_maskDrawLayer];
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSLog(@"change");
            [_drawPath addLineToPoint:[pan locationInView:pan.view]];
            [_drawPath moveToPoint:[pan locationInView:pan.view]];
            _drawLayer.path = _drawPath.CGPath;

        //TE
            //或者不用mask，直接设置 _drawLayer的画法是 0.7-1.0
            _maskDrawLayer.strokeColor = [UIColor blackColor].CGColor;
            _maskDrawLayer.strokeEnd = 0.7;
            _maskDrawLayer.strokeStart = 0;
            _maskDrawLayer.path = _drawPath.CGPath;
            
            
        //TE
            break;
        }
        case UIGestureRecognizerStateEnded:
            NSLog(@"end");
            [_drawLayer removeFromSuperlayer];
            _drawLayer.path = nil;
            
            [_maskDrawLayer removeFromSuperlayer];
            _maskDrawLayer.path = nil;
            
            _drawPath = [UIBezierPath bezierPath];
            break;
        default:
            break;
    }
}
- (void)animationToCoverLineOfPan:(UIPanGestureRecognizer *)pan
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
