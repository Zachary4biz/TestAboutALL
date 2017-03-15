//
//  Enum.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/23.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct MyFirstEnum {
    NSUInteger case0;
    NSUInteger case1;
} MyFirstEnum;

typedef enum : NSUInteger {
    EnumValue1,
    EnumValue2,
    EnumValue3,
} MySecondEnum;

//这是推荐方法
typedef NS_ENUM(NSInteger,wait_action){
    start = 0,
    stop
};

//枚举转字符串
typedef enum : NSUInteger {
    Bing = 0,
    Baidu,
} SearchEngineType;
#warning 这块相当于定义了一个const字典，内容是NSString
NSString *const SearchEngineTypeStr[]={
    [Bing] = @"Bing",
    [Baidu] = @"Baidu",
};


