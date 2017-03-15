//
//  WKWebViewTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/15.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "WKWebViewTestViewController.h"


@interface WKWebViewTestViewController ()<WKUIDelegate,WKNavigationDelegate,UITextFieldDelegate,NSKeyedArchiverDelegate,NSKeyedUnarchiverDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebView *anotherWebView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *backListArr;
@property (nonatomic, strong) NSMutableArray *forwardListArr;
@property (nonatomic, strong) NSURL *currentURL;
@property (nonatomic, strong) WKBackForwardList *backForwardList;
@property (nonatomic, strong) NSMutableArray *URLArr;
@end

@implementation WKWebViewTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *aConfiguration = [[WKWebViewConfiguration alloc]init];
    aConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    WKWebView *aWebView = [[WKWebView alloc]initWithFrame:CGRectMake(8, 80,150, 270) configuration:aConfiguration];
    aWebView.UIDelegate = self;
    aWebView.navigationDelegate = self;
    
    self.webView = aWebView;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.webView];
    
    
    self.textField = [[UITextField alloc]init];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"search here";
    self.textField.frame = CGRectMake(8, 30, self.view.frame.size.width-16, 30);
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 30)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];

    UIButton *saveBtn = [[UIButton alloc]init];
    saveBtn.frame = CGRectMake(180, CGRectGetMaxY(self.webView.frame), 100, 30);
    [saveBtn setTitle:@"saveBtn" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    UIButton *getListBtn = [[UIButton alloc]init];
    getListBtn.frame = CGRectMake(180, CGRectGetMaxY(self.webView.frame)+30, 100, 30);
    [getListBtn setTitle:@"getListBtn" forState:UIControlStateNormal];
    [getListBtn addTarget:self action:@selector(getListBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getListBtn];
    
#pragma mark - 给webView用的两个Btn
    UIButton *backBtn4webView = [[UIButton alloc]init];
    backBtn4webView.frame = CGRectMake(158+8, 80, 200, 30);
    [backBtn4webView setTitle:@"backBtn4webView" forState:UIControlStateNormal];
    [backBtn4webView addTarget:self action:@selector(backBtn4webViewHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn4webView];
    
    UIButton *forwardBtn4webView = [[UIButton alloc]init];
    forwardBtn4webView.frame = CGRectMake(158+8, 110, 200, 30);
    [forwardBtn4webView setTitle:@"forwardBtn4webView" forState:UIControlStateNormal];
    [forwardBtn4webView addTarget:self action:@selector(forwardBtn4webViewHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forwardBtn4webView];
    
#pragma mark - 给anotherWebView用的两个Btn
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(158+8, CGRectGetMaxY(getListBtn.frame), 200, 30);
    [backBtn setTitle:@"backBtn4-Another" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *forwardBtn = [[UIButton alloc]init];
    forwardBtn.frame = CGRectMake(158+8, CGRectGetMaxY(getListBtn.frame)+30, 200, 30);
    [forwardBtn setTitle:@"forwardBtn4-Another" forState:UIControlStateNormal];
    [forwardBtn addTarget:self action:@selector(forwardBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forwardBtn];
    

    WKWebView *anotherWebView = [[WKWebView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(getListBtn.frame),150, 270) configuration:aConfiguration];
    anotherWebView.UIDelegate = self;
    anotherWebView.navigationDelegate = self;
    self.anotherWebView = anotherWebView;
    [self.view addSubview:self.anotherWebView];

}
- (void)backBtn4webViewHandler
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}
- (void)forwardBtn4webViewHandler
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}
- (void)backBtnHandler
{
    if ([self.anotherWebView canGoBack]) {
        [self.anotherWebView goBack];
    }
}
- (void)forwardBtnHandler
{
    if ([self.anotherWebView canGoForward]) {
        [self.anotherWebView goForward];
    }
    
}
- (void)saveBtnHandler
{
    [self archive];
    
    [self recordWebViewParams];
    
    
}

- (void)getListBtnHandler
{
    [self unarchive];
    
    [self loadFromArrV2];
 
}
#pragma mark - 数组方法
- (void)recordWebViewParams{
    
    self.backListArr = [NSMutableArray array];
    for (WKBackForwardListItem *item in self.webView.backForwardList.backList)
    {
        [self.backListArr addObject:item.URL];
    }
    NSLog(@"backList - %@",_backListArr);
    
    self.forwardListArr = [NSMutableArray array];
    for (WKBackForwardListItem *item in self.webView.backForwardList.forwardList)
    {
        [self.forwardListArr addObject:item.URL];
    }
    NSLog(@"forwardList - %@",_forwardListArr);
    
    self.backForwardList = self.webView.backForwardList;
    self.currentURL = self.webView.backForwardList.currentItem.URL;
    
    self.URLArr = [NSMutableArray array];
    [self.URLArr addObjectsFromArray:self.backListArr];
    if (self.currentURL) {
        [self.URLArr addObject:self.currentURL];
    }
    [self.URLArr addObjectsFromArray:self.forwardListArr];
}
static int judge4Reboot = 0;
- (void)loadFromArrV2
{
    //模拟重启
    judge4Reboot = 1;
    //不能全部放到for循环里面去加载，先加载最初的那个URL，然后到代理里面去搞
    [self.anotherWebView loadRequest:[NSURLRequest requestWithURL:self.backListArr.firstObject]];
}
- (void)loadFromArr
{
    //模拟重启后
    judge4Reboot = 1;
    //从backlist开始加载
    for (NSURL *url in self.backListArr)
    {
        NSLog(@"当前让anotherWebView加载的是 -- %@",url.absoluteString);
        [self.anotherWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    [self.anotherWebView loadRequest:[NSURLRequest requestWithURL:self.currentURL]];
    for (NSURL *url in self.forwardListArr)
    {
        NSLog(@"当前让anotherWebView加载的是 -- %@",url.absoluteString);
        [self.anotherWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    //    [self.anotherWebView goToBackForwardListItem:[self.anotherWebView.backForwardList itemAtIndex:self.backListArr.count]];
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
    if (webView == self.anotherWebView) {
        NSLog(@"anotherWebView内容开始返回 -- %@",webView.URL);
        if (judge4Reboot) {
            //模拟重启后，预加载所有url
            [self.anotherWebView stopLoading];
        }
    }
}
//加载结束时回调
static int counter = 0;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"加载结束时回调-%s",__func__);
    if (webView == self.anotherWebView) {
        NSLog(@"anotherWebView加载停止");
        if (judge4Reboot) {
            //模拟重启模式下
            NSLog(@"**********不应该进入这里！！！！！！**********");
            if (counter == _URLArr.count-1) {
                
            }else{
                counter++;
                [self.anotherWebView loadRequest:[NSURLRequest requestWithURL:_URLArr[counter]]];
            }
        }
    }
}
//加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@" ");
    NSLog(@"加载失败时调用-%s",__func__);
    NSLog(@"错误时--%@",error);
    if (webView == self.anotherWebView) {
        NSLog(@"anotherWebView加载失败");
        if (judge4Reboot) {
            //模拟重启模式下
            if (counter >= _URLArr.count-1) {
                //加载完所有网页，开始加载“退出”时的那个网页
                judge4Reboot = 0;
                //“退出”时的那个网页的URL在数组中的index
                NSUInteger index;
                if (self.currentURL) {
                    index = [_URLArr indexOfObject:self.currentURL];
                }
                //当前情况下的currentItem是在索引counter这里，所以用index-counter
                //负数就是shouldBeItem在左边，这里“itemAtIndex”这个方法点击去看一下发现是比较特别的规则
                WKBackForwardListItem *shouldBeItem = [self.anotherWebView.backForwardList itemAtIndex:index-counter];
                [self.anotherWebView goToBackForwardListItem: shouldBeItem];
            }else{
                counter++;//先++再到数组里面取，因为第一个URL已经被加载过了
                [self.anotherWebView loadRequest:[NSURLRequest requestWithURL:_URLArr[counter]]];
            }
        }
    }
}





/*
 * ---------------------------------------------------------------------------------------------
 * ------------------------------------------- 分割 ---------------------------------------------
 * ---------------------------------- 下面都是普通的代理，没有做修改 ---------------------------------
 * ---------------------------------------------------------------------------------------------
 */





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
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
//发送请求前是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    decisionHandler(WKNavigationActionPolicyAllow);
}






#pragma mark - Archive
- (void)archive
{
    NSString *homeDictionary = NSHomeDirectory();//获取根目录
    NSString *homePath  = [homeDictionary stringByAppendingPathComponent:@"webView.archiver"];//添加储存的文件名
    BOOL flag = [NSKeyedArchiver archiveRootObject:self.webView toFile:homePath];
    if (flag) {
        NSLog(@"success");
    }
}
- (void)unarchive
{
    NSString *homeDirectory = NSHomeDirectory();//获取根目录
    NSString *homePath  = [homeDirectory stringByAppendingPathComponent:@"webView.archiver"];//添加储存的文件名]
    id wht = [NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
    //    self.anotherWebView = (WKWebView *)wht;
}





#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self.webView) {
        if ([keyPath isEqualToString: @"estimatedProgress"]) {
            NSLog(@"progress is %lf" ,[change[NSKeyValueChangeNewKey] floatValue]);
        }
    }
}
#pragma mar - TextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *object = textField.text;
    NSURLRequest *request = nil;
    if([object hasSuffix:@".com"] || [object hasSuffix:@".org"]){
        //结尾.com表示是网页
        //首先全部小写
        object = [object lowercaseString];
        if ([object hasPrefix:@"http://"] || [object hasPrefix:@"https://"]) {
            //有http开头或者https开头，直接请求
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:object]
                                       cachePolicy:0
                                   timeoutInterval:1.0];
        }else{
            //没有http开头的补全一下
            NSString *urlPrefix = @"https://";
            NSString *urlStr = [urlPrefix stringByAppendingString:object];
            request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                       cachePolicy:0
                                   timeoutInterval:1.0];
        }
    }else if (object.length == 0){
        NSLog(@"URL栏输入为空，即加载首页");
    }else{
        //没有.com不是网页，调用搜索引擎API搜索
        NSString *PreStrBaidu = @"https://www.baidu.com/s?ie=UTF-8&wd=";
        //考虑到有中文参数，所以需要编码
        //首先设置没有使用的特殊符号--即会被编码掉
        NSString *character2Escape = @"<>'\"*()$#@! ";
        //invertedSet 是取反， 即 除了character2Escape中的其他的字符串都是允许的，不会被编码
        NSCharacterSet *allowedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:character2Escape] invertedSet];
        object = [object stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        
        NSString *urlStr = [PreStrBaidu stringByAppendingString:object];
        NSURL *url = [NSURL URLWithString:urlStr];
        request = [NSURLRequest requestWithURL:url
                                   cachePolicy:0
                               timeoutInterval:1.0];
    }
    
    [self.webView loadRequest:request];
    return YES;
}


#pragma mark - WKUIDelegate
//开启新的frame时创建新窗口的回调
-(nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    NSLog(@"进入了创建新窗口的回调");
    NSLog(@"*********************");
    [self.webView loadRequest:navigationAction.request];
    return NULL;
}
//webview关闭时的回调
- (void)webViewDidClose:(WKWebView *)webView
{
    NSLog(@"webView关闭时的回调--%s",__func__);
}
//JS方面要直接弹窗的
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//JS方面要弹出一个带有确定或取消这种做选择的弹窗
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:webView.title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    [alertVC addAction:no];
    [alertVC addAction:yes];
    [self presentViewController:alertVC animated:yes completion:nil];
}
//JS方面弹出需要输入的窗口
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:webView.title message:UIActivityTypeMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"测试输入内容的JS";
    }];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertVC.textFields[0].text);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    [alertVC addAction:done];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}
@end
