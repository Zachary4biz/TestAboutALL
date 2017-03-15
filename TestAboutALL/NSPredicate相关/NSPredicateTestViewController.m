//
//  NSPredicateTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/1/20.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "NSPredicateTestViewController.h"
#import "TestNSPredicate.h"

@interface NSPredicateTestViewController ()
@property (nonatomic, strong) UITextField *aTextField;
@end

@implementation NSPredicateTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.数组过滤例子
    UIButton *arrayFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrayFilterBtn setTitle:@"arrayFilterBtn" forState:UIControlStateNormal];
    [arrayFilterBtn addTarget:self action:@selector(clickArrayFilterBtn) forControlEvents:UIControlEventTouchUpInside];
    [arrayFilterBtn setFrame:CGRectMake(30, 30, 120, 30)];
    [self.view addSubview:arrayFilterBtn];
    
    //2.数字过滤例子（偏向于判断）
    UIButton *numFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [numFilterBtn setTitle:@"numFilterBtn" forState:UIControlStateNormal];
    [numFilterBtn addTarget:self action:@selector(clickNSNumberFilterBtn) forControlEvents:UIControlEventTouchUpInside];
    [numFilterBtn setFrame:CGRectMake(30, 80, 120, 30)];
    [self.view addSubview:numFilterBtn];
    
    //3.字符串
    UIButton *stringFilterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [stringFilterBtn setTitle:@"stringFilterBtn" forState:UIControlStateNormal];
    [stringFilterBtn addTarget:self action:@selector(clickStringFilterBtn) forControlEvents:UIControlEventTouchUpInside];
    [stringFilterBtn setFrame:CGRectMake(30, 130, 120, 30)];
    [self.view addSubview:stringFilterBtn];
    
    //4.检查某个类
    UIButton *selfMadeClassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selfMadeClassBtn setTitle:@"selfMadeClassBtn" forState:UIControlStateNormal];
    [selfMadeClassBtn addTarget:self action:@selector(clickSelfMadeClassBtn) forControlEvents:UIControlEventTouchUpInside];
    [selfMadeClassBtn setFrame:CGRectMake(30, 180, 120, 30)];
    [self.view addSubview:selfMadeClassBtn];

    _aTextField = [[UITextField alloc]initWithFrame:CGRectMake(160, 130, 180, 30)];
    [_aTextField setBackgroundColor:[UIColor whiteColor]];
    [_aTextField setTextColor:[UIColor blackColor]];
    [self.view addSubview:_aTextField];
    
}


#pragma mark - Array相关的规则
/*
 *ANY、SOME：集合中任意一个元素满足条件，就返回YES。
 *ALL：集合中所有元素都满足条件，才返回YES。
 *NONE：集合中没有任何元素满足条件就返回YES。如:NONE person.age < 18，表示person集合中所有元素的age>=18时，才返回YES。
 *IN：等价于SQL语句中的IN运算符，只有当左边表达式或值出现在右边的集合中才会返回YES。我们通过一个例子来看一下
 */
- (void)clickArrayFilterBtn
{
    //目标数组
    NSArray *targetArr = @[@"a",@"b",@"c",@"d",@"e",@"f"];
    //数组过滤器
    NSArray *filterArr = @[@"a",@"b",@"c"];

    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",filterArr];
    //对于数组来说，基本就是遍历元素，如果当前元素满足aPredicate就保留，不满足就剔除
    NSArray *resultArr = [targetArr filteredArrayUsingPredicate:aPredicate];
    NSLog(@"目标源数组是%@",targetArr);
    NSLog(@"数组过滤器是%@",filterArr);
    NSLog(@"经过过滤的数组是%@",resultArr);
}
#pragma mark - NSNumber相关的规则
/*
 *=、==：判断两个表达式是否相等，在谓词中=和==是相同的意思都是判断，而没有赋值这一说
 *>=，=>：判断左边表达式的值是否大于或等于右边表达式的值
 *<=，=<：判断右边表达式的值是否小于或等于右边表达式的值
 *>：判断左边表达式的值是否大于右边表达式的值
 *<：判断左边表达式的值是否小于右边表达式的值
 *!=、<>：判断两个表达式是否不相等
 *BETWEEN：BETWEEN表达式必须满足表达式 BETWEEN {下限，上限}的格式，要求该表达式必须大于或等于下限，并小于或等于上限
 */
