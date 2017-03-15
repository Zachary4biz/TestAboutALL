//
//  TestMultiItemsViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/2.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TestMultiItemsViewController.h"

@interface TestMultiItemsViewController ()
@property (weak, nonatomic) IBOutlet UIView *underBtnView;
- (IBAction)btn10:(id)sender;
- (IBAction)btn20:(id)sender;
- (IBAction)btn30:(id)sender;
- (IBAction)btn40:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *parentBtnView;
- (IBAction)btn1:(id)sender;
- (IBAction)btn2:(id)sender;
- (IBAction)btn3:(id)sender;
- (IBAction)btn4:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *aboveBtnView;
- (IBAction)btn100:(id)sender;
- (IBAction)btn200:(id)sender;
- (IBAction)btn300:(id)sender;
- (IBAction)btn400:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn100;
@property (weak, nonatomic) IBOutlet UIButton *btn200;
@property (weak, nonatomic) IBOutlet UIButton *btn300;
@property (weak, nonatomic) IBOutlet UIButton *btn400;

@property (nonatomic, strong) NSMutableArray *btnArr;

@end

@implementation TestMultiItemsViewController
/*
 * 需要 四个按钮 以及 按钮所在的View
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesHandler:)];
    [self.underBtnView addGestureRecognizer:panGes];
    [self.parentBtnView addGestureRecognizer:panGes];
    [self.aboveBtnView addGestureRecognizer:panGes];
    
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesHandler:)];
    [self.aboveBtnView addGestureRecognizer:tapGes];

    self.btnArr = [NSMutableArray arrayWithObjects:self.btn100,self.btn200,self.btn300,self.btn400, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)tapGesHandler:(UITapGestureRecognizer *)tap
{
    CGPoint tapLocation = [tap locationInView:tap.view];
    NSLog(@"tapING - %@",NSStringFromCGPoint(tapLocation));
    for (int i=0; i<3; i++) {
        NSLog(@"%d",i);
        CGRect rectTmp = [self.btnArr[i] frame];
        CGRect rect = [self.aboveBtnView convertRect:rectTmp fromView:self.view];
        if (CGRectContainsPoint(rect, tapLocation)){
            [self.btnArr[i] sendActionsForControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
    
}
- (void)panGesHandler:(UIPanGestureRecognizer *)pan
{
    NSLog(@"panING - %@",NSStringFromCGPoint([pan translationInView:pan.view]));
}
- (IBAction)btn1:(id)sender {
    NSLog(@"1");
}

- (IBAction)btn2:(id)sender {
    NSLog(@"2");
}
- (IBAction)btn3:(id)sender {
    NSLog(@"3");
}

- (IBAction)btn4:(id)sender {
    NSLog(@"4");
}


- (IBAction)btn10:(id)sender {
    NSLog(@"10");
}

- (IBAction)btn20:(id)sender {
    NSLog(@"20");
}

- (IBAction)btn30:(id)sender {
    NSLog(@"30");
}

- (IBAction)btn40:(id)sender {
    NSLog(@"40");
}
- (IBAction)btn100:(id)sender {
    NSLog(@"100");
}

- (IBAction)btn200:(id)sender {
    NSLog(@"200");
}

- (IBAction)btn300:(id)sender {
    NSLog(@"300");
}

- (IBAction)btn400:(id)sender {
    NSLog(@"400");
}
@end
