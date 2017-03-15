//
//  CopyAndMuttableCopyViewController.m
//  TestAboutALL
//
//  Created by 周桐 on 17/1/17.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "CopyAndMuttableCopyViewController.h"

@interface CopyAndMuttableCopyViewController ()
//测试数组里面是NSNumber
@property (nonatomic, strong) NSArray *arr1;
@property (nonatomic, strong) NSMutableArray *arrCopy1;
@property (nonatomic, strong) NSMutableArray *arrMutableCopy1;
//测试数组里是View这种不支持copy协议的
@property (nonatomic, strong) NSMutableArray *arr2;
@property (nonatomic, copy) NSMutableArray *arrCopy2;
@property (nonatomic, copy) NSMutableArray *arrMutableCopy2;
@end

@implementation CopyAndMuttableCopyViewController
/*
 *结论：
 *如果初始数组是 NSMutableArray 类型 (NSArray也是这样，mutablecopy获得的都可以修改）
 * 那么使用copy得到的数组其实是NSArray类型，不能删减东西
 * 使用mutablecopy得到的是NSMutableArray类型，可以删减
 * 三个数组的地址肯定都是不同的
 * ---- ----- ---- ----- ------ ------ ------ ------ ------ ----- -----
 *特殊情况：如果数组内的东西是不遵守NSCopy协议的话
 *  那内部比如UIView，它们的地址实际上还是相同的
 *  比如：
 *   原始数组 -- ("<UIView: 0x7ffd8ae08e70; frame = (0 0; 30 80); layer = <CALayer: 0x60800022aaa0>>",
                "<UIView: 0x7ffd8ae09010; frame = (0 0; 0 0); layer = <CALayer: 0x60800022aac0>>",
                "<UIView: 0x7ffd8ae091b0; frame = (0 0; 0 0); layer = <CALayer: 0x60800022aae0>>")
 *   copy数组 -- ("<UIView: 0x7ffd8ae08e70; frame = (0 0; 30 80); layer = <CALayer: 0x60800022aaa0>>",
                "<UIView: 0x7ffd8ae09010; frame = (0 0; 0 0); layer = <CALayer: 0x60800022aac0>>",
                "<UIView: 0x7ffd8ae091b0; frame = (0 0; 0 0); layer = <CALayer: 0x60800022aae0>>")
 *   mutableCopy数组 -- ("<UIView: 0x7ffd8ae08e70; frame = (0 0; 30 80); layer = <CALayer: 0x60800022aaa0>>",
                        "<UIView: 0x7ffd8ae09010; frame = (0 0; 0 0); layer = <CALayer: 0x60800022aac0>>",
                        "<UIView: 0x7ffd8ae091b0; frame = (0 0; 0 0); layer = <CALayer: 0x60800022aae0>>")
 */
- (void)viewDidLoad {
    [super viewDidLoad];
//测试数组里面是NSNumber
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"测试数组里面是NSNumber" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 30, 180, 30);
    [btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
     _arr1= [NSArray arrayWithObjects:@1,@2,@3,@4, nil];
    _arrCopy1 = [_arr1 copy];
    _arrMutableCopy1 = [_arr1 mutableCopy];
    
//测试数组里是View这种不支持copy协议的
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"测试数组里面是View" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(0, 70, 180, 30);
    [btn2 addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIView *view1 = [[UIView alloc]init];
    UIView *view2 = [[UIView alloc]init];
    UIView *view3 = [[UIView alloc]init];
    UIView *view4 = [[UIView alloc]init];
    _arr2 = [NSMutableArray arrayWithObjects:view1,view2,view3,view4, nil];
    _arrCopy2 = [_arr2 copy];
    _arrMutableCopy2 = [_arr2 mutableCopy];
}

- (void)clickBtn1
{
//    [_arr1 removeObjectAtIndex:0];
    NSNumber *num1 = _arr1[0];
    num1 = @([num1 intValue]+1);
    NSLog(@"原始数组--%@, \n地址是 -- %p, \n原数组类型是 -- %@",_arr1,_arr1,[_arr1 class]);
    NSLog(@"copy数组--%@, \n地址是 -- %p, \ncopy的数组类型是 -- %@",_arrCopy1,_arrCopy1,[_arrCopy1 class]);
    NSLog(@"MutableCopy数组--%@, \n地址是 -- %p, \n MutableCopy数组类型是 -- %@",_arrMutableCopy1,_arrMutableCopy1,[_arrMutableCopy1 class]);
    NSLog(@"开始移除 copy数组移除index为1的,mutableCopy移除index为2的");
//    [_arrCopy1 removeObjectAtIndex:1];
    [_arrMutableCopy1 removeObjectAtIndex:2];
    NSLog(@"原始数组--%@",_arr1);
    NSLog(@"copy数组--%@",_arrCopy1);
    NSLog(@"MutableCopy数组--%@",_arrMutableCopy1);
}

- (void)clickBtn2
{
//    [_arr2 removeObjectAtIndex:0];
    UIView *view = _arr2[0];
    view.frame = CGRectMake(0, 0, 30, 80);
    NSLog(@"原始数组--%@, 原数组类型是 -- %@",_arr2,[_arr2 class]);
    NSLog(@"copy数组--%@, copy的数组类型是 -- %@",_arrCopy2,[_arrCopy2 class]);
    NSLog(@"MutableCopy数组--%@, MutableCopy数组类型是 -- %@",_arrMutableCopy2,[_arrMutableCopy2 class]);
 
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
