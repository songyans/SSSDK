//
//  ApplePayCenter.h
//  SSSDK
//
//  Created by SDK on 2018/5/7.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SongyorkInfo;

@interface ApplePayCenter : NSObject

@property (nonatomic, copy) void(^paymentCallback)(NSString *message, id params);


+ (ApplePayCenter *)sharedApplePayCenter;

- (void)registerCenter;

- (void)dealWithApplePayOrderInfo:(SongyorkInfo *)orderInfo viewController:(UIViewController *)viewController  completion:(void (^)(NSString *message, id params))completion;


@end
