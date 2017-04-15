//
//  ViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/11.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "BtnTestViewController.h"

@interface BtnTestViewController ()
@property (nonatomic, strong) UIButton *btn;
@end

@implementation BtnTestViewController
/*
 * 这个EdgeInsets是跟图片大小有关的
 * 图片太大了的话，imageEdgeInsets是不生效的
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.btn = [[UIButton alloc]init];
    self.btn.frame = CGRectMake(20, 100, 80,80);
    self.btn.backgroundColor = [UIColor redColor];
    
    
    [self.btn setImage:[UIImage imageNamed:@"APUS_Logo_S"] forState:UIControlStateNormal];
    [self.btn setTitle:@"sdaf" forState:UIControlStateNormal];
    [self.view addSubview:self.btn];
    self.btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 30, 10);
    self.btn.titleEdgeInsets = UIEdgeInsetsMake(self.btn.frame.size.height-30, 10, 0, 10);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
