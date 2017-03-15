//
//  GestureTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/1/22.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "GestureTestViewController.h"

@interface GestureTestViewController ()

@end

@implementation GestureTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:panGesture];
}

- (void)panGesture:(UIPanGestureRecognizer *)thePanGesture
{
    switch (thePanGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"began");
            break;
        case UIGestureRecognizerStateChanged:
            NSLog(@"changed");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"failed");
            break;
        case UIGestureRecognizerStateCancelled:
            //cancelled和ended好像不会一起触发？
            //测试方法是移动的过程中 cmd+shift+H 回到桌面，会cancel
            NSLog(@"cancelled");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"ended");
            break;
        case UIGestureRecognizerStatePossible:
            NSLog(@"possible");
            break;
        default:
            break;
    }
}

@end
