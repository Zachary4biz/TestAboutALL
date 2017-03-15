//
//  WKWebViewTestViewController.h
//  TestAboutALL
//
//  Created by Zac on 2017/2/15.
//  Copyright © 2017年 周桐. All rights reserved.
//
#warning 尝试保存backForwardList到本地，让程序结束后再次进入还能前进后退，失败
#warning 后来改为在代理方法里面做手脚，成功了，大致就是把所有的URL都加载一遍，但是在代理-“页面开始加载”时就stoploading，然后再下一个响应的代理里面继续加载URL数组里面的下一个URL直到最后一个。然后gotoBackForwardListItem
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface WKWebViewTestViewController : UIViewController

@end
