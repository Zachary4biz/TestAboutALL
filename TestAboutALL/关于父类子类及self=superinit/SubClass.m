//
//  SubClass.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/19.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "SubClass.h"
@interface SubClass()
@property(nonatomic, strong) NSString *nameExtensionSub;
@end
@implementation SubClass
-(instancetype)init{
    if (self=[super init]) {
        self.nameHSub = @"nameHSub";
        self.nameExtensionSub = @"nameExtensionSub";
    }
    return self;
}

@end
