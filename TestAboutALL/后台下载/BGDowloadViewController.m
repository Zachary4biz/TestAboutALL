//
//  BGDowloadViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/17.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "BGDowloadViewController.h"
#import "ZTDownloader.h"
@interface BGDowloadViewController ()<NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;

@property (nonatomic, strong) ZTDownloader *downloader;

@property (nonatomic, strong) NSURLSessionDownloadTask *dTask;
@property (nonatomic, strong) NSData *resumeData;

@end

@implementation BGDowloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.downloader = [ZTDownloader new];
}
- (IBAction)downloadBtn:(id)sender {
    
    if (!self.dTask) {
        self.dTask = [self.downloader createBGDowloadWithURL:[NSURL URLWithString:self.textF.text]
                                       delegateOf:self
                                       resumeData:self.resumeData];
        [self.dTask resume];
    }else{
        switch (self.dTask.state) {
            case NSURLSessionTaskStateRunning:
                NSLog(@"dtask running");
                [self.downloader stopDownloadTask:self.dTask];
                break;
            case NSURLSessionTaskStateSuspended:
                NSLog(@"dTask suspending. 应该不会输出这句，下载任务的暂停应该用cancel而不是suspend，因为suspend只是针对那种临时停一小会的连接");
                [self.dTask resume];
                break;
            case NSURLSessionTaskStateCanceling:
                NSLog(@"dTask canceling. 应该不会输出到这里，我在cancel里把task=nil了");
                break;
            case NSURLSessionTaskStateCompleted:
            {
                NSLog(@"完成过一次任务，现在检查textField的内容是否是新的url");
                NSString *fileName = [self.downloader performSelector:@selector(md5:) withObject:self.textF.text];
                NSString *path = [self.downloader save2DocumentsWithName:fileName];
                BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
                if (isExist) {
                    NSLog(@"还是相同的url");
                }else{
                    self.dTask = [self.downloader createBGDowloadWithURL:[NSURL URLWithString:self.textF.text]
                                                              delegateOf:self
                                                              resumeData:self.resumeData];
                    [self.dTask resume];
                    self.progressV.progress = 0.0;
                }
                break;
            }
            default:
                break;
        }
        
    }
}



#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"后台下载完成后，来自AppDelegate的回调");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"下载完成------");
    NSString *fileName = [self.downloader performSelector:@selector(md5:) withObject:self.textF.text];

    NSURL *sU = [self.downloader save2DocumentsAsFileURLWithName:fileName];
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
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"error is %@",error);
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"%lld %lld %lld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressV setProgress:(totalBytesWritten*1.0/totalBytesExpectedToWrite) animated:YES];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}
@end
