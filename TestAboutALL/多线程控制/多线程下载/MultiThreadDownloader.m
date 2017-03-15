//
//  MultiThreadDownloader.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/23.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "MultiThreadDownloader.h"

@interface ZTDownloader : NSObject
//文件读写
@property (nonatomic, strong) NSFileHandle *writeHandle;
@property (nonatomic, assign) NSUInteger fileLength;
@property (nonatomic, assign) NSUInteger currentLength;
@property (nonatomic, assign) NSUInteger writeBeginPoint;
@property (nonatomic, assign) ZTRange range;
@property (nonatomic, strong) NSString *ID;

//网络请求
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableURLRequest *request;


- (void)downloadWithRequest:(NSMutableURLRequest *)request
                      andID:(NSString *)ID
                   FilePath:(NSString *)filePath
                  inSession:(NSURLSession *)session
                withZTRange:(ZTRange)range;
- (void)suspend;
- (void)resume;
@end

@implementation ZTDownloader
- (void)downloadWithRequest:(NSMutableURLRequest *)request
                      andID:(NSString *)ID
                   FilePath:(NSString *)filePath
                  inSession:(NSURLSession *)session
                withZTRange:(ZTRange)range
{
    //本地文件 - 写入
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    self.writeBeginPoint = range.begin;
    self.range = range;
    [self.writeHandle seekToFileOffset:self.writeBeginPoint];
    
    self.ID = ID;
    //网路请求x
    self.session = session;
    self.request = request;
    self.dataTask = [self.session dataTaskWithRequest:self.request];
    [self.dataTask resume];
}

- (void)suspend
{
    [self.dataTask suspend];
    NSLog(@"写了多少        is %lld",self.dataTask.countOfBytesReceived);
    [self.dataTask cancel];
    self.dataTask = nil;
    
    NSLog(@"挂起--\n");
    NSLog(@"begin         is %ld",self.range.begin);
    NSLog(@"从哪开始写      is %ld",self.writeBeginPoint);
    NSLog(@"写了多少        is %ld",self.currentLength);
    
    NSLog(@"写到哪里了      is %ld",self.writeBeginPoint+self.currentLength);
    NSLog(@"resume should be %ld",(self.writeBeginPoint+self.currentLength+1));
    NSLog(@"end           is %ld",self.range.end);
    NSLog(@"-------");
    
    [[NSUserDefaults standardUserDefaults] setObject:@(self.writeBeginPoint+self.currentLength+1) forKey:self.ID];
}

- (void)resume
{

    //self.writeBeginPoint -- 表示要从哪里开始写，也意味着之前对这个任务一共下载了多少，类似totalWrittenData
    self.writeBeginPoint = [[[NSUserDefaults standardUserDefaults] objectForKey:self.ID] integerValue];
    
    NSLog(@"恢复--\n");
    NSLog(@"begin          is %ld",self.range.begin);
    NSLog(@"从哪开始         is %ld",self.writeBeginPoint);
    NSLog(@"end            is %ld",self.range.end);
    NSLog(@"-------");
    [self.writeHandle seekToFileOffset:self.writeBeginPoint];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.request.URL];
    NSString *rangeHeader = [NSString stringWithFormat:@"bytes=%ld-%ld",self.writeBeginPoint,_range.end];
    [request setValue:rangeHeader forHTTPHeaderField:@"Range"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    self.request = request;
    self.dataTask = [self.session dataTaskWithRequest:self.request];
    [self.dataTask resume];
    
}
@end


@interface MultiThreadDownloader()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *task1;
@property (nonatomic, strong) NSURLSessionDataTask *task2;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) NSUInteger contentLength;
@property (nonatomic, assign) NSUInteger currentLenght;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSFileHandle *writeHandle1;
@property (nonatomic, strong) NSFileHandle *writeHandle2;

@property (nonatomic, strong) ZTDownloader *downloader1;
@property (nonatomic, strong) ZTDownloader *downloader2;
@property (nonatomic, copy) NSString *ID;

@end
/*
 * 流程：
 * downloadAssignmentWithID - 发送一个self.task0请求
 * didReceiveResponse       - 回调获得资源大小，中断self.task0请求
 *    getRequestWithURL       - 分片资源，然后封装不同的requestHeader
 *    self.task1 task2        - 分别请求两个request，并且挂载有自己的outputStream从不同的位置往文件中写
 */
