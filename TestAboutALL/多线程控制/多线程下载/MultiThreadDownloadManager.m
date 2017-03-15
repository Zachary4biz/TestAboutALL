//
//  MultiThreadDownloadManager.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/23.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "MultiThreadDownloadManager.h"
#import "MultiThreadDownloader.h"

@interface MultiThreadDownloadManager()
@property (nonatomic, strong) NSMutableDictionary *assignmentDict;
@end

@implementation MultiThreadDownloadManager

#pragma mark - Lazy
- (NSMutableDictionary *)assignmentDict
{
    if (!_assignmentDict) {
        _assignmentDict = [NSMutableDictionary dictionary];
    }
    return _assignmentDict;
}

#pragma mark - Singleton
static id instance;
+ (instancetype)sharedInstance
{
    //static id instace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc]init];
    });
    return instance;
}

#pragma mark - public函数
- (void)dowloadAssignmentWithURL:(NSURL *)url andID:(NSString *)ID FilePath:(NSString *)filePath withProgressBlock:(void(^)(float progress,float speed))progressBlock
{
    //发送HEAD请求探探路
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"HEAD";
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"HEAD请求 - error - %@",error);
        }else{
            if (response.suggestedFilename) {
                //如果服务器有建议的名字，就用服务器给的名字
                NSString *fPath = filePath.stringByDeletingLastPathComponent;
                fPath = [fPath stringByAppendingPathComponent:response.suggestedFilename];
                NSLog(@"%@",filePath);
                //准备本地文件
                [self prepareFilePath:fPath FileSize:response.expectedContentLength];
                //使用downloader
                MultiThreadDownloader *downloaderM = [[MultiThreadDownloader alloc]init];
                [downloaderM downloadAssignmentWithID:ID
                                              andURL:url
                                          toFilePath:filePath
                            andExpectedContentLength:response.expectedContentLength];
                
                downloaderM.progressBlock = progressBlock;
                
                //保存downloaderID
                [self.assignmentDict setObject:downloaderM forKey:downloaderM.ID];
            }
        }
    }];
    [task resume];
    
}

- (void)suspendAssignmentWithID:(NSString *)ID
{
    MultiThreadDownloader *downloaderM = [self.assignmentDict valueForKey:ID];
    [downloaderM suspendAssignment];
}

- (void)resumeAssignmentWithID:(NSString *)ID
{
    MultiThreadDownloader *downloaderM = [self.assignmentDict valueForKey:ID];
    [downloaderM resumeAssignment];
    
}
#pragma mark - 封装
- (void)prepareFilePath:(NSString *)filePath FileSize:(NSUInteger)fileSize
{
    //首先检测filePath存不存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        //如果不存在就创建
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }else{
        NSLog(@"有重名文件！默认移除原始文件！");
        NSError *removeEr;
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&removeEr];
        if (removeEr) {
            NSLog(@"移除原始文件出错 -- %@",removeEr);
        }else{
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        }
    }
    //在filePath处创建相应大小的文件
    [[NSFileHandle fileHandleForWritingAtPath:filePath] truncateFileAtOffset:fileSize];
}
@end
