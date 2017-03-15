//
//  URLProtocolTest.h
//  TestAboutALL
//
//  Created by Zac on 2017/2/28.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLProtocol+WebKitSupport.h"

static BOOL _shouldUseLocalCache = NO;
@interface URLProtocolTest : NSURLProtocol
+ (void)setShouldUseLocalCache:(BOOL)ShouldUseLocalCache;
+ (BOOL)getShouldUseLocalCache;
@end
