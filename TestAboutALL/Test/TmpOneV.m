//
//  TmpOneV.m
//  TestAboutALL
//
//  Created by Zac on 2017/4/17.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TmpOneV.h"

@implementation TmpOneV
{
    NSString * _str;
    NSString *str;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    _str = @"00000__";
    str = @"00000";
}
- (void)showStr
{
    NSLog(@"_str is %@",_str);
    NSLog(@"str is %@",str);
}

@end
