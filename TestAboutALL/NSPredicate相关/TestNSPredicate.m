//
//  TestNSPredicate.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/17.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TestNSPredicate.h"

@implementation TestNSPredicate
- (instancetype)initWithStr1:(NSString *)str1 Str2:(NSString *)str2
{
    if (self = [super init]) {
        self.str1 = str1;
        self.str2 = str2;
    }
    return self;
}
@end
