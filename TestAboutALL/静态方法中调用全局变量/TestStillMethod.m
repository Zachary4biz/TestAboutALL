//
//  TestStillMethod.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/10.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TestStillMethod.h"

static NSInteger _value = 0;
@implementation TestStillMethod
+ (void)setValue:(NSInteger)value
{
    _value = value;
}
+ (NSInteger)getValue
{
    return _value;
}
@end
