//
//  ShouldDeallocViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/12.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "ShouldDeallocViewController.h"

@interface ShouldDeallocViewController ()
@property (nonatomic, copy) void (^tempBlock)();
@property (nonatomic, strong) NSString *str;
@end

@implementation ShouldDeallocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.str = @"abcd";
    __weak typeof(self) Wself = self;
    self.tempBlock = ^(){
        [Wself dis];
        [Wself stillAlive];
    };
}
- (IBAction)btn:(id)sender {
    self.tempBlock();
}
- (void)stillAlive
{

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(0,0), ^{
            NSLog(@"Still alive");
            NSLog(@"%@",self.str);
        });
    
    
}
- (void)dis
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc
{
    NSLog(@"dealloc shouldDeallocVC");
}

@end
