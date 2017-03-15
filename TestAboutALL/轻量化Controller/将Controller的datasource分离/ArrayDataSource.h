//
//  ArrayDataSource.h
//  TestAboutALL
//
//  Created by 周桐 on 16/10/25.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^TableViewCellContfigureBlock)(id cell,id items);


@interface ArrayDataSource : NSObject<UITableViewDataSource>

- (id)initWithItems:(NSArray *)anItems
    cellIdentifier:(NSString *)aCellIdentifier
configureCellBlock:(TableViewCellContfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
