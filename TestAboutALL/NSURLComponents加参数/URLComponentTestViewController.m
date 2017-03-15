//
//  URLComponentTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/17.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "URLComponentTestViewController.h"

@interface URLComponentTestViewController ()

@end

@implementation URLComponentTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *baseURL = [NSURL URLWithString:@"https://www.baidu.com?test=123&test2=456&test3=789"];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:NO];
    
    NSArray *queryItems = urlComponents.queryItems;
    NSString *param1 = [self valueForKey:@"test" fromQueryItems:queryItems];
    NSLog(@"%@",param1);
}

- (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@",key];
    NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:predicate] firstObject];
    return queryItem.value;
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
