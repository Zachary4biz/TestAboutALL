//
//  NSObject+Category4NSObjectTestRuntime.m
//  TestAboutALL
//
//  Created by 周桐 on 16/10/25.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "NSObject+Category4NSObjectTestRuntime.h"
#import <UIKit/UIKit.h>

#include <objc/runtime.h>

@implementation NSObject (Category4NSObjectTestRuntime)

//static id objectKey = nil;
//
//-(void)setZTObject:(id)ZTObject{
//    //参数一：给哪个对象添加关联
//    //参数二：关联的key，通过这个key获取
//    //参数三：关联的value
//    //参数四：关联策略 ？
//    
//    objc_setAssociatedObject(self,(__bridge const void *)(objectKey),ZTObject,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
//}
//
//-(id)ZTObject{
//    return objc_getAssociatedObject(self, (__bridge const void *)(objectKey));
//}
//两种方法都可以
static void *strKey = &strKey;

- (void)setZTObject:(id)ZTObject
{
    objc_setAssociatedObject(self, &strKey, ZTObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)ZTObject
{
    return objc_getAssociatedObject(self, &strKey);
}

//这里是尝试添加一个NSUInteger，初始类型是id
static void *integerKey = &integerKey;

- (void)setAnInteger:(id)anInteger
{
    objc_setAssociatedObject(self, &integerKey, anInteger, OBJC_ASSOCIATION_ASSIGN);
}
-(id)anInteger
{
    id anInteger = objc_getAssociatedObject(self, &integerKey);
    NSUInteger integerValueOfit = [anInteger integerValue];
    return objc_getAssociatedObject(self, &integerKey);
}

//尝试添加一个BOOL类型
static void *boolKey = &boolKey;

- (void)setABOOL:(id)aBOOL
{
    objc_setAssociatedObject(self, &boolKey, aBOOL, OBJC_ASSOCIATION_ASSIGN);
}
-(id)aBOOL
{
    return objc_getAssociatedObject(self, &boolKey);
}

@end
