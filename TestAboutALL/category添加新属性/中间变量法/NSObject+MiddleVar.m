//
//  NSObject+MiddleVar.m
//  TestAboutALL
//
//  Created by 周桐 on 16/10/25.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "NSObject+MiddleVar.h"

@implementation NSObject (MiddleVar)

static id _object = nil;
-(void)setObject:(id)object
{
    _object = object;
}
-(id)object{
    NSLog(@"_object地址 %p",_object);
    return _object;
}

@end
