//
//  AppiumViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/8.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "AppiumViewController.h"

@interface AppiumViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textF;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
- (IBAction)firstBtn:(id)sender;
- (IBAction)secondBtn:(id)sender;

@end

@implementation AppiumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textF.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"begin");
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"should?");
    NSLog(@"%@",string);
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)firstBtn:(id)sender {
    NSLog(@"firstBtn");
    self.secondBtn.enabled = NO;
}

- (IBAction)secondBtn:(id)sender {
    NSLog(@"secondBtn");
}
@end
