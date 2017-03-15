//
//  TestNSOperation.h
//  TestAboutALL
//
//  Created by 周桐 on 16/12/30.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestNSOperation : NSOperation
/*
 *这里是定制一个操作（NSOperation），比如现在是专门输出i从1到1000的开方
 */
@property (nonatomic, strong, readonly)NSString *mark;
- (instancetype)initWithMark:(NSString *)mark;
@end
