//
//  SS_ZFForHtml.m
//  SSSDK
//
//  Created by SDK on 2018/3/10.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import "SS_ZFForHtml.h"
#import "SYHTMLViewController.h"

#import "SS_ZFNavigationVontroller.h"

@interface SS_ZFForHtml ()

@property (nonatomic ,strong) SS_AddIdentityInfo *addIdentityView;

@property (nonatomic ,strong) NSDictionary *info;

@property (nonatomic ,copy) NSString *message;

@property(nonatomic,strong)UIWindow *htmlZFWindow; //H5zhifu页面

@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, assign) BOOL isO;

@end

@implementation SS_ZFForHtml

SYSingletonM(SS_ZFForHtml)

/**
 检测zhifu环境, 并开始zhifu
 
 @param viewController 调起支付功能的viewController
 @param syInfo 支付所需参数
 @param completion 完成后回调
 */
- (void)startCheckTheSYWayWithViewController:(UIViewController *)viewController syInfo:(SongyorkInfo *)syInfo completion:(void (^)(NSString *message, id param))completion{
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getManagerBySingleton];
    Weak_Self;
    
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] checkSongyorkWithSongyorkInfo:syInfo completion:^(BOOL isSuccess, id  _Nullable respones) {
        if (isSuccess) {
            NSDictionary *dic = respones[@"data"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl = dic[@"o"];
            [weakSelf startShowTheOrderViewWithViewController:viewController songyorkInfo:syInfo completion:^(NSString *message, id param) {
                if (completion) {
                    completion(message, param);
                }
            }];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
    
    
}


/*
 
 #pragma mark ----------------------------------------------强制进入身份证页面
 //    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindModel.pay_User_Idcard_Check = YES;
 if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindModel.sy_User_Idcard_Check && ![SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindingIdCard) {
 [self checkIdentityBeforeLoggingIsConstraint:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindModel.sy_User_Idcard_Check_Need completion:^(AddIdentityInfoViewClickStates addViewClickStates) {
 if (addViewClickStates == 0) {
 [weakSelf verificationIsFinishedWithMessage:@"请验证身份信息后再进行支付"];
 }else{
 if (addViewClickStates == 1) {
 [weakSelf verificationIsFinishedWithMessage:@"验证成功"];
 }
 //                [weakSelf verificationIsFinishedWithMessage:nil];
 
 [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] checkTheSYWayForYYYWithPInfo:syInfo completion:^(BOOL isSuccess, id  _Nullable respones) {
 if (isSuccess) {
 NSDictionary *dic = respones[@"data"];
 [SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl = dic[@"o"];
 //            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].zhiUrl = @"https://sypay.shangshiwl.com/?ac=web";
 [weakSelf startShowTheOrderViewWithViewController:viewVontroller syInfo:syInfo completion:^(NSString *message, id param) {
 if (completion) {
 completion(message, param);
 }
 }];
 
 }else{
 
 }
 } failure:^(NSError * _Nullable error) {
 
 }];
 }
 }];
 
 }else{
 
 }
 
 */


/*
 * 开始支付接口
 */
-(void)startShowTheOrderViewWithViewController:(UIViewController *)viewController songyorkInfo:(SongyorkInfo *)songyorkInfo completion:(void (^)(NSString *, id))completion{
    Weak_Self;
    [[SY_FloatWindowTool sharedSY_FloatWindowTool] destroyFloatWindow];
    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl.length > 0) {

        self.htmlZFWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.htmlZFWindow.backgroundColor = [UIColor clearColor];
        SYHTMLViewController *h5 = [[SYHTMLViewController alloc] init];
        h5.zfUrlString = [SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl;
        h5.songyorkInfo = songyorkInfo;
        h5.syBlock = ^{
            weakSelf.htmlZFWindow = nil;
            if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].isAppStatus) {
                [[SY_FloatWindowTool sharedSY_FloatWindowTool] createFloatWindow];
            }
        };
        SS_ZFNavigationVontroller *nav = [[SS_ZFNavigationVontroller alloc] initWithRootViewController:h5];
        self.htmlZFWindow.rootViewController = nav;
        [self.htmlZFWindow makeKeyAndVisible];
        
        
    }else{
//        [SS_PublicTool showHUDWithViewController:viewController Text:@"支付失败"];
//        [[SY_FloatWindowTool sharedSY_FloatWindowTool] createFloatWindow];
        if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].canClick) {
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].canClick = NO;
            [self justApplePayForGameWithViewController:viewController songyorkInfo:songyorkInfo completion:^(NSString *message, id params) {
                if (completion) {
                    completion(message, params);
                    
                }
            }];
        }
    }
    
    
}



