//
//  TestKeychainViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/27.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TestKeychainViewController.h"
#import "ZTKeychainUtil.h"

static NSString * const dataDicKey = @"com.zac.app.dictionaryKey";
static NSString * const keychainKey = @"com.zac.app.keychainKey";


@interface TestKeychainViewController ()

- (IBAction)saveBtn:(id)sender;
- (IBAction)loadBtn:(id)sender;
- (IBAction)deleteBtn:(id)sender;

@property (nonatomic, strong) NSMutableDictionary *userNamePasswordDic;
@end

@implementation TestKeychainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)saveBtn:(id)sender {
    BOOL result = [ZTKeychainUtil createKeychainValue:@"my password goes like this" forIdentifier:keychainKey];
    NSLog(@"%@",result?@"成功":@"失败");
}

- (IBAction)loadBtn:(id)sender {
    NSData *reusltData = [ZTKeychainUtil searchKeychainCopyMatchingWithIdentifier:keychainKey];
    NSString *resultStr = [[NSString alloc]initWithData:reusltData encoding:NSUTF8StringEncoding];
    NSLog(@"密码是%@",resultStr);
    
}

- (IBAction)deleteBtn:(id)sender {
    [ZTKeychainUtil deleteWithIdentifier:keychainKey];
}

@end
