//
//  LearnAboutLoad.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/19.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "LearnAboutLoad.h"
#import <objc/runtime.h>

@implementation LearnAboutLoad
+ (void)load
{
    //重写了load方法之后，不论有没有调用到这个类都会跑到load，这样就可以在不入侵业务代码的情况下，做一些修改，业务代码完全不用做任何修改，这边直接用runtime去钩相应的类的方法就行了
    //IQKeyboard应该就是这样做的
    //load的调用时间是这个类被装载的时候，可以理解为程序开启的时候
    //常见的使用时，使用MethodSwizzle，进行行为打点
    [LearnAboutLoad sharedInstance];

}
/*
 按道理来说，这个sharedInstance单例方法是可以放在头文件的，但是对于目前这个应用来说，暂时还没有放出去的必要
 
 当业务方对这个单例产生配置需求的时候，就可以把这个函数放出去
 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static LearnAboutLoad *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LearnAboutLoad alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        /* 在这里做好方法拦截 */
        [self swizzle];//设置各个模块打点信息
        
    }
    return self;
}
- (void)swizzle
{
    //这里没有写好，参见apusBrowser的打点模块
    Method originalFunc = class_getInstanceMethod([self class], NSSelectorFromString(@"originalFunc"));
    Method swizzledFunc = class_getInstanceMethod([self class], NSSelectorFromString(@"swizzledFunc"));
    
    method_exchangeImplementations(originalFunc, swizzledFunc);
}
@end
