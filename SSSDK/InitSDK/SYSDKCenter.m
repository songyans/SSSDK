//
//  SYSDKCenter.m
//  SSSDK
//
//  Created by SDK on 2018/3/10.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import "SYSDKCenter.h"

#import "LoginNavigationController.h"
#import "SS_LoginViewController.h"
#import "SS_LoginForPhoneViewController.h"
#import "SS_RegistViewController.h"
#import "SS_FirstOpenViewController.h"

#import "GiftController.h"
#import "CheckSongyorkFromLocal.h"

@interface SYSDKCenter ()
{
    NSTimer *_timer;
    int _currentTime;
    NSString *_roleId;
    NSString *_userId;
    NSString *_gameTime;
}
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@property(nonatomic,strong)UIWindow *loginWindow;


@property(nonatomic,strong)MBProgressHUD *HUD;

//注意＊＊这里不需要✳️号 可以理解为dispatch_time_t 已经包含了
@property (nonatomic, strong)dispatch_source_t time;

@property (nonatomic ,copy) NSString *appID;

@property (nonatomic, assign) int direction;

@property (nonatomic, assign) BOOL isOut;


@property (nonatomic ,strong) UIViewController *viewC;


@end

@implementation SYSDKCenter


SYSingletonM(SYSDKCenter)

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SYLog(@"---销毁通知---");
}


#pragma mark --- 1、初始化SDK
- (void)initSDKWithAppId:(NSString *)appId screenDirection:(GameDirection)screenGameDirection urlScheme:(NSString *)urlScheme{
    
    if (appId.length < 1) {
        return;
    }
    if (screenGameDirection == 1) {
        self.direction = 1;
    }else if (screenGameDirection == 0){
        self.direction = 0;
    }else{
        return;
    }
    
    
    
    
    
    [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] setSDKInfoWithAppId:appId directionNumber:self.direction];
    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].needAuto = YES;
    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].urlScheme = urlScheme;
    
    
    self.appID = appId;
    
    /**
     * ApplePayAction初始化
     */
#pragma mark ------------------------------------------------OrderForApple初始化
    [[ApplePayCenter sharedApplePayCenter] registerCenter];
    
    
    /*网络请求初始化*/
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getManagerBySingleton];
    
    
    
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getCustomerServiceCompletion:^(BOOL isSuccess, id response) {
        if (isSuccess) {
            SYLog(@"-----------response:%@", response);
            NSDictionary *dict = response[@"data"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].customerService = dict[@"url"];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getRegexpCompletion:^(BOOL isSuccess, id  _Nullable response) {
        if (isSuccess) {
            SYLog(@"%@", response);
            NSDictionary *dict = response[@"data"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].regexModel = [SS_RegexModel getRegexWithData:dict];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
    
    
    Weak_Self;
    /*
     * 是否激活
     */
    //  [self judgeNet];
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getNetWorkStateBlock:^(NSInteger netStatus) {
        switch (netStatus) {
            case 0:
                SYLog(@"------------------断网状态");
                break;
                
            case 1:
                SYLog(@"------------------Wifi状态");
                if (![SS_PublicTool getCurrentActivateFlag]){
                    [weakSelf userActivate];
                }else{
                    SYLog(@"用户未激活");
                    
                }
                break;
                
            case 2:
                SYLog(@"------------------流量状态");
                if (![SS_PublicTool getCurrentActivateFlag]){
                    [weakSelf userActivate];
                }else{
                    SYLog(@"用户已激活");
                    
                }
                
                break;
                
            case 3:
                SYLog(@"------------------未知状态");
                
                break;
                
            default:
                break;
        }
    }];
    [CheckSongyorkFromLocal checkSongyorkFromLocal];
    
    /*通知 : 退出游戏*/
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(signOutGame:) name:SS_SignOutGame object:nil];
    
}

//用户激活
- (void)userActivate{
    
    
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getUserActivateCompletion:^(BOOL isActivate, id response) {
        if (isActivate) {
            SYLog(@"用户激活成功----%@", response);
            [SS_PublicTool saveActivateFlag:YES];
        }else{
            if (![response[@"msg"] isEqualToString:@"此设备ID已激活过"]) {
//                [SS_PublicTool showHUDWithViewController:self.viewC Text:response[@"msg"]];
                
            }
        }
        
    } failure:^(NSError * _Nullable error) {
//        [SS_PublicTool showHUDWithViewController:self.viewC Text:@"网络异常"];
    }];
    
}





