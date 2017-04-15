//
//  TestCodeOfFramework.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/10.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TestCodeOfFramework.h"

@implementation TestCodeOfFramework


- (void)startAddOnBeginner
{
    for (int i=0; i<=10; i++) {
        self.beginner++;
    }
    NSLog(@"beginner is %d",self.beginner);
}
@end
