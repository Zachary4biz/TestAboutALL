//
//  BlockTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/12.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "BlockTestViewController.h"
#import "ShouldDeallocViewController.h"
@interface BlockTestViewController ()

@end

@implementation BlockTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)btn:(id)sender {
    ShouldDeallocViewController *vc = [[ShouldDeallocViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
