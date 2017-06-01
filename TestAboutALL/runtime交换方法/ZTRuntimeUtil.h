//
//  ZTRuntimeUtil.h
//  TestAboutALL
//
//  Created by Zac on 2017/3/2.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTRuntimeUtil : NSObject
/**
 获得某个class的名字
 */
+ (NSString *)fetchClassName:(Class)aClass;

/**
  获取所有变量

 */
+ (NSArray *)fetchIvarList:(Class)aClass;

/**
 获取所有成员变量（包括私有、公有以及定义在extension中的属性）
 */
+ (NSArray *)fetchPropertyList:(Class)aClass;
/**
  获取类的实例方法
 */
+ (NSArray *)fetchMethodList:(Class)aClass;

/**
  获取类的所有协议
 */
+ (NSArray *)fetchProtocolList:(Class)aClass;

/**
 获取所有内容（变量、属性、方法、协议）
 返回一个字典
 键：Ivar、Property、Method、Protocol
 */
+ (NSDictionary *)fetchALLFrom:(Class)aClass;

@end

typedef enum : NSUInteger {
    ZTRuntimeUtilOptionBefore, //在方法调用前调动block
    ZTRuntimeUtilOptionAfter, //在方法调用后调用block
    ZTRuntimeUtilOptionReplace, //用block替代方法
} ZTRuntimeUtilOption;
//runtime 添加函数之类的，首先做NSObject的category
@interface NSObject (ZTRuntimeUtilMethods)
//处理Selector(实例方法）
- (void)addHookManageSelector:(SEL)selector
               withOption:(ZTRuntimeUtilOption)option
                withBlock:(id)block;
@end
