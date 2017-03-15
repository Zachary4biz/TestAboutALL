//
//  CancellerGCD.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/21.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "CancellerGCD.h"

@interface CancellerGCD()
@property (nonatomic, assign) BOOL shouldCancel;
@end
@implementation CancellerGCD
@synthesize shouldCancel = _shouldCancel;
- (void)setShouldCancel:(BOOL)shouldCancel
{
    _shouldCancel = shouldCancel;
}

- (BOOL)shouldCancel
{
    return _shouldCancel;
}

static void test(int a){
    static CancellerGCD *canceller = nil;
    dispatch_queue_t q;
    canceller = [[CancellerGCD alloc]init];
    q = dispatch_get_global_queue(0, 0);
    dispatch_async(q, ^{
        while (![canceller shouldCancel]) {
            NSLog(@"query %d",a);
            sleep(2);
        }
    });
    
    if(q){
        [canceller setShouldCancel:YES];
        dispatch_suspend(q);
        q=nil;
    }

}
@end
