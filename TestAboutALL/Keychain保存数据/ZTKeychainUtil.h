//
//  ZTKeychainUtil.h
//  TestAboutALL
//
//  Created by Zac on 2017/2/27.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZTKeychainUtil : NSObject
+ (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier;
+ (NSData *)searchKeychainCopyMatchingWithIdentifier:(NSString *)identifier;
+ (void)deleteWithIdentifier:(NSString *)identifier;
@end
