//
//  ArrayDataSource.m
//  TestAboutALL
//
//  Created by 周桐 on 16/10/25.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "ArrayDataSource.h"

@interface ArrayDataSource()

@property(nonatomic, strong) NSArray* items;
@property(nonatomic, copy) NSString* cellIdentifier;
@property(nonatomic, copy) TableViewCellContfigureBlock configureCellBlock;

@end

@implementation ArrayDataSource

- (instancetype)init
{
    return nil;
}

- (id)initWithItems:(NSArray *)anItems cellIdentifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewCellContfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self)
    {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = aConfigureCellBlock;
    }
    return  self;
}

//根据indexPath.row决定应该去模型数组的第几个数据item（第几个Model）
- (id)itemAtIndexPath:(NSIndexPath *)indexPath{
    return self.items[ indexPath.row];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    id item = [self itemAtIndexPath:indexPath];
    //传出block
    self.configureCellBlock(cell,item);
    return cell;
}

@end
