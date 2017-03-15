//
//  main.m
//  TestAboutALL
//
//  Created by 周桐 on 16/10/25.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


int main(int argc, char * argv[]) {
    //如果崩溃了会把崩溃信息写到本地Caches目录中的errorLog.txt文件
    @try{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    }
    @catch(NSException *exception){
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        info[@"callStack"] = [exception callStackSymbols];
        info[@"name"] = [exception name];
        info[@"reason"] = [exception reason];
        
        NSString *cahcesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath =[cahcesDirectory stringByAppendingPathComponent:@"errorLog.txt"];
        [info writeToFile:filePath atomically:YES];
    }
}
