//
//  ParentClass.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/19.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "ParentClass.h"

@interface ParentClass ()
@property (nonatomic, strong) NSString *nameExtensionParent;
@end

@implementation ParentClass
- (instancetype)init
{
    if (self = [super init]) {
        NSLog(@"ParentClass的init调用者是%@",self);//子类SubClass使用[super init]来到这里，此时self其实是SubClass
        self.nameHParent = @"nameFromH_Parent";
        self.nameExtensionParent = @"nameFromExtension_Parent";
    }
    return self;
}
@end
