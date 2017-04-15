//
//  BlockTestViewController.h
//  TestAboutALL
//
//  Created by Zac on 2017/4/12.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShouldDeallocViewController.h"
@interface BlockTestViewController : UIViewController
/*
 * 暂时没有复现问题
 * 问题是这样的，
 * 在一个block中：
 * self.block = ^(){
 *    [Wself doA];
 *    [Wself doB];
 * };
 * 存在一种可能是，doA之后，self被销毁了，这时候doB就不生效了
 * 总之如果以后碰到block里面Wself有问题，可以试试在Block中写
 * self.block = ^(){
 *    __strong typeof(self) Ssefl = Wself;
 *    [Sself doA];
 *    [Sself doB];
 * };
 */
@end