@implementation MultiThreadDownloader
#pragma mark - Lazy
- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
    }
    return _session;
}

- (ZTDownloader *)downloader1
{
    if(!_downloader1){
        _downloader1 = [[ZTDownloader alloc]init];
    }
    return _downloader1;
}

- (ZTDownloader *)downloader2
{
    if(!_downloader2){
        _downloader2 = [[ZTDownloader alloc]init];
    }
    return _downloader2;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
//#warning 这里还可以设置NSURLSessionResponseBecomeDownload，不直到会怎么样
        completionHandler(NSURLSessionResponseAllow);

}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    float before = self.downloader1.currentLength+self.downloader2.currentLength;
    //判断是哪个downloader进入的回调
    if (dataTask == self.downloader1.dataTask) {
        [self.downloader1.writeHandle writeData:data];
        self.downloader1.currentLength += data.length;
    }else if (dataTask == self.downloader2.dataTask){
        [self.downloader2.writeHandle writeData:data];
        self.downloader2.currentLength += data.length;
    }
    //计算进度
    float progress = 1.0*(self.downloader1.writeBeginPoint+self.downloader2.writeBeginPoint-self.downloader2.range.begin+self.downloader1.currentLength+self.downloader2.currentLength)/self.contentLength;
    //计算速度
    float after = self.downloader1.currentLength+self.downloader2.currentLength;
    float speed = (after - before)/1024;
    
    if (_progressBlock) {
        _progressBlock(progress,speed);
    }

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (task == self.downloader1.dataTask) {
        [self.downloader1.writeHandle closeFile];
        if (error) {
            NSLog(@"task1 - error -- %@",error);
        }else{
            NSLog(@"task1 完成");
        }
    }else if (task == self.downloader2.dataTask){
        [self.downloader2.writeHandle closeFile];
        if (error) {
            NSLog(@"task2 - error -- %@",error);
        }else{
            NSLog(@"task2 完成");
        }
    }
    
}

#pragma mark - 配置request
- (NSMutableURLRequest *)getRequestWithURL:(NSURL *)url andContentRange:(ZTRange)range
{
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    NSString *rangeHeader = [NSString stringWithFormat:@"bytes=%ld-%ld",range.begin,range.end];
    [requestM setValue:rangeHeader forHTTPHeaderField:@"Range"];
    [requestM setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    return requestM;
}
#pragma mark - 配置ZTDownloader
- (void)setUpZTDownloaderWithExpectedContentLength:(NSUInteger)expectedContentLength
{
    //将请求分片
    ZTRange firstHalf,secondHalf;
    firstHalf.begin = 0;
    firstHalf.end = expectedContentLength/2;
    secondHalf.begin = firstHalf.end+1;
    secondHalf.end = expectedContentLength;
    
    //创建两个request
    NSMutableURLRequest *request1 = [self getRequestWithURL:self.url andContentRange:firstHalf];
    NSMutableURLRequest *request2 = [self getRequestWithURL:self.url andContentRange:secondHalf];
    
    NSString *ID1 = [self.ID stringByAppendingString:@"_1"];
    NSString *ID2 = [self.ID stringByAppendingString:@"_2"];
    [self.downloader1 downloadWithRequest:request1
                                    andID:ID1
                                 FilePath:self.filePath
                                inSession:self.session
                              withZTRange:firstHalf];
    [self.downloader2 downloadWithRequest:request2
                                    andID:ID2
                                 FilePath:self.filePath
                                inSession:self.session
                              withZTRange:secondHalf];
    
}
#pragma mark - public函数
- (void)downloadAssignmentWithID:(NSString *)ID
                          andURL:(NSURL *)URL
                      toFilePath:(NSString *)filePath
        andExpectedContentLength:(NSUInteger)expectedContentLength
{
    self.ID = ID;
    self.url = URL;
    self.filePath = filePath;
    self.contentLength = expectedContentLength;
    
    [self setUpZTDownloaderWithExpectedContentLength:self.contentLength];
    
}

- (void)suspendAssignment
{
    [self.downloader1 suspend];
    [self.downloader2 suspend];
}

- (void)resumeAssignment
{
    [self.downloader1 resume];
    [self.downloader2 resume];
}
//- (void)resumeAssignmentWithID:(NSString *)ID;
//
//- (void)cancelAssignmentWithID:(NSString *)ID;
//
//- (void)removeAssignmentWithID:(NSString *)ID;
@end
