//
//  URLProtocolTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/28.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "URLProtocolTestViewController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
#import "URLProtocolTest.h"

@interface URLProtocolTestViewController ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate,WKNavigationDelegate,UITextFieldDelegate>
- (IBAction)loadBtn:(id)sender;
- (IBAction)loadCacheBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebView *webView2;

@end

@implementation URLProtocolTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(8, 120, 350, 500) configuration:[[WKWebViewConfiguration alloc]init]];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(8);
        make.top.equalTo(self.urlTextField.mas_bottom).offset(8);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(280);
    }];
    self.urlTextField.delegate = self;
    
    self.webView2 = [[WKWebView alloc]initWithFrame:CGRectMake(8, 120, 350, 500) configuration:[[WKWebViewConfiguration alloc]init]];
    self.webView2.navigationDelegate = self;
    [self.view addSubview:self.webView2];
    [self.webView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.left.equalTo(self.webView.mas_right).offset(8);
        make.top.equalTo(self.urlTextField.mas_bottom).offset(8);
        
        make.height.mas_equalTo(390);
    }];
}
- (void)viewWillLayoutSubviews
{
    NSLog(@"%lf",self.view.frame.size.width);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)loadBtn:(id)sender {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlTextField.text]];
    
    [self.webView loadRequest:request];
    [self.view endEditing:YES];
}
static int isLoadingCache = 0;
- (IBAction)loadCacheBtn:(id)sender {
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlTextField.text]];
    [mRequest setValue:@"YES" forHTTPHeaderField:@"ZTUseCache"];
    [self.webView2 loadRequest:mRequest];
    isLoadingCache = 1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlTextField.text]];
    [self.webView loadRequest:request];
    return YES;
}

#pragma mark - WKNavigationDelegate(加载状态)

//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面开始加载时调用-%s",__func__);
}

//内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"内容开始返回时调用-%s",__func__);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    
    NSString *hostName = challenge.protectionSpace.host;
    NSString *authenticationMethod = [[challenge protectionSpace] authenticationMethod];
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodDefault]
        || [authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic]
        || [authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPDigest]) {
        
        NSString *title = @"Authentication Challenge";
        NSString *message = [NSString stringWithFormat:@"%@ requires user name and password", hostName];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"User";
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Password";
            textField.secureTextEntry = YES;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *userName = ((UITextField *) alertController.textFields[0]).text;
            NSString *password = ((UITextField *) alertController.textFields[1]).text;
            
            NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:userName password:password persistence:NSURLCredentialPersistenceNone];
            
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }]];
        
//                [_viewcontroller presentViewController:alertController animated:YES completion:NULL];
        
    } else {
        
        if ([challenge previousFailureCount] == 0)
        {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
        } else {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }

}
//加载结束时回调
extern int shouldUseLocalCache;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"加载结束时回调-%s",__func__);
    if (isLoadingCache) {
        isLoadingCache = 0;
        [[URLProtocolTest class] setShouldUseLocalCache:NO];
    }
}

//加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@" ");
    NSLog(@"加载失败时调用-%s",__func__);
    NSLog(@"错误时--%@",error);
    
}

//接收到服务器重定向
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"接收到服务器重定向-%s",__func__);
    NSLog(@"**********************，URL被重定向了");
    
}

//进程被终止的回调
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"进程被终止的回调--%s",__func__);
}

//接收响应后决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"接受到重定向");
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}

//发送请求前是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"发送请求前跳转");
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
