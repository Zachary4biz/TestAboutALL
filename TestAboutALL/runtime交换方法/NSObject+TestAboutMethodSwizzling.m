//
//  NSObject+TestAboutMethodSwizzling.m
//  TestAboutALL
//
//  Created by 周桐 on 16/11/30.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "NSObject+TestAboutMethodSwizzling.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
@implementation NSObject (TestAboutMethodSwizzling)
- (void)makeSwizzlingWithTarget:(UIViewController *)targetVC
{
    Method originalMethod = class_getInstanceMethod([targetVC class], @selector(viewDidDisappear:));
    Method newMethod = class_getInstanceMethod([self class], @selector(swizzlingViewDidDisappear));
    //判断一下目标class有没有实现viewDidDisappear，如果没有的话盲目交换会失败
    if (!class_addMethod([targetVC class], @selector(viewDidDisappear:), method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        //如果添加方法失败了，说明这个targetVC实现了viewDidDisappear，可以进行交换
        method_exchangeImplementations(originalMethod, newMethod);
    }else{
        /*
         *添加成功就说明之前没有实现过，
         *这时候要小心了，如果之前没有实现viewDidDisappear，那还不能直接把newMethod搞进去
         *因为我们做的时候，是假设他实现过的，也就是我们是能成功交换
         *因此会在我们的newMethod中在调用一遍newMethod，虽然看起来是递归了，但是实际上这时候已经被替换了
         *调用newMethod就是在调用originalMethod了
         *那么如果没有实现originalMethod，就没有交换
         *没有交换就递归死循环了
         *那就做个新的方法swizzlingViewDidDisappearAnother，不调用自己就行了
         */
        Method originalMethodAnother = class_getInstanceMethod([self class], @selector(swizzlingViewDidDisappear));
        Method newMethodAnother = class_getInstanceMethod([self class], @selector(swizzlingViewDidDisappearAnother));
        method_exchangeImplementations(originalMethodAnother, newMethodAnother);
    }
    
}

- (void)swizzlingViewDidDisappear
{
    //调用这个用来交换的方法，实际上就是在调用目标（被交换）方法
    [self swizzlingViewDidDisappear];
    //接下来就是在实现了targetVC本身的viewDidDisappear要干的事情后再做我们的事情
    NSLog(@"成功交换");
}
- (void)swizzlingViewDidDisappearAnother
{
    NSLog(@"成功交换");
}
@end
