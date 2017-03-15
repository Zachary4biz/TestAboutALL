//
//  TimersTestViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/24.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "TimersTestViewController.h"

@interface TimersTestViewController ()
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, strong) NSTimer *timer2;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation TimersTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setUpWithTimer];
//    [self setUpCADisplayLink];
    [self setUpGCDRepeat];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self stopTimer];
    [self stopDisplayLink];
}

#pragma mark - GCD方式
- (void)setUpGCDDelay
{
    double delayInSecs = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSecs * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        NSLog(@"GCD after 2.0 secs");
    });
}
- (void)setUpGCDRepeat
{
    NSTimeInterval period = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, period * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCD Repeat at 1.0 secs period");
    });
    dispatch_resume(timer);
}
#pragma mark - CADisplayLink
/*
 * 这个和NSTimer不一样的在于，这个方法是让我们以 和屏幕刷新频率同步的频率 将特定的内容画到屏幕上的定时器类。
 * 通常情况下，屏幕刷新一次就会调用一次selector （一般是60/秒）
 * 但如果CPU过于繁忙，就无法保证60的频率，会跳过若干次回调。
 * 适用于做界面的不停重绘，比如视频播放时，需要不停地获取下一帧用于界面渲染。
 */
- (void)setUpCADisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkHandler)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)displayLinkHandler
{
    NSLog(@"displayLink");
}

- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}



#pragma mark - NSTimer形式
- (void)setUpWithTimer
{
    //这种timer会自动加入MainRunloop的NSDefaultRunLoopMode中。
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(firstTimerHandler) userInfo:nil repeats:YES];
    
    
    //这种需要 1. 手动加入RunLoop， 2. 需要手动fire开启
    self.timer2 = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(secondTimerHandler) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer2 forMode:NSDefaultRunLoopMode];
    [self.timer2 fire];
    
}
- (void)stopTimer
{
    [self.timer2 invalidate];
    [self.timer1 invalidate];
}
- (void)firstTimerHandler
{
    NSLog(@"NSDefaultRunLoopMode");
}

- (void)secondTimerHandler
{
    NSLog(@"手动加入RunLoop");
}
@end
