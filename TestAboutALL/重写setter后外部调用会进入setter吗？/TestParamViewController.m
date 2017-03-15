//
//  TestParamViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/20.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TestParamViewController.h"

@interface TestParamViewController ()

@end

@implementation TestParamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
#warning 这里记得，==NULL 而不是直接用!去取反判断
    TestParam *a = [[TestParam alloc]init];
    a.str1 = @"!!!!";
    if ([a.dict1 allKeys].firstObject == NULL) {
        NSLog(@"dict是空的");
    }else{
        NSLog(@"dict有值");
        NSLog(@"dict's first key is %@",[a.dict1 allKeys].firstObject);
    }
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
