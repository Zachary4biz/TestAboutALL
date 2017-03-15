//
//  Assist.h
//  TestAboutALL
//
//  Created by Zac on 2017/2/15.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Assist : NSObject
typedef enum{
    APITypeOCR_General,
    APITypeOCR_IDCard,
    APITypeOCR_BankCard,
    APITypeFace_Detect,
    APITypeFace_Verify
}APIType;
//+ (void)getTokenComplition:(void(^)(NSString *))complition;
+ (void)getBaiduAPIType:(APIType)type ResultWithImage:(UIImage*)image withCompletion:(void(^)(NSDictionary *))complition;
@end
