//
//  CategoryTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/21.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "CategoryTestViewController.h"
#import "NSObject+Category4NSObjectTestRuntime.h"
#import "NSObject+MiddleVar.h"
@interface CategoryTestViewController ()
@property (nonatomic, strong)NSString *str1;
@property (nonatomic, strong)NSString *str2;
@end

@implementation CategoryTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.str1 = @"test1";
    self.str2 = @"test2";
//middleVar
    self.str1.object = @"middleVar1";
    self.str2.object = @"middleVar2";
    
    //runtime
    self.str1.ZTObject = @"runtimeVar1";
    self.str2.ZTObject = @"runtimeVar2";
    //添加integer
    self.str1.anInteger = @1;
    self.str2.anInteger = @2;
    //添加BOOL
    self.str1.aBOOL = @YES;
    self.str2.aBOOL = @NO;
    
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"str1地址%p",self.str1);
    NSLog(@"str2地址%p",self.str2);
    NSLog(@"  ");
    NSLog(@"str1 - objectFrom MiddleVar方式 - %@",self.str1.object);
    NSLog(@"str2 - objectFrom MiddleVar方式 - %@",self.str2.object);
    NSLog(@"  ");
    NSLog(@"str1 - ZTObjectFrom Runtime方式 - %@",self.str1.ZTObject);
    NSLog(@"str2 - ZTObjectFrom Runtime方式 - %@",self.str2.ZTObject);
    NSLog(@"说明用Runtime才行，用中间变量，会因为中间变量的地址是不变的导致两个object相同互相覆盖");
    
    //integer，注意 使用（增减、计数等） 的时候要用integerValue取出来操作
    NSLog(@"str1 - integer - %@",self.str1.anInteger);
    NSLog(@"str2 - integer - %@",self.str2.anInteger);
    self.str1.anInteger = @([self.str1.anInteger integerValue] +1);
    NSLog(@"str1 - integer加一后 - %@",self.str1.anInteger);
    
    //bool,要注意 操作或者判断 的时候用boolValue把他取出来
    NSLog(@"str1 - aBOOL - %ld",(long)[self.str1.aBOOL integerValue]);
    NSLog(@"str2 - aBOOL - %@",self.str2.aBOOL);
    if ([self.str1.aBOOL boolValue]) {
        self.str1.aBOOL = @NO;
    }else{
        self.str1.aBOOL = @YES;
    }
    NSLog(@"str1 - aBOOL取反后 - %@",self.str1.aBOOL);
}
@end
