//
//  TestDictionaryViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/21.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TestDictionaryViewController.h"

@interface TestDictionaryViewController ()
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation TestDictionaryViewController
/*
 *1.说明即使sourceDict是nil，使用dictionaryWithDictionary:sourceDict这种方法创建得到的self.dict也是有的
 *并且可以进行操作（添加修改）
 *
 *2.使用setObject:forKey:这个方法，是有就替换，无就创造‘
 *
 *3.dictionaryWithCapacity:3使用这个是创建长度3的字典，超过三个也没事
 *
 *4.dictionaryWithObjectsAndKeys:是这样的，第一个参数是键第二个参数是值，第三个参数又是键第四个参数是值。以此类推
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *dict1 = @{@"key1":@"value1",@"key2":@"value2"};
    NSDictionary *dict2 = nil;
    self.dict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    NSLog(@"%@",self.dict);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.dict setObject:@"object1" forKey:@"key1"];
    NSLog(@"%@",self.dict);
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
