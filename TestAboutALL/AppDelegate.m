//
//  AppDelegate.m
//  TestAboutALL
//
//  Created by 周桐 on 16/10/25.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"
#import "KVOViewController.h"
#import "ViewController.h"
#import "MyViewController.h"
#import "LifeCycleTableViewController.h"
#import "TestViewController.h"
#import "TestRunLoopAndWhileViewController.h"
#import "CopyAndMuttableCopyViewController.h"
#import "NSPredicateTestViewController.h"
#import "GestureTestViewController.h"
#import "AFNetworking.h"
#import "WKWebViewTestViewController.h"
#import "BaiduAPITestViewController.h"
#import "URLComponentTestViewController.h"
#import "TestParamViewController.h"
#import "CategoryTestViewController.h"
#import "TestDictionaryViewController.h"
#import "WKWebViewAnotherTestViewController.h"
#import "PythonTestViewController.h"
#import "MultiThreadDownloadViewController.h"
#import "TimersTestViewController.h"
#import "TestKeychainViewController.h"
#import "URLProtocolTest.h"
#import "URLProtocolTestViewController.h"
#import "UIKitTestViewController.h"
#import "AppiumViewController.h"
#import "UploadImageViewController.h"
#import "ThreeDTransformViewController.h"
#import "TestExtraFieldViewController.h"
#import "GradientTestViewController.h"
#import "AntiAliasingViewController.h"
#import "BtnTestViewController.h"
#import "BlockTestViewController.h"
#import "PhotoLibViewController.h"
@interface AppDelegate ()

@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSURLProtocol registerClass:[URLProtocolTest class]];
    [NSURLProtocol wk_registerScheme:@"http"];
    [NSURLProtocol wk_registerScheme:@"https"];
    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
//    self.window.rootViewController = [[TableViewController alloc]init];
//    self.window.rootViewController = [[KVOViewController alloc]init];
//    self.window.rootViewController = [[ViewController alloc]init];
//    self.window.rootViewController = [[MyViewController alloc]init];
//    self.window.rootViewController = [[LifeCycleTableViewController alloc]init];
//    self.window.rootViewController = [[TestViewController alloc]init];
//    self.window.rootViewController = [[TestRunLoopAndWhileViewController alloc]init];
//    self.window.rootViewController = [[CopyAndMuttableCopyViewController alloc]init];
//    self.window.rootViewController = [[NSPredicateTestViewController alloc]init];
//    self.window.rootViewController = [[GestureTestViewController alloc]init];
//    self.window.rootViewController = [[WKWebViewTestViewController alloc]init];
//    self.window.rootViewController = [[BaiduAPITestViewController alloc]init];
//    self.window.rootViewController = [[URLComponentTestViewController alloc]init];
//    self.window.rootViewController = [[TestParamViewController alloc]init];
//    self.window.rootViewController = [[CategoryTestViewController alloc]init];
//    self.window.rootViewController = [[TestDictionaryViewController alloc]init];
//    self.window.rootViewController = [[WKWebViewAnotherTestViewController alloc]init];
//    self.window.rootViewController = [[PythonTestViewController alloc]init];
    
    //xib中是有一个VC,这个VC是属于我的代码VC的，所以加载那个VC
//    self.window.rootViewController = [[[NSBundle mainBundle] loadNibNamed:@"MultiThread" owner:nil options:nil] lastObject];
    
    //XIB中是一个view（创建时勾选自动创建xib就是这样），而整体xib有fileOwner——>代码VC
//    self.window.rootViewController = [[TestKeychainViewController alloc] initWithNibName:nil bundle:nil];
//    self.window.rootViewController = [[TestKeychainViewController alloc]init];
    
    
//    self.window.rootViewController = [[[NSBundle mainBundle]loadNibNamed:@"UIKitTestViewController"owner:nil options:nil] firstObject];
    
    
//    self.window.rootViewController = [[[NSBundle mainBundle]loadNibNamed:@"TestMultiVC"owner:nil options:nil] firstObject];

//    self.window.rootViewController = [[URLProtocolTestViewController alloc]init];
//    self.window.rootViewController = [[TimersTestViewController alloc]init];
    
//    self.window.rootViewController = [[AppiumViewController alloc]initWithNibName:@"AppiumViewController" bundle:[NSBundle mainBundle]];
    
//    self.window.rootViewController = [[UploadImageViewController alloc]init];
//    self.window.rootViewController = [[ThreeDTransformViewController alloc]init];
//    self.window.rootViewController = [[TestExtraFieldViewController alloc]init];
//    self.window.rootViewController = [[GradientTestViewController alloc]init];
//    self.window.rootViewController = [[AntiAliasingViewController alloc]init];
    
    
//    self.window.rootViewController = [[BtnTestViewController alloc]init];
//    self.window.rootViewController = [[BlockTestViewController alloc]init];
    self.window.rootViewController = [[PhotoLibViewController alloc]init];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
