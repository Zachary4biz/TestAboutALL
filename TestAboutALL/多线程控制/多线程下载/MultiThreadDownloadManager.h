//
//  MultiThreadDownloadManager.h
//  TestAboutALL
//
//  Created by Zac on 2017/2/23.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiThreadDownloadManager : NSObject
+ (MultiThreadDownloadManager *)sharedInstance;

- (void)dowloadAssignmentWithURL:(NSURL *)url
                           andID:(NSString *)ID
                        FilePath:(NSString *)filePath
               withProgressBlock:(void(^)(float progress,float speed))progressBlock;

- (void)suspendAssignmentWithID:(NSString *)ID;

- (void)resumeAssignmentWithID:(NSString *)ID;
@end
