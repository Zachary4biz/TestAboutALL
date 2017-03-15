//
//  ZTRuntimeUtil.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/2.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "ZTRuntimeUtil.h"
#import <objc/runtime.h>
@implementation ZTRuntimeUtil
//获取类名
+ (NSString *)fetchClassName:(Class)aClass{
    //class_getName返回的是一个类的名称（类型是char指针）
    const char *className = class_getName(aClass);
    return [NSString stringWithUTF8String:className];
}

//获取成员变量
/*
 * 类型（基本类型才是这样，引用类型如NSArray就是@NSArray）
 * q -> NSInteger
 * i -> int
 * c -> bool
 * d -> double
 * f -> float
 */
+ (NSArray *)fetchIvarList:(Class)aClass{
    unsigned int count=0;
    Ivar *ivarList = class_copyIvarList(aClass, &count);
    
    NSMutableArray *dicArr = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i=0;i<count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *ivarName = ivar_getName(ivarList[i]);
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
        dic[@"type"] = [NSString stringWithUTF8String:ivarType];
        dic[@"name"] = [NSString stringWithUTF8String:ivarName];
        [dicArr addObject:dic];
    }
    free(ivarList);
    return [NSArray arrayWithArray:dicArr];
}

//获取成员属性（包括私有、公有以及定义在extension中的属性）
+ (NSArray *)fetchPropertyList:(Class)aClass{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(aClass, &count);
    NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:count];
    for(unsigned int i=0;i<count;i++){
        const char *propertyName = property_getName(propertyList[i]);
        [nameArr addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertyList);
    return [NSArray arrayWithArray:nameArr];
}

//获取类的实例方法
+ (NSArray *)fetchMethodList:(Class)aClass{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(aClass,&count);
    
    NSMutableArray *methodArr = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i=0; i<count; i++) {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        [methodArr addObject:NSStringFromSelector(methodName)];
    }
    free(methodList);
    return [NSArray arrayWithArray:methodArr];
}

//获取协议列表
+ (NSArray *)fetchProtocolList:(Class)aClass{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(aClass,&count);
    
    NSMutableArray *protocolArr = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i=0; i<count; i++) {
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        [protocolArr addObject:[NSString stringWithUTF8String:protocolName]];
    }
    return [NSArray arrayWithArray:protocolArr];
}

+ (NSDictionary *)fetchALLFrom:(Class)aClass
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"Ivar"] = [[self class] fetchIvarList:aClass];
    dic[@"Property"] = [[self class] fetchPropertyList:aClass];
    dic[@"Method"] = [[self class] fetchMethodList:aClass];
    dic[@"Protocol"] = [[self class] fetchProtocolList:aClass];
    
    return dic;
}
//添加方法
//+ (void)addMethodTo:(Class)aClass method:(SEL)methodSel method:(SEL)methodSelImp
//{
//    Method method = class_getInstanceMethod(aClass, methodSel);
//    IMP methodIMP = method_getImplementattion(method);
//    const char *types = method_getTypeEncoding(method);
//    class_addMethod(aClass,methodSel,methodIMP,types);
//}
@end