- (void)clickNSNumberFilterBtn
{
    NSNumber *targetNum1 = @123;
    NSNumber *filterNum = @123;
    //谓词预测中=和==都是表示判断
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF = %@",filterNum];
    if ([predicate1 evaluateWithObject:targetNum1]) {
        NSLog(@"targetNum1 is eqaul to filterNum:%@",filterNum);
    }
    
    NSNumber *targetNum2 = @123;
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF BETWEEN {100, 200}"];
    if ([predicate2 evaluateWithObject:targetNum2]) {
        NSLog(@"targetNum2:%@ 在{100,200}之间", targetNum2);
    } else {
        NSLog(@"targetNum2:%@ 不在{100,200}之间", targetNum2);
    }
    
    
    
}
#pragma mark - 自定的某个类也可以查某个属性
- (void)clickSelfMadeClassBtn
{
    //TestNSPredicate这个类有两个属性 str1 和 str2
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:[[TestNSPredicate alloc] initWithStr1:@"123" Str2:@"234"],
                                                           [[TestNSPredicate alloc] initWithStr1:@"abc" Str2:@"bcd"],
                                                           [[TestNSPredicate alloc] initWithStr1:@"abc" Str2:@"anotherBCD"],nil];
    
    //这个predicate1就是在arr中遍历，找到str1的值是123的，predicate2同理
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"str1=%@",@"123"];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"str1=%@",@"abc"];
    
    //str1是123的我就设置了一个
    TestNSPredicate *theSelfMadeClass1 = [[arr filteredArrayUsingPredicate:predicate1] firstObject];
    NSLog(@"theSelfMadeClass1 - str1=123 >>");
    NSLog(@"%@",theSelfMadeClass1);
    NSLog(@"");
    //str1是abc的我设置了两个
    NSArray *resultArr2 = [arr filteredArrayUsingPredicate:predicate2];
    NSLog(@"resultArr2 - str1=abc >>");
    NSLog(@"%@",resultArr2);
    
}

#pragma mark - NSString相关的规则
/*
 *BEGINSWITH：检查某个字符串是否以指定的字符串开头（如判断字符串是否以a开头：BEGINSWITH 'a'）
 *ENDSWITH：检查某个字符串是否以指定的字符串结尾
 *CONTAINS：检查某个字符串是否包含指定的字符串
 *LIKE：检查某个字符串是否匹配指定的字符串模板。其之后可以跟?代表一个字符和*代表任意多个字符两个通配符。比如"name LIKE '*ac*'"，这表示name的值中包含ac则返回YES；"name LIKE '?ac*'"，表示name的第2、3个字符为ac时返回YES。
 *MATCHES：检查某个字符串是否匹配指定的正则表达式。虽然正则表达式的执行效率是最低的，但其功能是最强大的，也是我们最常用的。
 *  ----------------------------
 *另外：
 *字符串比较都是区分大小写和重音符号的。如：café和cafe是不一样的，Cafe和cafe也是不一样的。如果希望字符串比较运算不区分大小写和重音符号，请在这些运算符后使用[c]，[d]选项。其中[c]是不区分大小写，[d]是不区分重音符号，其写在字符串比较运算符之后，比如：name LIKE[cd] 'cafe'，那么不论name是cafe、Cafe还是café上面的表达式都会返回YES
 */
- (void)clickStringFilterBtn
{
    NSString *str = _aTextField.text;
    //是否以s开头
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"name LIKE 's*'"];
#warning 跑到这里会闪退崩掉，没有错误提示
    if ([pred1 evaluateWithObject:str]) {
        NSLog(@"是以s开头的字符串");
    }else{
        NSLog(@"不是以s开头");
    }
    
}

@end
