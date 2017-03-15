//
//  TestRunLoopAndWhileViewController.m
//  TestAboutALL
//
//  Created by 周桐 on 16/12/30.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "TestRunLoopAndWhileViewController.h"

@interface TestRunLoopAndWhileViewController ()

@end

@implementation TestRunLoopAndWhileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *buttonNoramlThread = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonNoramlThread setFrame:CGRectMake(100, 30, 100, 30)];
    [buttonNoramlThread setTitle:@"测试普通的线程" forState:UIControlStateNormal];
    [buttonNoramlThread addTarget:self action:@selector(buttonNormalThreadTestPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonNoramlThread];
    
    UIButton *buttonRunLoop = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRunLoop setFrame:CGRectMake(100, 80, 100, 30)];
    [buttonRunLoop setTitle:@"测试RunLoop" forState:UIControlStateNormal];
    [buttonRunLoop addTarget:self action:@selector(buttonRunloopPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonRunLoop];
    
    UIButton *buttonTestUI = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTestUI setFrame:CGRectMake(100, 130, 100, 30)];
    [buttonTestUI setTitle:@"测试UI能否响应" forState:UIControlStateNormal];
    [buttonTestUI addTarget:self action:@selector(buttonTestPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonTestUI];
    
    NSRunLoop *aRunLoop = [NSRunLoop currentRunLoop];
    NSLog(@"viewDidLoad-- runloop的地址：%x", aRunLoop);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


BOOL threadProcess1Finished =NO;
-(void)threadProce1{
    NSLog(@"进入线程1.");
    
    for (int i=0; i<10;i++) {
        NSLog(@"线程1计数 count = %d.", i);
        sleep(1);
    }
    threadProcess1Finished =YES;
    NSLog(@"退出线程1.");
}

BOOL threadProcess2Finished =NO;
-(void)threadProce2{
    NSLog(@"进入线程2.");
    NSRunLoop *aRunLoop = [NSRunLoop currentRunLoop];
    NSLog(@"当前runloop的地址：%x", aRunLoop);
    for (int i=0; i<10;i++) {
        NSLog(@"线程2计数 count = %d.", i);
        sleep(1);
    }
    
    threadProcess2Finished =YES;
    NSLog(@"退出线程2.");
}

- (IBAction)buttonNormalThreadTestPressed:(UIButton *)sender {
    NSLog(@"点击了线程测试按钮");
    
    threadProcess1Finished =NO;
    NSLog(@"开启新线程-线程测试.");
    [NSThread detachNewThreadSelector: @selector(threadProce1)
                            toTarget: self
                          withObject: nil];
    
    // 通常等待线程处理完后再继续操作的代码如下面的形式。
    // 在等待线程threadProce1结束之前，调用buttonTestPressed，界面没有响应，直到threadProce1运行完，才打印buttonTestPressed里面的日志。
    while (!threadProcess1Finished) {
        [NSThread sleepForTimeInterval: 0.5];
    }
    
    NSLog(@"退出线程");
}

- (IBAction)buttonRunloopPressed:(id)sender {
    NSLog(@"点击了runloop按钮");
    threadProcess2Finished =NO;
    NSLog(@"开始了新线程-runloop测试.");
    [NSThread detachNewThreadSelector: @selector(threadProce2)
                            toTarget: self
                          withObject: nil];
    // 使用runloop，情况就不一样了。
    // 在等待线程threadProce2结束之前，调用buttonTestPressed，界面立马响应，并打印buttonTestPressed里面的日志。
    // 这就是runloop的神奇所在
    while (!threadProcess2Finished) {
        NSLog(@"Begin runloop");
        NSRunLoop *aRunLoop = [NSRunLoop currentRunLoop];
        NSLog(@"当前runloop的地址：%x", aRunLoop);
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                beforeDate: [NSDate distantFuture]];
        NSLog(@"End runloop.");
    }
    NSLog(@"结束runlo按钮");
}

- (IBAction)buttonTestPressed:(id)sender{
    NSLog(@"UI可以响应");
}

@end
