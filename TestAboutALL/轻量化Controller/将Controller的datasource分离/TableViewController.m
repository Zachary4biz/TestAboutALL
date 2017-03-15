//
//  TableViewController.m
//  TestAboutALL
//
//  Created by 周桐 on 16/10/25.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "TableViewController.h"
#import "ArrayDataSource.h"
#import "Model.h"
@interface TableViewController ()

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) ArrayDataSource *dataSource;

@end

@implementation TableViewController

- (NSArray *)arr
{
    if (!_arr) {
        NSMutableArray *tempArr = [NSMutableArray array];
        int i = 0;
        while (i<20) {
            Model *mod = [[Model alloc]init];
            mod.temp = [NSString stringWithFormat:@"临时模型数据%d",i];
            [tempArr addObject:mod];
            i++;
        }
        _arr = [NSArray arrayWithArray:tempArr];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    [self.view addSubview:self.tableView];
    
    TableViewCellContfigureBlock configureCellBlock = ^(UITableViewCell *cell, Model *model){
        cell.textLabel.text = model.temp;
        cell.backgroundColor = [UIColor redColor];
    };
    self.dataSource = [[ArrayDataSource alloc]initWithItems:self.arr cellIdentifier:@"cell" configureCellBlock:configureCellBlock];
    //居然可以直接把代理交给另一个对象！
    self.tableView.dataSource = self.dataSource;
}

@end
