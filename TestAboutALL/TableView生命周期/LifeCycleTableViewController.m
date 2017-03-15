//
//  LifeCycleTableViewController.m
//  TestAboutALL
//
//  Created by 周桐 on 16/11/7.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "LifeCycleTableViewController.h"

@interface LifeCycleTableViewController ()
@property (nonatomic, assign) NSInteger cellHeight;
@end

@implementation LifeCycleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    NSLog(@"%f",self.tableView.contentSize.height);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor blueColor];
    self.cellHeight = 100;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s",__func__);
    NSLog(@"%f",self.tableView.contentSize.height);
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSLog(@"%s",__func__);
    NSLog(@"%f",self.tableView.contentSize.height);
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"%s",__func__);
    NSLog(@"%f",self.tableView.contentSize.height);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%s",__func__);
    NSLog(@"%f",self.tableView.contentSize.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSLog(@"%s",__func__);
    NSLog(@"%f",self.tableView.contentSize.height);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"%s",__func__);
    NSLog(@"%f",self.tableView.contentSize.height);
/*
 *测试发现最多会算13个的cellHeight
 *设置13可以看到控制台输出的结果，tableView的contentSize高度是2600而不是1300
 *说明这个高度还是在给cell赋值之后算的，因为在cell赋值之后我把self.cellHeight从100变成了200
 *但是在模拟每个cell的高度都不同的时候，我采用
 */
    return 13;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s,%ld",__func__,(long)indexPath.row);
    NSLog(@"%f",self.tableView.contentSize.height);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    self.cellHeight = 200;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s",__func__);
    NSLog(@"%f",self.tableView.contentSize.height);
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"%s",__func__);
    NSLog(@"%f",self.tableView.contentSize.height);
    return self.cellHeight;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
