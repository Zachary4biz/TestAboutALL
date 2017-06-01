//
//  PathUtils.h
//  TestAboutALL
//
//  Created by Zac on 2017/4/17.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathUtils : NSObject
+ (NSString *)resumeDataDir;
+ (NSString *)homeDir;
+ (NSString *)tempDir;
+ (BOOL)isExistPath:(NSString *)path;
@end
