//
//  UIKitTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/3/2.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "UIKitTestViewController.h"
#import "ZTRuntimeUtil.h"
@interface UIKitTestViewController ()
- (IBAction)getUITextField:(id)sender;
- (IBAction)getTEST:(id)sender;

- (IBAction)getUIView:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation UIKitTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}



- (void)fetchAllFromClass:(Class)aClass
{
    NSDictionary *viewDic = [ZTRuntimeUtil fetchALLFrom:aClass];
    NSLog(@"%@",viewDic);
}

- (IBAction)getUIView:(id)sender {
    [self fetchAllFromClass:[UIView class]];
}
- (IBAction)getUITextField:(id)sender {
    [self fetchAllFromClass:[UITextField class]];
}

- (IBAction)getTEST:(id)sender {
    [self fetchAllFromClass:NSClassFromString(self.textField.text)];
}
@end
