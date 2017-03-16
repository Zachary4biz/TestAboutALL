//
//  ScrollInteractViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/16.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "ScrollInteractViewController.h"

@interface ScrollInteractViewController ()<UIScrollViewDelegate>
- (IBAction)dismissBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrV;


@end

@implementation ScrollInteractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrV.delegate = self;
    self.scrV.backgroundColor = [UIColor grayColor];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    NSLog(@"%lf",[t locationInView:t.view].x);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for(id ges in scrollView.gestureRecognizers)
    {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            UIPanGestureRecognizer *pan = ges;
            NSLog(@"%lf",[pan locationInView:scrollView].x);
        }
    }
    NSLog(@"%lf",scrollView.contentOffset.y);
    NSLog(@"%lf",scrollView.contentOffset.x);
    if (scrollView.contentOffset.y<0) {
        NSLog(@"");
        
        
    }
    
}


- (IBAction)dismissBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
