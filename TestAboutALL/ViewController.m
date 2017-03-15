//
//  ViewController.m
//  TestAboutALL
//
//  Created by 周桐 on 16/10/25.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) BOOL tapShouldBegin;
//@property (nonatomic, assign) BOOL long
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _textField = [[UITextField alloc]init];
    _textField.frame = CGRectMake(20, 80, 200, 33);
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.delegate = self;
    [self.view addSubview:_textField];
    
//    _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
////    _tapGes.delegate = self;
//    [_textField addGestureRecognizer:_tapGes];
//    
//    _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
////    _longPress.delegate = self;
//    [_textField addGestureRecognizer:_longPress];
    
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    NSURL *url = [NSURL URLWithString:@"zkbrowser://"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"success");
        }else{
            NSLog(@"fail");
        }
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textfiled should begin");
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textfield did begin");
    
}
/*
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _tapGes ) {
        NSLog(@"tapShouldBegin");
        _textField.text = @"tap!!";
        
    }else if (gestureRecognizer == _longPress){
        NSLog(@"longPressShouldBegin");
        _textField.text = @"longPress!!";
    }
    return YES;
}
 */

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    NSLog(@"longpress");
    _textField.text = @"longPress!!";
    [_textField becomeFirstResponder];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    NSLog(@"tap");
    _textField.text = @"tap!!";
    [_textField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