/**
 开始登录接口
 
 @param viewController viewController
 @param completion 完成回调(给研发)
 */
- (void)startLoginWithViewController:(UIViewController *)viewController completion:(void (^)(NSString *))completion failure:(void (^)(NSError * _Nullable))failure{
#pragma mark ------------------------------------------------测试第一次登录
    //    [SS_PublicTool firstOpenaApplication:NO];
    if ([SS_PublicTool getCurrenFirstOpenApplication]) {
        [self loginTypeWithFirstOrNot:NO completion:^(NSString *url, NSString *gqUrl, NSString *code) {
            
            if (completion) {
                completion(code);
            }
        }];
    }else{
        [self loginTypeWithFirstOrNot:YES completion:^(NSString *url, NSString *gqUrl, NSString *code) {
            if (completion) {
                completion(code);
            }
            
            
        }];
    }
    self.viewC = viewController;
}


/**
 是否是第一次登录
 
 @param isFirst BOOL
 @param completion 完成回调
 */
- (void)loginTypeWithFirstOrNot:(BOOL)isFirst completion:(void(^)(NSString *url, NSString *gqUrl, NSString *code))completion{
    Weak_Self;
    
    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isTouristLogin = [SS_PublicTool getTouristState];
    
    /**
     * 获取基本信息
     * 是否开启正式服
     * 中英文切换等
     */
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getInfoWithAppId:self.appID completion:^(BOOL isSuccess, id  _Nullable respones) {
        if (isSuccess) {
            SYLog(@"----------%@", respones);
            int status = [respones[@"data"][@"ui_status"] intValue];
            if (status == 1) {
//                weakSelf.isChiness = YES;
//                [SS_PublicTool saveLanguage:self.isChiness];
            }else{
//                weakSelf.isChiness = NO;
//                [SS_PublicTool saveLanguage:self.isChiness];
                
            }
            
            NSDictionary *dict = respones[@"data"][@"idcard_check"];
            
            SYLog(@"%@", dict);
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindModel = [SS_BindIdentituInfoModel getBindIdentityInfoWithData:dict];
            
            /**
             * 技术是否是正式版本
             * isAppStatus
             */
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isAppStatus = [respones[@"data"][@"app_status"] boolValue];
            
#pragma mark ------------------------------------------------强制进入正式版
            
//            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isAppStatus = YES;
            //            SYLog(@"-----------------------------isAppStatus:%d", [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isAppStatus);
#pragma mark ------------------------------------------------直接一键登录 5 游戏
            if (![SS_SDKBasicInfo sharedSS_SDKBasicInfo].isAppStatus) {
               
                [weakSelf getUserOnce_LoginSuccess:^(NSString *code) {
                    if (completion) {
                        completion(@"", @"", code);
                    }
                } failure:^(NSError * _Nullable error) {
                    
                }];
                return;
            }
            /*应市场需求,可以自行删除设备信息.让设备出去未激活状态*/
            [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] clearDeviceIdWithAppId:self.appID completion:^(BOOL isSuccess, id resp) {
                if (isSuccess) {
//                    D858D866D1764EB191C68D5F0C12EDDC
                    NSString *clearStr = [NSString stringWithFormat:@"%@", resp[@"data"][@"exec_clear"]];
//                    clearStr = @"1";
                    if ([clearStr intValue] == 1) {
                        [KeyChainWrapper delete:@"uuid"];
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid = [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] getUUID];
                        [KeyChainWrapper save:SS_UserName_Fast data:nil];
                        [KeyChainWrapper save:SS_Password_Fast data:nil];
                    }
                    
                    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] checkLoginNoticeCompletion:^(BOOL isSuccess, id response) {
                        
                        NSDictionary *dic = response[@"data"];
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].tipsID = dic[@"id"];
                        // 判断是否保存账号,自动登录
                        //创建登录注册界面
                        //防止与主window冲突，延迟执行；
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                            
                            [weakSelf getRootWindowWithType:isFirst completion:^(NSString *url, NSString *gqUrl, NSString *code) {
                                if (completion) {
                                    completion(url, gqUrl, code);
                                }
                            }];
                            
                            /*
                             //测试
                             //            self.isFirstOpen = YES;
                             if (self.isFirstOpen) {
                             FirstOpenViewController *firstVC = [[FirstOpenViewController alloc] init];
                             firstVC.direction = self.direction;
                             firstVC.block = ^{
                             weakSelf.loginWindow.alpha = 0;
                             weakSelf.loginWindow = nil;
                             
                             };
                             
                             _loginWindow.rootViewController = [[LoginNavigationController alloc] initWithRootViewController:firstVC];
                             }else{
                             
                             
                             }
                             */
                            
                        });
                        
                    } failure:^(NSError *error) {
                        //        [self showHUDWithText:@"网络异常"];
                    }];
                    
                    
                    
                }
            }failure:^(NSError *error) {
                
            }];
            
            
            
        }else{
            
            
            weakSelf.HUD = [MBProgressHUD showHUDAddedTo:weakSelf.viewC.view animated:YES];
            weakSelf.HUD.mode = MBProgressHUDModeText;
            weakSelf.HUD.label.text = @"网络异常";
            [weakSelf.HUD hideAnimated:YES afterDelay:1];
            completion(@"网络异常", @"网络异常", @"网络异常");
            
            SYLog(@"----------%@", respones);
            
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}


