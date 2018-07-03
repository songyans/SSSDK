//
//  SS_ZFForHtml.h
//  SSSDK
//
//  Created by SDK on 2018/3/10.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface SS_ZFForHtml : NSObject




+ (SS_ZFForHtml *)sharedSS_ZFForHtml;
/**
 检测zhifu环境, 并开始zhifu
 
 @param viewController 调起Z功能的viewVontroller
 @param syInfo 支付所需参数
 @param completion 完成后回调
 */
- (void)startCheckTheSYWayWithViewController:(UIViewController *)viewController
                                      syInfo:(SongyorkInfo *)syInfo
                                  completion:(void (^)(NSString *message, id param))completion;



/**
Apple Pay

@param viewController viewController
@param songyorkInfo paymentInfo
@param completion completion
*/
//- (void)justApplePayForGameWithViewController:(UIViewController *)viewController songyorkInfo:(SongyorkInfo *)songyorkInfo completion:(void (^)(NSString *message, id param))completion;


@end
