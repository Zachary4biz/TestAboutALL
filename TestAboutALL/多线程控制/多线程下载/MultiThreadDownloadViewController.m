//
//  MultiThreadDownloadViewController.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/23.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "MultiThreadDownloadViewController.h"
#import "MultiThreadDownloadManager.h"
#define downloadURL [NSURL URLWithString:@"http://wdj-uc1-apk.wdjcdn.com/1/e0/a9fe0515b8aaa294c0f25dfb4fb47e01.apk"]
//#define downloadURL [NSURL URLWithString:@"http://txt.bxwxtxt.com/packdown/fulltxt/112/112827.txt?8"]

@interface MultiThreadDownloadViewController ()<NSURLSessionDownloadDelegate>
- (IBAction)startBtn:(id)sender;
- (IBAction)suspendBtn:(id)sender;
- (IBAction)cancelBtn:(id)sender;
- (IBAction)resumeBtn:(id)sender;
- (IBAction)singleThreadBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *URLTextFiled;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;


@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *savePath;
@end

@implementation MultiThreadDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.progressView.trackTintColor = [UIColor redColor];
    self.progressView.progressTintColor = [UIColor cyanColor];
    self.URLTextFiled.text = downloadURL.absoluteString;
    
    //获取document路径
    //方式一
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
   
    //创建资源存储路径
    NSString *sourceName = downloadURL.absoluteString.lastPathComponent;
    self.savePath = [documentsPath stringByAppendingPathComponent:sourceName];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}


static NSString *ID;
- (IBAction)startBtn:(id)sender {
    NSDate *begin = [NSDate date];
    NSLog(@"%@",self.savePath);
    ID = [NSString stringWithFormat:@"%@",[NSDate date]];
    [[MultiThreadDownloadManager sharedInstance] dowloadAssignmentWithURL:downloadURL
                                                                    andID:ID
                                                                 FilePath:self.savePath
                                                        withProgressBlock:^(float progress,float speed) {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        self.progressView.progress = progress;
                                                                        NSString *str = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceDate:begin]];
                                                                        self.timeLbl.text = str;
                                                                    });
                                                                }];
}

- (IBAction)suspendBtn:(id)sender {
    [[MultiThreadDownloadManager sharedInstance] suspendAssignmentWithID:ID];
}

- (IBAction)resumeBtn:(id)sender {
    [[MultiThreadDownloadManager sharedInstance] resumeAssignmentWithID:ID];
}

- (IBAction)singleThreadBtn:(id)sender {
    NSLog(@">>>单线程下载");
    NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithURL:downloadURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"respons %@",response);
        if (error) {
            NSLog(@"er -%@",error);
        }else{
            [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:self.savePath] error:nil];
        }
    }];
    [task resume];
}
- (IBAction)cancelBtn:(id)sender {

}
@end
