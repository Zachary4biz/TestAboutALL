//
//  Assist.m
//  TestAboutALL
//
//  Created by Zac on 2017/2/15.
//  Copyright © 2017年 周桐. All rights reserved.
//

#import "Assist.h"
@interface Assist()

@end

@implementation Assist
static NSString *BaiduAPIAppName = @"APITest";
static NSString *BaiduAPIAppID = @"9282393";
static NSString *BaiduAPIKey = @"v2OMTLKC3b1x6MK6bvYoYeXy";
static NSString *BaiduAPISecretKey = @"ta220mwmDk946O3lYtMbc9bKRD9H9dhm";

static NSString *BaiduAPIAuthorizationURL = @"https://aip.baidubce.com/oauth/2.0/token";
static NSString *BaiduAPIFaceDetectURL = @"https://aip.baidubce.com/rest/2.0/face/v1/detect";
static NSString *BaiduAPIFaceVerifyURL = @"https://aip.baidubce.com/rest/2.0/faceverify/v1/match";
static NSString *BaiduAPIOCRGeneralURL = @"https://aip.baidubce.com/rest/2.0/ocr/v1/general";
static NSString *BaiduAPIOCRIDCardURL = @"https://aip.baidubce.com/rest/2.0/ocr/v1/idcard";
static NSString *BaiduAPIOCRBankCard = @"https://aip.baidubce.com/rest/2.0/ocr/v1/bankcard";
+ (void)getTokenComplition:(void(^)(NSString *))complition
{
    
    NSString *paramStr = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@&",
                          @"grant_type",@"client_credentials",
                          @"client_id",BaiduAPIKey,
                          @"client_secret",BaiduAPISecretKey];
    NSString *requestStr = [BaiduAPIAuthorizationURL stringByAppendingString:paramStr];
    NSMutableURLRequest *aRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestStr]];
    aRequest.HTTPMethod = @"POST";
    NSURLSessionTask *aTask = [[NSURLSession sharedSession] dataTaskWithRequest:aRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"?????????????????????getToken出错 -- %@",error);
        }else{
            NSError *er;
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&er];
            if (er) {
                NSLog(@"?????????????????????getToken出错 -- %@",er);
            }else{
                NSString *token = result[@"access_token"];
                complition(token);
            }
        }
    }];
    [aTask resume];
}
+ (void)getAPIURLOf:(APIType)type WithComplition:(void(^)(NSURL *))complition
{
    [Assist getTokenComplition:^(NSString *token) {
        NSString *str = [[NSString alloc]init];
        switch (type) {
            case APITypeOCR_General:
                str = BaiduAPIOCRGeneralURL;
                break;
            case APITypeOCR_IDCard:
                str = BaiduAPIOCRIDCardURL;
                break;
            case APITypeOCR_BankCard:
                str = BaiduAPIOCRBankCard;
                break;
            case APITypeFace_Detect:
                str = BaiduAPIFaceDetectURL;
                break;
            case APITypeFace_Verify:
                str = BaiduAPIFaceVerifyURL;
                break;
            default:
                str = NULL;
                break;
        }
        if (str) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"?access_token=%@",token]];
            complition([NSURL URLWithString:str]);
        }else{
            NSLog(@"APIType不符合");
        }
    }];
}
+ (void)getBaiduAPIType:(APIType)type ResultWithImage:(UIImage*)image withCompletion:(void(^)(NSDictionary *))complition
{
    [Assist getAPIURLOf:type WithComplition:^(NSURL *url) {
        if (url) {
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            request.HTTPMethod = @"POST";
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            
            NSString *encodedStr = [Assist base64StrAndEncodedForImage:image];
#warning testing
            NSError *testEr;
            [encodedStr writeToFile:[NSHomeDirectory() stringByAppendingString:@"/tmp/encodedStr"] atomically:YES encoding:NSUTF8StringEncoding error:&testEr];
            
            if (testEr) {
                NSLog(@"%@",testEr);
            }
#warning testing
            
            NSString *bodyStr = [NSString stringWithFormat:@"image=%@",encodedStr];
            request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData * _Nullable data,
                                                                                         NSURLResponse * _Nullable response,
                                                                                         NSError * _Nullable error) {
                                                                         if (error) {
                                                                             NSLog(@"网络-error %@",error);
                                                                         }else{
                                                                             NSError *er;
                                                                             NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                                  options:NSJSONReadingAllowFragments
                                                                                                                                    error:&er];
                                                                             if (!er) {
                                                                                 complition(JSON);
                                                                             }else{
                                                                                 complition(nil);
                                                                                 NSLog(@"JSON-error - %@",er);
                                                                                 NSLog(@"");
                                                                                 NSLog(@">>respons is %@",response);
                                                                                 NSLog(@"");
                                                                                 NSLog(@"string is %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                                                                             }
                                                                         }
                                                                     }];
            [task resume];
        }
    }];

}

+(NSString *)base64StrAndEncodedForImage:(UIImage *)image
{
    //base64
    NSData *base64Data = UIImagePNGRepresentation(image);
    NSString *base64Str = [base64Data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //encoded
    NSString *character2Escape = @"!*'();:@&=+$,/?%#[]";
    NSCharacterSet *allowedCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:character2Escape] invertedSet];
    NSString *resultStr = [base64Str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    return resultStr;
}

@end
