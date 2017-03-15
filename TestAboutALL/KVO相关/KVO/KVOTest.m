//
//  KVOTest.m
//  TestAboutALL
//
//  Created by 周桐 on 16/10/25.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "KVOTest.h"
#import "objClass.h"
@implementation KVOTest

-(void)createKVO
{
    [self.obj addObserver:self forKeyPath:@"propertyA" options:NSKeyValueObservingOptionNew context:@"observerOfKVOTest"];
    
}

-(void)dealloc
{
//这里就涉及到context的应用了！
//因为有一种情况是父类对这个obj做了KVO，子类也对这个obj做了KVO，在removeObserver的时候，可能父类remove一次子类也remove一次，会造成crash，所以可以在addObserver时给它指定context
    
    [self.obj removeObserver:self forKeyPath:@"propertyA" context:@"observerKVOTest"];
    
}


//KVO默认的回调方法，所有都走这个方法，所以要在里面做一下判断
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context
{
    if (object == self.obj && [keyPath isEqualToString:@"propertyA"]) {
        [self doSomething];
        NSLog(@"object is :%@",object);
        NSLog(@"change is :%@",change);
        NSLog(@"context is :%@",context);
    }else{
//注意这里，因为所有的KVO都走这里，所以父类甚至super-super的KVO也会跑到这里来，如果不加这个，会导致KVO在这里断链，
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }

}
//KVO监听到改变
-(void)doSomething
{
    NSLog(@"KVO变化---------");
}
@end
