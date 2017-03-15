//
//  ZTRuntimeUtil.h
//  TestAboutALL
//
//  Created by Zac on 2017/3/2.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTRuntimeUtil : NSObject
+ (NSString *)fetchClassName:(Class)aClass;

+ (NSArray *)fetchIvarList:(Class)aClass;

+ (NSArray *)fetchPropertyList:(Class)aClass;

+ (NSArray *)fetchMethodList:(Class)aClass;

+ (NSArray *)fetchProtocolList:(Class)aClass;

+ (NSDictionary *)fetchALLFrom:(Class)aClass;
@end
