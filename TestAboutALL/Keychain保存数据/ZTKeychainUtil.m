//
//  ZTKeychainUtil.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/27.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "ZTKeychainUtil.h"
static NSString * const serviceName = @"com.zac.keychainUtil";

@implementation ZTKeychainUtil
+ (NSMutableDictionary *)getKeychainDicWithIdentifier:(NSString *)identifier
{
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    NSLog(@"创造的dic是 %@",searchDictionary);
    return searchDictionary;
}
+ (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier
{
    NSMutableDictionary *dictionary = [[self class] getKeychainDicWithIdentifier:identifier];
    //添加新的前，先把之前的旧的给删除了。
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    NSLog(@"SecItemAdd之后dictionary是 %@",dictionary);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

+ (NSData *)searchKeychainCopyMatchingWithIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[self class] getKeychainDicWithIdentifier:identifier];
    
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [searchDictionary setObject:@YES forKey:(__bridge id)kSecReturnPersistentRef];
    NSLog(@"SecItemCopyMatching之前的dictionary是 %@",searchDictionary);
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    NSLog(@"SecItemCopyMatching之后的dictionary是 %@",searchDictionary);
    if (status != errSecSuccess) {
        //没有success
        NSLog(@"查询keychain出错，状态码%d",status);
    }
    return (__bridge_transfer NSData *)result;
}

+ (void)deleteWithIdentifier:(NSString *)identifier
{
    NSMutableDictionary *keychainQueryDic = [[self class] getKeychainDicWithIdentifier:identifier];
    SecItemDelete((CFDictionaryRef)keychainQueryDic);
}


@end
