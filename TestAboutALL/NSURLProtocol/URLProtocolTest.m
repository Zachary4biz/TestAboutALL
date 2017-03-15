//
//  URLProtocolTest.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/28.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "URLProtocolTest.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
typedef NS_ENUM(NSInteger,MyCase)
{
    clearIMGCase=0,
    cacheCase,
    redirectCase,
};
@interface ZTCache:NSObject<NSCoding>
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSURLRequest *request;
@end

@implementation ZTCache
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.data forKey:@"data"];
    [aCoder encodeObject:self.response forKey:@"response"];
    [aCoder encodeObject:self.request forKey:@"request"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.data = [aDecoder decodeObjectForKey:@"data"];
        self.response = [aDecoder decodeObjectForKey:@"response"];
        self.request = [aDecoder decodeObjectForKey:@"request"];
    }
    return self;
}
@end

@interface URLProtocolTest() <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
//缓存用
@property (nonatomic, strong) NSURLSession *cacheSession;
@property (nonatomic, strong) NSURLSessionDataTask *cacheTask;
@property (nonatomic, strong) NSString *cachePath;
@property (nonatomic, strong) NSMutableData *cacheData;
@property (nonatomic, strong) NSURLResponse *cacheResponse;




@end
@implementation URLProtocolTest

static MyCase myCase = cacheCase;
//static MyCase myCase = clearIMGCase;
+ (void)setShouldUseLocalCache:(BOOL)ShouldUseLocalCache
{
    _shouldUseLocalCache = ShouldUseLocalCache;
}
+ (BOOL)getShouldUseLocalCache
{
    return _shouldUseLocalCache;
}
- (NSMutableData *)cacheData
{
    if(!_cacheData){
        _cacheData = [[NSMutableData alloc]init];
    }
    return _cacheData;
}

- (NSURLSession *)cacheSession
{
    if(!_cacheSession){
        _cacheSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
    }
    return _cacheSession;
}
- (NSURLSession *)session
{
    if(!_session){
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
    }
    return _session;
}
static NSString * const initKey = @"initKey";

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mR = [request mutableCopy];
    NSString *str = mR.allHTTPHeaderFields[@"ZTUseCache"];
    if (str) {
        _shouldUseLocalCache = [str isEqualToString:@"YES"]? YES:NO;
    }
    
    NSLog(@"NSPROTOCOL 拦截到请求 - %@",request.URL);
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:initKey inRequest:request]) {
            return NO;
        }else{
            switch (myCase) {
                case clearIMGCase:
                    return [[self class] isImageOfRequest:request];
                    break;
                case cacheCase:
                    return YES;
                    break;
                case redirectCase:
                    return YES;
                default:
                    break;
            }
            
        }
    }
    return NO;
}
//检测图片
+ (BOOL)isImageOfRequest:(NSURLRequest *)request
{
    BOOL isImage = [@[@"png", @"jpeg", @"gif", @"jpg"] indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [request.URL.pathExtension compare:obj options:NSCaseInsensitiveSearch] == NSOrderedSame;
    }] != NSNotFound;
    
    return isImage;
}
//返回自己处理过的request，没有特殊需求就返回当前的。可以用来做比如 重定向、请求头重新设置
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

//用于判断自己的自定义request有没有缓存过，有的话就使用缓存而不是再次请求，一般用父类的默认实现就行了
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

//发起请求
- (void)startLoading
{
    NSLog(@"startLoading NSPROTOCOL - %@",self.request.URL.absoluteString);
    NSMutableURLRequest *Mrequest = [self.request mutableCopy];
    
    //标记防止递归调用
    [NSURLProtocol setProperty:@YES forKey:initKey inRequest:Mrequest];

    switch (myCase) {
        case clearIMGCase:
            // 无图模式
            [self clearAllIMGOfRequest:Mrequest];
            break;
        case cacheCase:
            if(_shouldUseLocalCache){
                //加载本地缓存数据，如果有的话就直接用self.client传回去
                ZTCache *localCache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathForRequest:Mrequest]];
                if (localCache) {
                    NSLog(@"加载本地数据的缓存");
                    [self.client URLProtocol:self didReceiveResponse:localCache.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                    [self.client URLProtocol:self didLoadData:localCache.data];
                    [self.client URLProtocolDidFinishLoading:self];
                }else{
                    NSLog(@"发现本地没有响应的数据缓存");
                    [self.client URLProtocolDidFinishLoading:self];
                }
            }else{
                [self cacheRequest:Mrequest];
            }
            break;
        case redirectCase:
        {
            //自定义请求，请求互联网上的数据
            NSLog(@"%@",self.request.URL.absoluteString);
            NSLog(@"请求被定向到 -- %@",Mrequest.URL.absoluteString);
            NSURLSessionDataTask *task = [self.session dataTaskWithRequest:Mrequest];
            [task resume];
        }
        default:
            break;
    }
}
- (void)stopLoading
{
    NSLog(@"stopLoading NSPROTOCOL");
}
//无图模式（拦截所有图片请求，替换成本地图片）
- (void)clearAllIMGOfRequest:(NSURLRequest *)Mrequest
{
    UIImage *img = [UIImage imageNamed:@"APUS_Logo"];
    NSData *data = UIImageJPEGRepresentation(img, 0.5);
    NSURLResponse *response = [[NSURLResponse alloc]initWithURL:Mrequest.URL MIMEType:@"image/jpeg" expectedContentLength:data.length textEncodingName:nil];
    
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
}
//网页缓存
- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [[aRequest URL] absoluteString];
    return [cachesPath stringByAppendingPathComponent:[self md5:fileName]];
}
- (NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (void)cacheRequest:(NSURLRequest *)request
{
    self.cachePath = [self cachePathForRequest:request];
    NSURLSessionDataTask *cacheTask = [self.cacheSession dataTaskWithRequest:request];
    [cacheTask resume];
}
#pragma mark - NSURLSessionDataDelegate
//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
//{
//    if (session == self.cacheSession) {
//        NSLog(@"缓存时，要求验证证书");
//    }else{
//        NSLog(@"要求验证证书");
//    }
//
//    [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge];
//}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{

    if (session == self.cacheSession) {
        self.cacheResponse = response;
        NSLog(@"缓存response");
    }else{
        NSLog(@"respnse - %@",response);
    }
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
    
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    if(session == self.cacheSession){
        [self.cacheData appendData:data];
        NSLog(@"缓存data");
    }else{
        NSLog(@"NSPROTOCOL 自定义的请求接受到数据 - %ld",data.length);
    }
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        NSLog(@"NSPROTOCOL 自己设的请求出错 - %@",error);
        [self.client URLProtocol:self didFailWithError:error];
    }else{
        ZTCache *cache = [[ZTCache alloc]init];
        cache.data = self.cacheData;
        cache.response = self.cacheResponse;
        cache.request = task.originalRequest;
        [NSKeyedArchiver archiveRootObject:cache toFile:self.cachePath];
        
        [self.client URLProtocolDidFinishLoading:self];
    }
}




@end
