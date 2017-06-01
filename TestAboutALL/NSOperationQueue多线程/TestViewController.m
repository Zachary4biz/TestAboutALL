//
//  TestViewController.m
//  TestAboutALL
//
//  Created by 周桐 on 16/12/30.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "TestViewController.h"
#import "TestNSOperation.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.frame = CGRectMake(100, 80, 100, 30);
    [testButton setTitle:@"开始测试" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(clickTestBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    UIButton *bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton.frame = CGRectMake(100, 130, 100, 30);
    [bButton setTitle:@"简单block形式任务" forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(clickBBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bButton];
}

#pragma mark - 全面形式
- (void)clickTestBtn
{
    //初始化任务
    TestNSOperation *operation_1 = [[TestNSOperation alloc]initWithMark:@"operation_1"];
    TestNSOperation *operation_2 = [[TestNSOperation alloc]initWithMark:@"operation_2"];
    //设置任务的优先级
    [operation_1 setQueuePriority:NSOperationQueuePriorityVeryLow];
    [operation_2 setQueuePriority:NSOperationQueuePriorityVeryHigh];
    //设置任务完成的回调
    [operation_1 setCompletionBlock:^{
        NSLog(@"-----------------------------------operation_1完成");
    }];
    [operation_2 setCompletionBlock:^{
        NSLog(@"-----------------------------------operation_2完成");
    }];
    //设置任务2必须要在任务1完成后才能完成
    [operation_2 addDependency:operation_1];
    
    //初始化任务队列
    NSOperationQueue *myQueue = [[NSOperationQueue alloc]init];
    myQueue.name = @"下载队列";
    //设置队列的最大并发数（最大为4）
    myQueue.maxConcurrentOperationCount = 4;
    //添加进队列中执行
    [myQueue addOperation:operation_1];
    [myQueue addOperation:operation_2];
    
    //1s后取消掉任务operation_1
    [self execute:^{
        [operation_1 cancel];
        NSLog(@"-----------------------------------取消了operation_1");
    } afterDelay:1];
    
    //查看当前队列中的所有操作
    NSArray *operations = [myQueue operations];
    NSLog(@"-----------------------------------所有操作%@",operations);
    
    /*
     *注意：
     *挂起这个动作，只会挂起所有未开始的任务，对于已经开始运行的operation是不生效的
     */
    //0.2s后挂起所有未开始的任务 （由于operation_2设置了对operation_1的依赖，所以会挂起operation_2)
    [self execute:^{
        [myQueue setSuspended:YES];
        NSLog(@"-----------------------------------挂起所有任务");
    } afterDelay:0.2];
    //3s后恢复所有挂起的任务 （即开启operation_2)
    [self execute:^{
        [myQueue setSuspended:NO];
        NSLog(@"-----------------------------------恢复所有任务");
    } afterDelay:3];
    
    
}

#pragma mark - 简单形式（block）的队列
- (void)clickBBtn
{

    //初始化队列
    NSOperationQueue *aQueue = [[NSOperationQueue alloc]init];
    aQueue.name = @"简单的任务队列";
    
    //将一个简单的任务添加进队列中
    [aQueue addOperationWithBlock:^{
        //子线程获取data
        NSURL *aURL = [NSURL URLWithString:@"https://www.baidu.com"];
        NSData *aData = [NSData dataWithContentsOfURL:aURL];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //回到主线程
            self.title = [[NSString alloc]initWithData:aData encoding:NSUTF8StringEncoding];
        }];
    }];
    
}
- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delta * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   block);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
