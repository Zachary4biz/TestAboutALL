//
//  SSTableViewDataSource.m
//  TestAboutALL
//
//  Created by 周桐 on 16/11/1.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "SSTableViewDataSource.h"
@interface SSTableViewDataSource()
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) NSArray *modArr;
@property (nonatomic, strong) ConfigureCellBlock configureCellBlock;

@end

@implementation SSTableViewDataSource
- (instancetype)initWithModArr:(NSArray *)modArr cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(ConfigureCellBlock)configureCellBlock
{
    self = [super init];
    if (self) {
        self.modArr = modArr;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modArr.count;
}



@end
