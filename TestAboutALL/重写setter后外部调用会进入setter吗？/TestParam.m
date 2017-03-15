//
//  TestParam.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/20.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TestParam.h"

@implementation TestParam
#warning getter！！！！！！！！ 
#warning 并且注意如果同时写了setter和getter，系统默认@property生成的就失效了，也就意味着_dict，_str1都要手动@synthesize str1=_str1
@synthesize str1 = _str1;
- (NSString *)str1{
    NSLog(@"进入了str的getter");
    if (!_str1) {
        _str1 = [NSString new];
    }
    return _str1;
}
@synthesize dict1 = _dict1;
- (NSMutableDictionary *)dict1{
    NSLog(@"进入了dict1的getter");
    if (!_dict1) {
        _dict1 = [[NSMutableDictionary alloc]init];
        [_dict1 setObject:@123 forKey:@"key1"];
    }
    return _dict1;
}

#warning 这才是setter!!!
- (void)setStr1:(NSString *)str1
{
    NSLog(@"正在设置str1的值为%@",str1);
}

- (void)setDict1:(NSMutableDictionary *)dict1
{
#warning 这里没有用到setter
    NSLog(@"正在设置dict的值为%@",dict1);
    _dict1 = dict1;
}
@end