- (void)justApplePayForGameWithViewController:(UIViewController *)viewController songyorkInfo:(SongyorkInfo *)songyorkInfo completion:(void (^)(NSString *, id))completion{
//    [[ApplePayCenter sharedApplePayCenter] dealWithSongyorkInfo:songyorkInfo viewController:viewController completion:completion];
    [[ApplePayCenter sharedApplePayCenter] dealWithApplePayOrderInfo:songyorkInfo viewController:viewController completion:completion];
    
}


//- (void)justApplePayForGameWithViewController:(UIViewController *)viewController paymentInfo:(PInfo *)paymentInfo completion:(void (^)(NSString *, id))completion{
//    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] requestYYYForAppSYWithInfo:paymentInfo completion:^(BOOL isSuccess, id respones) {
//        if (isSuccess) {
//            SYLog(@"----------respones:%@", respones);
//            NSDictionary *data = respones[@"data"];
//            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].yyy = [NSString stringWithFormat:@"%@", data[@"order_sn"]];
//            [[ApplePayCenter sharedApplePayCenter] dealWithApplePayOrderInfo:paymentInfo viewController:viewController completion:^(NSString *message, id params) {
//                if (completion) {
//
//                    [OrderForApple sharedOrderForApple].block = ^(NSDictionary *dict) {
//                        completion(@"支付成功", dict);
//
//                    };
//                }
//            }];
////            [[OrderForApple sharedOrderForApple] startApplePayWithViewController:viewController PayInfo:paymentInfo];
////            if (completion) {
////
////                [OrderForApple sharedOrderForApple].block = ^(NSDictionary *dict) {
////                    completion(@"支付成功", dict);
////
////                };
////            }
//
//        }else{
//            SYLog(@"----------respones:%@", respones);
//
//        }
//    } failure:^(NSError *error) {
//
//    }];
//}


/**
 创建验证身份证页面
 
 @param isConstraint 是否强制绑定
 @param completion 完成后回调
 */

- (void)checkIdentityBeforeLoggingIsConstraint:(BOOL)isConstraint completion:(void(^)(AddIdentityInfoViewClickStates addViewClickStates))completion{
    
    //    [self.hud hideAnimated:YES];
    self.addIdentityView = [[SS_AddIdentityInfo alloc] initIfNeedMandatoryBindIdInfo:isConstraint viewController:self.viewController];
    self.addIdentityView.addIdentityInfoViewBlock = ^(AddIdentityInfoViewClickStates addViewStates) {
        if (completion) {
            completion(addViewStates);
        }
    };
    self.addIdentityView.center = self.viewController.view.center;
    
    [self.viewController.view addSubview:self.addIdentityView];
    
}

- (void)verificationIsFinishedWithMessage:(NSString *)message{
    [UIView animateWithDuration:0.3 animations:^{
        self.addIdentityView.y = Screen_Height;
    } completion:^(BOOL finished) {
        self.addIdentityView.hidden = YES;
        self.addIdentityView = nil;
    }];
    if (message.length > 0 && message) {
        [SS_PublicTool showHUDWithViewController:self.viewController Text:message];
    }
    
}


@end