/**
 rootviewcontrol
 
 @param isFirst 是否是第一次
 @param completion 完成后回调
 */
- (void)getRootWindowWithType:(BOOL)isFirst completion:(void(^)(NSString *url, NSString *gqUrl, NSString *code))completion{
    Weak_Self;
    _loginWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _loginWindow.backgroundColor = SYNOColor;
    _loginWindow.windowLevel = UIWindowLevelAlert + 0.1;
    [_loginWindow makeKeyAndVisible];
    if (isFirst) {
        SS_FirstOpenViewController *firstVC = [[SS_FirstOpenViewController alloc] init];
        firstVC.block = ^{
            weakSelf.loginWindow.alpha = 0;
            weakSelf.loginWindow = nil;
            NSString *url = [SS_SDKBasicInfo sharedSS_SDKBasicInfo].requestUrl;
            NSString *money = [SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl;
            NSString *gameCode = [SS_SDKBasicInfo sharedSS_SDKBasicInfo].gameCode;
            
            if (gameCode.length < 1) {
                gameCode = @".......";
            }
            if (completion) {
                completion(url, money, gameCode);
            }
        };
        LoginNavigationController *lNav = [[LoginNavigationController alloc] initWithRootViewController:firstVC];
        [SS_PublicTool stopSystemPopGestureRecognizerForNavigationController:lNav];
        
        _loginWindow.rootViewController = lNav;
    }else{
        
        SS_LoginForPhoneViewController *loginVC = [[SS_LoginForPhoneViewController alloc] init];
//        loginVC.isOnline = self.isChiness;
        loginVC.isOnline = YES;
        loginVC.block = ^{
            weakSelf.loginWindow.alpha = 0;
            weakSelf.loginWindow = nil;
            NSString *url = [SS_SDKBasicInfo sharedSS_SDKBasicInfo].requestUrl;
            NSString *money = [SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl;
            NSString *gameCode = [SS_SDKBasicInfo sharedSS_SDKBasicInfo].gameCode;
            
            if (gameCode.length < 1) {
                gameCode = @".......";
            }
            if (completion) {
                completion(url, money, gameCode);
            }
        };
        LoginNavigationController *lNav = [[LoginNavigationController alloc] initWithRootViewController:loginVC];
        [SS_PublicTool stopSystemPopGestureRecognizerForNavigationController:lNav];
        
        _loginWindow.rootViewController = lNav;
    }
    
    
    
    
}




/*创建角色接口*/
- (void)userCreateRoleWithRoleId:(NSString *)roleId userId:(NSString *)userId time:(NSString *)time completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] userCreateRoleWithRoleId:roleId userId:userId htmlSign:@"" time:time completion:^(BOOL isSuccess, id  _Nullable respones) {
        if (isSuccess) {
            SYLog(@"创建角色----------respones:%@", respones);
            _currentTime = 0;
            _roleId = roleId;
            _userId = userId;
            _gameTime = time;
            /* *自行调用5分钟在线 */
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(fiveMinSender:) userInfo:nil repeats:YES];
            [_timer fire];
            if (completion) {
                completion(YES, respones);
            }
        }else{
            if (completion) {
                completion(NO, respones);
            }
            SYLog(@"创建角色----------respones:%@", respones);
        }
    } failure:^(NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


/**
 NSTimer 方法

 @param sender sender
 */
- (void)fiveMinSender:(id)sender{
    _currentTime++;
    SYLog(@"currenTime = %d", _currentTime);
    if (_currentTime == 300) {
        [self onlineFor5MinutesWithUserId:_userId roleId:_roleId time:_gameTime completion:^(BOOL isSuccess, id  _Nullable respones) {
            if (isSuccess) {
                SYLog(@"角色在线5分钟成功----------respones:%@", respones);
              
            }else{
                
                SYLog(@"角色在线5分钟失败----------respones:%@", respones);
            }
           
        } failure:^(NSError * _Nullable error) {
            
        }];
    }
}

/*在线5分钟接口*/
- (void)onlineFor5MinutesWithUserId:(NSString *)userId roleId:(NSString *)roleId time:(NSString *)time completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    
    
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] onlineFor5MinutesWithUserId:userId roleId:roleId time:time htmlSign:@"" completion:^(BOOL isSuccess, id respones) {
        if (isSuccess) {
            SYLog(@"角色在线5分钟----------respones:%@", respones);
            if (completion) {
                completion(YES, respones);
            }
        }else{
            if (completion) {
                completion(NO, respones);
            }
            SYLog(@"角色在线5分钟----------respones:%@", respones);
        }
         [_timer invalidate];
        _timer = nil;
        _currentTime = 0;
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
         [_timer invalidate];
        _timer = nil;
        _currentTime = 0;
    }];
}

