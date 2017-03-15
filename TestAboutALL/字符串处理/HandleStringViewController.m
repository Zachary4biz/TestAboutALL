//
//  HandleStringViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/14.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "HandleStringViewController.h"

@interface HandleStringViewController ()

@end

@implementation HandleStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *str1 = @"ZKBrowser:\\action=iMessage&url=https:\\www.baidu.com";
    NSString *str2 = @"ZKBrowser:\\action=goToHomePage";
    NSString *str3 = @"ZKBrowser:\\action=today&url=https:\\www.bing.com";
    
    NSArray *arr = [str1 componentsSeparatedByString:@"&"];
    NSLog(@"%@",arr);
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
