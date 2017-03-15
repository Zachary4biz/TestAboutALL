//
//  MyViewController.m
//  TestAboutALL
//
//  Created by 周桐 on 16/11/3.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

//- (void)loadView
//{
//    NSLog(@"%s",__func__);
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__func__);
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSLog(@"%s",__func__);
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"%s",__func__);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
}
/*
 *  - viewDidLoad
 *
 *  - viewWillAppear
 *
 *   - viewWillLayoutSubviews
 *   - viewDidLayoutSubviews
 *
 *  - viewDidAppear
 */

@end
