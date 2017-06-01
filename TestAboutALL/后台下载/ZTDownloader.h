//
//  ZTDownloader.h
//  TestAboutALL
//
//  Created by Zac on 2017/4/17.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTDownloader : NSObject
- (NSURLSessionDownloadTask *_Nonnull)createBGDowloadWithURL:(NSURL *_Nonnull)url delegateOf:(nullable id <NSURLSessionDelegate>)delegateTarget resumeData:(NSData * _Nullable)resumeData;
- (void)stopDownloadTask:(NSURLSessionDownloadTask *_Nonnull)task;
- (NSData *_Nullable)getResumeDataOfURL:(NSURL *_Nonnull)url;
- (NSURL *_Nonnull)save2DocumentsAsFileURLWithName:(NSString *_Nonnull)name;
- (NSString *_Nonnull)save2DocumentsWithName:(NSString *_Nonnull)name;
@end
