//
//  ParAndSubClassViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/19.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "ParAndSubClassViewController.h"
#import "ParentClass.h"
#import "SubClass.h"
@interface ParAndSubClassViewController ()

@property (nonatomic, strong) ParentClass *pClass;
@property (nonatomic, strong) SubClass *sClass;

@end

@implementation ParAndSubClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pClass = [[ParentClass alloc]init];
    self.sClass = [[SubClass alloc]init];
}
- (IBAction)firstBtn:(id)sender {
    NSLog(@"parent 的 nameH 是 %@",self.pClass.nameHParent);
    NSLog(@"parent 的 nameExtension %@",[self.pClass valueForKey:@"nameExtensionParent"]);
}
- (IBAction)secBtn:(id)sender {
    NSLog(@"sub 的 nameHSub 是 %@",self.sClass.nameHSub);
    NSLog(@"sub 的 nameExtensionSub %@",[self.sClass valueForKey:@"nameExtensionSub"]);
    NSLog(@"sub 的 nameHParent %@",[self.sClass valueForKey:@"nameHParent"]);
    NSLog(@"sub 的 nameExtensionParent %@",[self.sClass valueForKey:@"nameExtensionParent"]);
}
- (IBAction)thirdBtn:(id)sender {
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
