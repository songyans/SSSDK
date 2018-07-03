//
//  SY_FloatWindowTool.h
//  SSSDK
//
//  Created by SDK on 2018/5/24.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SS_UserManager.h"
#import "SS_PersonCenterWindow.h"
#import "SS_FloatWindow.h"
#import "SS_UserManagerNavController.h"
#import "SS_UserManagerController.h"

@interface SY_FloatWindowTool : NSObject


@property (nonatomic, strong) UIWindow *htmlWindow; //H5Window

/* *悬浮窗 */
@property(nonatomic, strong) SS_FloatWindow *change_floatWindow;

@property (nonatomic ,strong) SS_PersonCenterWindow *personCenterW;

@property (nonatomic ,strong) SS_UserManager *userManagerW;

@property (nonatomic, strong) SS_UserManagerNavController *userManagerNav;

@property (nonatomic, strong) SS_UserManagerController *uVC;

@property (nonatomic, strong) UIWindow *tipsWebWindow;


SYSingletonH(SY_FloatWindowTool)


/**
 创建悬浮窗
 */
- (void)createFloatWindow;


/**
 改绑手机
 */
- (void)changeBindMobilPhone;



/**
 销毁悬浮窗
 */
- (void)destroyFloatWindow;



/**
 创建HTML_Game页面
 
 @param openuUrl 打开链接
 @param zUrl GQ链接
 */
- (void)creatHtmlGameWithUrl:(NSString *_Nullable)openuUrl
                        zUrl:(NSString *_Nullable)zUrl;



@end