/*角色升级接口*/
- (void)levelUpWithUserId:(NSString *)userId roleId:(NSString *)roleId level:(NSString *)level time:(NSString *)time completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] levelUpWithUserId:userId roleId:roleId level:level time:time htmlSign:@"" completion:^(BOOL isSuccess, id respones) {
        if (isSuccess) {
            SYLog(@"角色升级----------respones:%@", respones);
            if (completion) {
                completion(YES, respones);
            }
        }else{
            if (completion) {
                completion(NO, respones);
            }
            SYLog(@"角色升级----------respones:%@", respones);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/* *用户登录服务器 */
- (void)userServerLoginWithUserId:(NSString *)userId serverId:(NSString *)serverId loginTime:(NSString *)loginTime completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] userServerLoginWithUserId:userId serverId:serverId loginTime:loginTime time:@"" gameSign:@"" completion:completion failure:failure];
}



/*接收通知,退出游戏*/
- (void)signOutGame:(NSNotification *)notification{
    SYLog(@"-----object:%@ ----- userInfo:%@ ------ name:%@", notification.object, notification.userInfo, notification.name);
    NSDictionary *dic = notification.userInfo;
    self.isOut = [[dic valueForKey:notification.object] boolValue];
    
    if (self.isOut) {
        [[SY_FloatWindowTool sharedSY_FloatWindowTool] destroyFloatWindow];
        [_timer invalidate];
        _timer = nil;
        _currentTime = 0;
    }else{
        SYLog(@".....");
    }
    
}

