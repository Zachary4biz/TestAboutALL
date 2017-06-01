//
//  NSInvocationViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/20.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "NSInvocationViewController.h"

@interface NSInvocationViewController ()

@end

@implementation NSInvocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)invokeBtn:(id)sender {
    //使用NSInvocation
    NSString* resultStr;
    
    NSString* string = @"Hello";
    NSString* stringToAppend = @" World!";
    
    //使用方法选择器selector选择到方法，然后获取到方法的签名
    NSMethodSignature *methodSign = [NSString instanceMethodSignatureForSelector:@selector(stringByAppendingString:)];
    //使用这个方法签名创建NSInvocation
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:methodSign];
    //设置调用这个NSInvocation的对象
    [inv setTarget:string];
    //设置这个NSInvocation的参数 （注意参数的0,1被内部占用了，第一个参数传self(即target) 第二个参数传selecort）
    //需要从atIndex:2开始设置参数
    [inv setArgument:&stringToAppend atIndex:2];
    //开始调用NSInvocation
    [inv invoke];
    //获取返回值，通过传址实现结果传递
    [inv getReturnValue:&resultStr];
    
    NSLog(@"result invoke is %@",resultStr);
}

- (IBAction)normalBtn:(id)sender {
    //实现如下的功能
    NSString* string = @"Hello";
    NSString* anotherString = [string stringByAppendingString:@" World!"];
    NSLog(@"result normal is %@",anotherString);
}


@end
