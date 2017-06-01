//
//  PathUtils.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/17.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "PathUtils.h"

@implementation PathUtils

+ (NSString *)tempDir
{
    return NSTemporaryDirectory();
}
+ (NSString *)homeDir
{
    return NSHomeDirectory();
}

+ (NSString *)resumeDataDir
{
    return [[self class] tempDir];
}

+ (BOOL)isExistPath:(NSString *)path
{
    NSFileManager *fM = [NSFileManager defaultManager];
    BOOL existed = [fM fileExistsAtPath:path];
    return existed;
}
@end