/*给研发的退出游戏接口*/
- (void)gameIsSignOutIfNeedSignIn:(BOOL)isSignIn completion:(void (^ _Nullable)(NSString * _Nullable))completion failure:(void (^ _Nullable)(NSError * _Nullable))failure{
    
    SYLog(@"研发方退出登录");
    [[SY_FloatWindowTool sharedSY_FloatWindowTool] destroyFloatWindow];
    //isSignOut ? YES (自动弹出登录框) : NO (不会弹出登录框)
    if (isSignIn) {
        [self startLoginWithViewController:self.viewC completion:^(NSString *code) {
            if (completion) {
                completion(code);
            }
        } failure:^(NSError * _Nullable error) {
            if (failure) {
                failure(error);
            }
        }];
    }
    
}



- (void)ifIControlTheGameStartLoginWithViewController:(UIViewController *)viewController completion:(void(^)(NSString *code ,NSString *userId, NSString *userName))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure{
#pragma mark ------------------------------------------------测试第一次登录
    //    [SS_PublicTool firstOpenaApplication:NO];
    if ([SS_PublicTool getCurrenFirstOpenApplication]) {
        [self loginTypeWithFirstOrNot:NO completion:^(NSString *url, NSString *gqUrl, NSString *code) {
            
            NSString *username = [NSString stringWithFormat:@"%@", [SS_SDKBasicInfo sharedSS_SDKBasicInfo].loginUser];
            NSString *userId = [NSString stringWithFormat:@"%@", [SS_SDKBasicInfo sharedSS_SDKBasicInfo].userId];
            if (completion) {
                completion(code, userId, username);
            }
        }];
    }else{
        [self loginTypeWithFirstOrNot:YES completion:^(NSString *url, NSString *gqUrl, NSString *code) {
            NSString *username = [NSString stringWithFormat:@"%@", [SS_SDKBasicInfo sharedSS_SDKBasicInfo].loginUser];
            NSString *userId = [NSString stringWithFormat:@"%@", [SS_SDKBasicInfo sharedSS_SDKBasicInfo].userId];
            if (completion) {
                completion(code, userId, username);
            }
            
            
        }];
    }
    self.viewC = viewController;
}
- (void)ifIControlTheGameIsSignOutIfNeedSignIn:(BOOL)isSignIn completion:(void (^)(NSString * _Nullable, NSString * _Nullable, NSString * _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    SYLog(@"研发方退出登录");
    [[SY_FloatWindowTool sharedSY_FloatWindowTool] destroyFloatWindow];
    //isSignOut ? YES (自动弹出登录框) : NO (不会弹出登录框)
    if (isSignIn) {
        [self ifIControlTheGameStartLoginWithViewController:self.viewC completion:^(NSString * _Nullable code, NSString * _Nullable userId, NSString * _Nullable userName) {
            if (completion) {
                completion(code, userId, userName);
            }
        } failure:^(NSError * _Nullable error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}


- (void)shareIsSuccess:(BOOL)isSuccess{
    
    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isShareSuccess = isSuccess;
    //    if (isSuccess) {
    //        GiftController *giftVC = [[GiftController alloc] init];
    //        [giftVC ifShareIsSuccess];
    //    }
    
}

- (void)getUserOnce_LoginSuccess:(void(^)(NSString * code))completion  failure:(void (^)(NSError * _Nullable error))failure{
    Weak_Self;
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] registTouristCompletion:^(BOOL isSuccess, id  _Nullable respones) {
        if (isSuccess) {
            [weakSelf createFloatWindowIntoGame];
            if (completion) {
                completion([SS_SDKBasicInfo sharedSS_SDKBasicInfo].gameCode);
            }else{
                NSDictionary *dic = respones;
                [SS_PublicTool showHUDWithViewController:weakSelf.viewC Text:dic[@"msg"]];
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
        [SS_PublicTool showHUDWithViewController:weakSelf Text:@"网络异常"];
    }];
}


- (void)createFloatWindowIntoGame{
    
    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].requestUrl.length > 0) {
        [[SY_FloatWindowTool sharedSY_FloatWindowTool] creatHtmlGameWithUrl:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].requestUrl zUrl:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl];
    }
}

@end
