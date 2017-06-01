//
//  TmpViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/17.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TmpViewController.h"
#import "TmpOneV.h"
#import "TmpTwoV.h"

@interface TmpViewController ()
@property (nonatomic, strong) TmpOneV *v1;
@end

@implementation TmpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.v1 = [[NSBundle mainBundle] loadNibNamed:@"Tmp" owner:nil options:nil][0];
    TmpTwoV *v2 = [[NSBundle mainBundle] loadNibNamed:@"Tmp" owner:nil options:nil][1];
    _v1.frame = CGRectMake(0, 20, 200, 200);
    v2.frame = CGRectMake(0, 300, 200, 200);
    [self.view addSubview:_v1];
    [self.view addSubview:v2];
    [_v1.btn addTarget:self action:@selector(btn1) forControlEvents:UIControlEventTouchUpInside];
    [v2.btn addTarget:self action:@selector(btn2) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *str = [_v1 valueForKey:@"str"];
    str = [NSString string];
    str = @"123123123";
    NSString *_str = [_v1 valueForKey:@"_str"];
    _str = @"3213231";
}
- (void)btn1
{
    NSLog(@"1");
    [self.v1 showStr];
}
- (void)btn2
{
    NSLog(@"2");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
