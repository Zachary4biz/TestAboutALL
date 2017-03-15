//
//  WKWebViewAnotherTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/22.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "WKWebViewAnotherTestViewController.h"

@interface WKWebViewAnotherTestViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSMutableArray *URLArr;
@end
/*
 * 验证发现，在start和commit两个回调处调用[webView stopLoading]都是可以出发 -999错误的
 *区别在于：
 * 1. 如果在start里面stopLoading，会到回调 didFailProvisionalNavigation
 *    而在commit里面stopLoading，会到回调 didFailNavigation
 * 2. 发现如果在commit中时间过长（比如打了个断点等了一下），stopLoading后也不会进入回调didFailNavigation
 *    而在start里面不论多久都会进入回调didFailProvisionalNavigation
 * 3. 但是start里面直接停掉，就不会再backForwardList里面有记录
 */
@implementation WKWebViewAnotherTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(80, 140, 250, 380) configuration:configuration];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    self.URLArr = [NSMutableArray arrayWithObjects:[NSURL URLWithString:@"https://m.baidu.com/s?word=1"],
                                                   [NSURL URLWithString:@"https://m.baidu.com/s?word=2"],
                                                   [NSURL URLWithString:@"https://m.baidu.com/s?word=3"],
                                                   [NSURL URLWithString:@"https://m.baidu.com/s?word=4"],
                                                   [NSURL URLWithString:@"https://m.baidu.com/s?word=5"],
                                                   [NSURL URLWithString:@"https://m.baidu.com/s?word=6"],
                                                   nil];
}
static int i=0;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - start&fail
/*
 - (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
 {
 NSLog(@"start");
 [webView stopLoading];
 [webView loadRequest:[NSURLRequest requestWithURL:self.URLArr[i]]];
 }
 - (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
 {
 NSLog(@"didFailProvisionalNavigation - isLoading? %@",webView.isLoading?@"YES":@"NO");
 NSLog(@"didFailProvisionalNavigation - %@",error);
 i++;
 if (i<self.URLArr.count) {
 [webView loadRequest:[NSURLRequest requestWithURL:self.URLArr[i]]];
 }
 NSLog(@"%@",webView.backForwardList.backList);
 }
 */

#pragma mark - commit&fail
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"didcommit");
    [webView stopLoading];
//    i++;
//    if (i<self.URLArr.count) {
//        [webView loadRequest:[NSURLRequest requestWithURL:self.URLArr[i]]];
//    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"didFailNavigation - isLoading? %@",webView.isLoading?@"YES":@"NO");
    NSLog(@"didFailNavigation - %@",error);
    
    i++;
    if (i<self.URLArr.count) {
        [webView loadRequest:[NSURLRequest requestWithURL:self.URLArr[i]]];
    }
    NSLog(@"%@",webView.backForwardList.backList);
}


@end
