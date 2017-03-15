//
//  MultiThreadDownloader.h
//  TestAboutALL
//
//  Created by Zac on 2017/2/23.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct ZTRange {
    NSUInteger begin;
    NSUInteger end;
} ZTRange;



@interface MultiThreadDownloader : NSObject
@property (nonatomic, readonly, copy) NSString *ID;
@property (nonatomic, copy) void (^progressBlock)(float progress, float speed);
- (void)downloadAssignmentWithID:(NSString *)ID
                          andURL:(NSURL *)URL
                      toFilePath:(NSString *)filePath
        andExpectedContentLength:(NSUInteger)expectedContentLength;

- (void)suspendAssignment;

- (void)resumeAssignment;
//
//- (void)resumeAssignmentWithID:(NSString *)ID;
//
//- (void)cancelAssignmentWithID:(NSString *)ID;
//
//- (void)removeAssignmentWithID:(NSString *)ID;
//
//- (void)saveAssignmentWithID:(NSString *)ID;
@end
