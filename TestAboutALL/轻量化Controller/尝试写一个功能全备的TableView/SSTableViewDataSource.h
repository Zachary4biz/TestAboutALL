//
//  SSTableViewDataSource.h
//  TestAboutALL
//
//  Created by 周桐 on 16/11/1.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ConfigureCellBlock)(id cell, id mod, id index);

@interface SSTableViewDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithModArr:(NSArray *)modArr
                cellIdentifier:(NSString *)cellIdentifier
            configureCellBlock:(ConfigureCellBlock)configureCellBlock;

@end
