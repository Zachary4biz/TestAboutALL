//
//  ScrollInteractViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/16.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "ScrollInteractViewController.h"
#import <WebKit/WebKit.h>

@interface ScrollInteractViewController ()<UIScrollViewDelegate>
- (IBAction)dismissBtn:(id)sender;


@property (nonatomic, strong) WKWebView *webV;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *layerS;


@end

@implementation ScrollInteractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webV = [[WKWebView alloc]initWithFrame:CGRectMake(10, 30, 300, 400) configuration:[[WKWebViewConfiguration alloc]init]];
    [self.view addSubview:self.webV];
    self.webV.scrollView.delegate = self;
    self.webV.scrollView.backgroundColor = [UIColor grayColor];
    [self.webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.baidu.com"]]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    NSLog(@"%lf",[t locationInView:t.view].x);
}
static CGFloat thresHold = 40;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%lf",scrollView.contentOffset.y);
    if (scrollView==self.webV.scrollView) {
        CGFloat locationX,y;
        y = scrollView.contentOffset.y;
        for(id ges in scrollView.gestureRecognizers)
        {
            if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
                UIPanGestureRecognizer *pan = ges;
                locationX = [pan locationInView:scrollView].x;
                
                if (scrollView.contentOffset.y<0) {
                    NSLog(@"进入绘图？？");
                    [self.layerS removeFromSuperlayer];
                    self.path = [UIBezierPath bezierPath];
                    self.layerS = [CAShapeLayer layer];
                    self.layerS.strokeColor = [UIColor cyanColor].CGColor;
                    self.layerS.lineWidth = 3.0;
                    if (-scrollView.contentOffset.y > thresHold) {
                        //画形变
                        CGFloat y = -scrollView.contentOffset.y > 2*thresHold? 2*thresHold : -scrollView.contentOffset.y;
                        CGPoint controlP = CGPointMake(locationX, y);
                        
                        [self.path moveToPoint:CGPointZero];
                        [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, 0)];
                        [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, thresHold)];
                        [self.path addCurveToPoint:CGPointMake(0, thresHold) controlPoint1:controlP controlPoint2:controlP];
                        [self.path addLineToPoint:CGPointZero];
                    }else{
                        //画矩形
                        [self.path moveToPoint:CGPointZero];
                        [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, 0)];
                        [self.path addLineToPoint:CGPointMake(self.view.frame.size.width, -scrollView.contentOffset.y)];
                        [self.path addLineToPoint:CGPointMake(0, -scrollView.contentOffset.y)];
                        [self.path addLineToPoint:CGPointZero];
                    }
                    NSLog(@"%lf",y);
                    self.layerS.path = self.path.CGPath;
//                    [scrollView.contentView.layer addSublayer:self.layerS];
                    
                }
            }
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (IBAction)dismissBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
