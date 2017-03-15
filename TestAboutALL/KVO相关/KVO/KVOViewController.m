//
//  KVOViewController.m
//  TestAboutALL
//
//  Created by 周桐 on 16/10/25.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "KVOViewController.h"
#import "objClass.h"

@interface KVOViewController ()

@end

@implementation KVOViewController
static NSString *const context = @"observerOfKVOViewController";
static NSString *const keyPath = @"propertyA";
static NSString *const keyPath2 = @"propertyB";
static NSString *const keyPath3 = @"propertyC";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.obj = [[objClass alloc]init];
    [self.obj addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(context)];
    [self.obj addObserver:self forKeyPath:keyPath2 options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(context)];
    [self.obj addObserver:self forKeyPath:keyPath3 options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(context)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(clickBtn2change) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


//KVO默认的回调方法，所有都走这个方法，所以要在里面做一下判断
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context
{
    if (object == self.obj) {
        [self doSomething];
        if ([keyPath isEqualToString:@"propertyA"]) {
            NSLog(@"A发生变化");
            NSLog(@"object is :%@",object);
            NSLog(@"change is :%@",change);
            NSLog(@"new value is :%@",change[NSKeyValueChangeNewKey]);
            NSLog(@"context is :%@",context);
        }
        if ([keyPath isEqualToString:@"propertyB"]) {
            NSLog(@"B发生变化");
            NSLog(@"object is :%@",object);
            NSLog(@"change is :%@",change);
            NSLog(@"new value is :%@",change[NSKeyValueChangeNewKey]);
            NSLog(@"context is :%@",context);
        }
        if ([keyPath isEqualToString:@"propertyC"]) {
            NSLog(@"C发生变化");
            NSLog(@"object is :%@",object);
            NSLog(@"change is :%@",change);
            NSLog(@"new value is :%@",change[NSKeyValueChangeNewKey]);
            NSLog(@"context is :%@",context);
        }
    }else{
        //注意这里，因为所有的KVO都走这里，所以父类甚至super-super的KVO也会跑到这里来，如果不加这个，会导致KVO在这里断链，
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}
//KVO监听到改变
-(void)doSomething
{
    NSLog(@"KVO变化---------");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)clickBtn2change
{
    NSLog(@"clickBtn");
    self.obj.propertyA += 1;
    self.obj.propertyB += 10;
    self.obj.propertyC += 100;
}

-(void)dealloc
{
    //这里就涉及到context的应用了！
    //因为有一种情况是父类对这个obj做了KVO，子类也对这个obj做了KVO，在removeObserver的时候，可能父类remove一次子类也remove一次，会造成crash，所以可以在addObserver时给它指定context
    [self.obj removeObserver:self forKeyPath:@"propertyA" context:(__bridge void * _Nullable)(context)];
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
