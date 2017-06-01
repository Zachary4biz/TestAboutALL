
//
//  ZTDownloader.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/17.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "ZTDownloader.h"
#import <CommonCrypto/CommonDigest.h>
@interface ZTDownloader()<NSURLSessionDelegate>
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *resumeDataDir;
@property (nonatomic, strong) NSURLSession *session;

@end
@implementation ZTDownloader
- (NSString *)resumeDataDir
{
    if(!_resumeDataDir){
        _resumeDataDir = NSTemporaryDirectory();
    }
    return _resumeDataDir;
}

NSString *configID = @"configID";
- (void)createSessionWithDelegateTarget:(nullable id <NSURLSessionDelegate>)delegateTarget
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:configID];
    // 只要是用backgroundSessionConfigurationWithIdentifier创建的，默认就是YES，但还是手动写一下把
    config.sessionSendsLaunchEvents = YES;
    config.discretionary = YES;
    NSURLSession *session;
    if (delegateTarget) {
        session = [NSURLSession sessionWithConfiguration:config
                                                delegate:delegateTarget
                                           delegateQueue:[NSOperationQueue new]];
    }else{
        session = [NSURLSession sessionWithConfiguration:config
                                                delegate:self
                                           delegateQueue:[NSOperationQueue new]];
    }
    self.session = session;
}
- (NSURLSessionDownloadTask *)createBGDowloadWithURL:(NSURL *)url delegateOf:(nullable id <NSURLSessionDelegate>)delegateTarget resumeData:(NSData * _Nullable)resumeData
{
    self.url = url;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self createSessionWithDelegateTarget:delegateTarget];
    });
    
    
    NSURLSessionDownloadTask *dTask;
    if (resumeData) {
        dTask = [self.session downloadTaskWithResumeData:resumeData];
    }else{
        dTask = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:url]];
    }
    
    return dTask;
}
- (void)stopDownloadTask:(NSURLSessionDownloadTask *)task
{
    __block NSURLSessionDownloadTask* Btask = task;
    [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        if (!resumeData) {
            NSLog(@"Error---> resumedata为空");
        }else{
            NSString *dataPath = self.resumeDataDir;
            //用URL的MD5来当文件名
            NSString *dataFileName = [self md5:self.url.absoluteString];
            dataPath = [dataPath stringByAppendingPathComponent:dataFileName];
            //写入
            BOOL success = [resumeData writeToFile:dataPath atomically:YES];
            if (!success) {
                NSLog(@"Error--->写入失败");
            }else{
                Btask = nil;
            }
        }
    }];
}

- (NSData *)getResumeDataOfURL:(NSURL *)url
{
    NSString *fileName = [self md5:url.absoluteString];
    NSData *rD =[NSData dataWithContentsOfFile:[self.resumeDataDir stringByAppendingPathComponent:fileName]];
    return rD;
}

- (NSString *)md5:(NSString *)key
{
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }

    unsigned char r[CC_MD5_DIGEST_LENGTH];//就是r[16]
    CC_MD5(str, (CC_LONG)strlen(str), r);//MD5处理str，结果存到r数组中
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}
- (NSURL *_Nonnull)save2DocumentsAsFileURLWithName:(NSString *_Nonnull)name
{
    NSString *preFix = @"file://";
    preFix = [preFix stringByAppendingString:[self save2DocumentsWithName:name]];
    return [NSURL URLWithString:preFix];
}
- (NSString *_Nonnull)save2DocumentsWithName:(NSString *_Nonnull)name
{
    NSString *sP=[NSString string];
    sP = [sP stringByAppendingString:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]];
    sP = [sP stringByAppendingPathComponent:name];
    return sP;
}

#pragma mark - NSURLSessionDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"后台下载完成后，来自AppDelegate的回调");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载完成------");
    NSURL *sU = [self save2DocumentsAsFileURLWithName:location.lastPathComponent];
    NSError *er = nil;
    
    [[NSFileManager defaultManager] copyItemAtURL:location
                                            toURL:sU
                                            error:&er];
    if (er) {
        NSLog(@"err %@",er);
        if ([er.userInfo[NSUnderlyingErrorKey] code] == 17) {
            NSError *er2 = nil;
            [[NSFileManager defaultManager] replaceItemAtURL:sU withItemAtURL:location backupItemName:@"newItem" options:0 resultingItemURL:NULL error:&er2];
            if (er2) {
                NSLog(@"er2 %@",er2);
            }
        }
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"%lld %lld %lld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}
@end
