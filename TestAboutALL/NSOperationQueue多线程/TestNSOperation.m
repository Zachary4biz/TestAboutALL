//
//  TestNSOperation.m
//  TestAboutALL
//
//  Created by 周桐 on 16/12/30.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "TestNSOperation.h"

@interface TestNSOperation ()
@property (nonatomic, strong, readwrite) NSString *mark;
@end

@implementation TestNSOperation
- (instancetype)initWithMark:(NSString *)mark
{
    if (self = [super init]) {
        self.mark = mark;
    }
    return self;
}

-(void)main
{
    @autoreleasepool {
        for (int i=0; i<=1000; i++) {
            if (self.isCancelled) {
                break;
            }
            NSLog(@"%@-%f",self.mark,sqrt(i));
        }
    }
}
@end
