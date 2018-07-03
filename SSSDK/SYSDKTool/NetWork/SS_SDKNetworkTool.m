//
//  NetworkTool.m
//  SSSDK
//
//  Created by SDK on 2017/7/25.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "SS_SDKNetworkTool.h"
//#import "H5ViewController.h"
#import "SS_FloatWindow.h"
#import "SS_PersonCenterWindow.h"
#import "SS_UserManager.h"
#import "SS_UserManagerController.h"
//#import "SS_KeFuViewController.h"
#import "SS_WebTipSController.h"
//#import "AVMPTool.h"
#import "SS_UserManagerNavController.h"

#import "SS_PersonTabBarController.h"



@interface SS_SDKNetworkTool  ()



/*
 @property(nonatomic,strong)PersonCenterViewController *personCenterViewCtr;
 @property(nonatomic,strong)UIWindow *customerSerWindow;  //客服中心
 @property(nonatomic,strong)TFCustomerServiceViewController *cusSerViewCtr;
 @property(nonatomic,strong)UIWindow *logoutWindow;  //切换账号按钮
 @property(nonatomic,strong)TFLogoutViewController *logoutViewCtr;
 @property(nonatomic,strong)UIWindow *bindIdCardWindow;  //实名认证界面
 @property(nonatomic,strong)TFBindIdCardViewController *bindIdCardViewCtr;
 */


@property(nonatomic, strong) AFHTTPSessionManager *manager;
@property(nonatomic, strong) AFNetworkReachabilityManager *netManager;

@property(nonatomic, strong) SS_FloatWindow *change_floatWindow;// 登录成功创建悬浮窗

@property (nonatomic ,strong) SS_PersonCenterWindow *personCenterW;

@property (nonatomic ,strong) SS_UserManager *userManagerW;

@property (nonatomic ,strong) UIWindow *kefuWindow;

@property (nonatomic, strong) UIWindow *tipsWebWindow;

@property (nonatomic, strong) UIWindow *htmlWindow; //H5Window

@property (nonatomic, strong) SS_UserManagerNavController *userManagerNav;


@property (nonatomic, strong) SS_UserManagerController *uVC;


@end

@implementation SS_SDKNetworkTool

SYSingletonM(SS_SDKNetworkTool)


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


//*** 0、单例加载manager属性
-(void)getManagerBySingleton{
    _manager = [self singletonLoadManager];
    self.netManager = [self singletonLoadNetManager];
//    [AVMPTool sharedAVMPTool]; //getSGAVMPWithParamStr
    
    /**
     * 用于退出游戏
     */
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(signOutGame:) name:SS_SignOutGame object:nil];
}

-(AFHTTPSessionManager *)singletonLoadManager{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        //        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
//        [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        
        /**
         * 设置请求头部

         @param NSString aliSDK请求头部的签名
         */
//        [manager.requestSerializer setValue:@"" forHTTPHeaderField:@""];
       
    });
    return manager;
}

- (AFNetworkReachabilityManager *)singletonLoadNetManager{
    static AFNetworkReachabilityManager *netManager = nil;
    static dispatch_once_t onecTokens;
    dispatch_once(&onecTokens, ^{
        netManager = [AFNetworkReachabilityManager manager];
    });
    return netManager;
}

- (void)getNetWorkStateBlock:(void(^)(NSInteger netStatus))statusBlock{
    
    
    [self.netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                SYLog(@"网络不可用");
                if (statusBlock) {
                    statusBlock(0);
                }
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                SYLog(@"Wifi已开启");
                if (statusBlock) {
                    statusBlock(1);
                }

                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                SYLog(@"你现在使用的流量");
                if (statusBlock) {
                    statusBlock(2);
                }
                break;
            }
                
            case AFNetworkReachabilityStatusUnknown: {
                SYLog(@"你现在使用的未知网络");
                if (statusBlock) {
                    statusBlock(3);
                }
                
                break;
            }
                
            default:
                break;
        }
    }];
    [self.netManager startMonitoring];
    
}


/**
 * 阿里防火墙

 @param paramStr 请求链接
 @param param 参数
 */
- (void)getSGAVMPWithParamStr:(NSString *)paramStr param:(id)param{
    
//    NSString *wToken = [[AVMPTool sharedAVMPTool] avmpSignWithParamStr:paramStr param:param];
//    [_manager.requestSerializer setValue:wToken forHTTPHeaderField:@"wToken"];
    NSDictionary *requestHeaders = _manager.requestSerializer.HTTPRequestHeaders;
    
//    NSString *user_Agent = [NSString string];
    if (![requestHeaders[@"User-Agent"] containsString:@"version"]) {
        NSString *user_Agent = [NSString stringWithFormat:@"%@/version(%@)", requestHeaders[@"User-Agent"], [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version];
        [_manager.requestSerializer setValue:user_Agent forHTTPHeaderField:@"User-Agent"];

    }
   
    SYLog(@"-------_manager.requestSerializer.HTTPRequestHeaders : %@   \n ----", _manager.requestSerializer.HTTPRequestHeaders);
    
}

//激活
- (void)getUserActivateCompletion:(void (^)(BOOL isActivate, id response))completion failure:(void (^ _Nullable)(NSError * _Nullable))failure{
    
    NSDictionary *params = [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] getDeviceInfo];
    SYLog(@"激活-----params:%@------", params);
    NSString *paramStr =@"ct=index&ac=active";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SS_URL_Head, paramStr];
    [self getSGAVMPWithParamStr:paramStr param:params];
    [_manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"激活-------success--------------originalDic-------- %@",originalDic);
        if ([originalDic[@"state"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
            SYLog(@"dic-------- %@",dic);
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        

    }];
    
    
}


/**
 * 获取游戏基本信息
 */
- (void)getGameInfoCompletion:(void(^)(BOOL isSuccess, id response)) completion failure:(void(^)(NSError * error))failure{
    NSDictionary *paramterDict = @{
                            @"token"     :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken,
                            };
   
   NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];
    
    NSString *paramStr = @"ct=sys&ac=getGameInfo";
    [self getResponseWithUrl:paramStr parameters:params medthod:@"游戏基本信息" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess){
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion( NO, responesObj);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}



- (void)getRegexpCompletion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    NSDictionary *paramterDict = @{
                            @"language"     :   @"oc",
                            };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=sys&ac=getRegexp";
    [self getResponseWithUrl:paramStr parameters:params medthod:@"获取正则表达式" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess){
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion( NO, responesObj);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

//客服....
- (void)getCustomerServiceCompletion:(void(^)(BOOL isSuccess, id response)) completion failure:(void (^ _Nullable)(NSError * _Nullable))failure{
    NSDictionary *paramterDict = @{
                      @"time"        : [SS_PublicTool getTimeStamps],
                      };
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=sys&ac=getOnlineKefuUrl";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SS_URL_Head, paramStr];
//    [self getSGAVMPWithParamStr:paramStr param:params];

    
    [_manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"success--------------originalDic-------- %@",originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
            SYLog(@"客服链接------- dic-------- %@",dic);
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
        
    }];

}

/*
 NSDictionary *savedUser = @{SS_UserName : weakSelf.responesParam[@"username"], SS_Password : weakSelf.responesParam[@"password"]};
 [KeyChainWrapper save:SS_fastLoginKey data:savedUser];
 */
//游客
- (void)registTouristCompletion:(void (^)(BOOL, id))completion failure:(void (^ _Nullable)(NSError * _Nullable))failure{
    Weak_Self;
    NSDictionary *paramterDict = @{
                             @"device_id"   : [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] getUUID],
                             @"app_id"      : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                             @"app_channel"  : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].app_channel,
                             @"system_name" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model,
                             @"system_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].system_Version,
                             @"platform"    : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].platform,
                             @"time"        : [SS_PublicTool getTimeStamps],
                             @"idfa"        : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfa,
                             @"idfv"        : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfv,
                             @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                             };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    SYLog(@"游客------params:%@-----", params);
    
    NSString *paramStr = @"ct=index&ac=guestLogin";
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SS_URL_Head, paramStr];
    [self getSGAVMPWithParamStr:paramStr param:params];

    
    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"游客-------success--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
            SYLog(@"dic-------- %@",dic);
//            [weakSelf saveWithUsername:originalDic[@"data"][@"username"] andWithPassword:originalDic[@"data"][@"password"]];
            
            NSString *username = [NSString stringWithFormat:@"%@", originalDic[@"data"][@"username"]];
            id touristPass = originalDic[@"data"][@"password"];
            if (touristPass) {
                NSString *password = [NSString stringWithFormat:@"%@", touristPass];
                if ([KeyChainWrapper load:SS_UserName_Fast] == nil || ![[KeyChainWrapper load:SS_UserName_Fast] isEqualToString:username]) {
                    
                    if ([KeyChainWrapper load:SS_Password_Fast] == nil) {
                        [KeyChainWrapper save:SS_UserName_Fast data:username];
                        [KeyChainWrapper save:SS_Password_Fast data:password];
                    }
                    
                }
            }
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].fastUserName = username;
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].loginUser = username;
            if (![SS_PublicTool getTouristState]) {
                [SS_PublicTool useToTouristLogin:YES];

            }
//            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isTouristLogin = [SS_PublicTool getTouristState];
            NSString *touristStr = @"ct=index&ac=guestLogin";
            NSString *touristUrl = [NSString stringWithFormat:@"%@%@", SS_URL_Head, touristStr];
//            NSString *wToken = [[AVMPTool sharedAVMPTool] avmpSignWithParamStr:touristStr param:params];
//            [_manager.requestSerializer setValue:wToken forHTTPHeaderField:@"wToken"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken = dic[@"token"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].gameCode = dic[@"code"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].requestUrl = dic[@"h5_game_url"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl = dic[@"o"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].userId = dic[@"user_id"];
            
            [weakSelf getUserBasicInfoCompletion:^(BOOL isSuccess, id respones) {
                if (isSuccess) {
                    SYLog(@"%@", respones);
                    NSDictionary *dict = respones[@"data"];
                    NSString *phoneNumber = dict[@"phone"];
                    
                    if (phoneNumber.length > 1) {
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = YES;
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindPhoneNumber = phoneNumber;
                    }else{
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = NO;
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindPhoneNumber = @"";
                    }
                    SYLog(@"[SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = %d", [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone);
                    if (completion) {
                        completion(YES, originalDic);
                    }
                }else{
                    SYLog(@"%@", respones);
                    if (completion) {
                        completion(NO, originalDic);
                    }
                }
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
            
           
            }else{
                if (completion) {
                    completion(NO, originalDic);
                }
            }
        
            

    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        if (failure) {
            failure(error);
        }
    }];

}



//            [_manager POST:touristUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//                NSDictionary *originalDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//                SYLog(@"success--------------originalDic-------- %@------------message:%@",originalDict, originalDict[@"msg"]);
//                if ([originalDic[@"state"] intValue] == 1) {

//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                if (completion) {
//                    completion(NO, error, @"登录失败");
//                }
//            }];


//注册
- (void)registWithUserName:(NSString *)userName password:(NSString *)password regType:(RegistType)registType code:(NSString *)code completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^ _Nullable)(NSError * _Nullable))failure{
    NSString *reg_type = [NSString string];
    if (registType == RegistTypeName) {
        reg_type = @"0";
        if (code == nil && code.length < 1) {
            code = @"";
        }
    }else{
        reg_type = @"1";
        if (password == nil || password.length < 1) {
            password = @"";
        }
    }
    Weak_Self;
    NSDictionary *paramterDict = @{
                          @"device_id"   : [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] getUUID],
                          @"app_id"      : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                          @"app_channel"  : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].app_channel,
                          @"system_name" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model,
                          @"system_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].system_Version,
                          @"platform"    : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].platform,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"username"    : userName,
                          @"password"    : password,
                          @"reg_type"    : reg_type,
                          @"code"        : code,
                          @"idfa"        : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfa,
                          @"idfv"        : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfv,
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,

                          };
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    SYLog(@"注册------params:%@-----", params);
    NSString *paramStr = @"ct=index&ac=reg";
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SS_URL_Head, paramStr];
        [self getSGAVMPWithParamStr:paramStr param:params];

    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"注册-------success--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
            SYLog(@"dic-------- %@",dic);
            [weakSelf saveWithUsername:userName password:password];
            
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];

    
}

//登录
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^ _Nullable)(NSError * _Nullable))failure{
    Weak_Self;
    
    NSDictionary *paramterDict = @{
                          @"device_id"      :   [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] getUUID],
                          @"app_id"         :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                          @"app_channel"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].app_channel,
                          @"system_name"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model,
                          @"system_version" :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].system_Version,
                          @"platform"       :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].platform,//,
                          @"time"           :   [SS_PublicTool getTimeStamps],
                          @"idfa"           :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfa,
                          @"idfv"           :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfv,
                          @"sdk_version"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"username"       :   userName,
                          @"password"       :   password,
                          };
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    NSString *paramStr = @"ct=index&ac=login";
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SS_URL_Head, paramStr];
    SYLog(@"登录------params:%@-----", params);
    [self getSGAVMPWithParamStr:paramStr param:params];

//    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].wtoken = wToken;

    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"登录-------success--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
//            SYLog(@"dic-------- %@",dic);
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].fastUserName = userName;
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].loginUser = userName;
//            [weakSelf saveWithUsername:userName password:password];
            
     
   //         NSString *str = dic[@"h5_game_url"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken = dic[@"token"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].gameCode =dic[@"code"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].requestUrl = dic[@"h5_game_url"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl = dic[@"o"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].userId = dic[@"user_id"];
            [UserSafetyTool saveWithUsername:userName password:password token:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken];

            [SS_PublicTool firstOpenApplication:YES];
            [weakSelf getUserBasicInfoCompletion:^(BOOL isSuccess, id respones) {
                if (isSuccess) {
                    SYLog(@"%@", respones);
                    NSDictionary *dict = respones[@"data"];
                    NSString *phoneNumber = dict[@"phone"];
                    if (phoneNumber.length > 1) {
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = YES;
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindPhoneNumber = phoneNumber;
                    }else{
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = NO;
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindPhoneNumber = @"";
                    }
                    SYLog(@"[SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = %d", [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone);
                    
                    
                    if (completion) {
                        completion(YES, originalDic);
                    }
                    
                }else{
                    SYLog(@"%@", respones);
                    if (completion) {
                        completion(NO, originalDic);
                    }
                    
                }
            } failure:^(NSError *error) {
                if (failure) {
                    failure(error);
                }
            }];
  
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];

}

- (void)checkIfTheUserExistsWithUserName:(NSString *)userName userType:(NSInteger)userType completion:(void (^ _Nullable)(BOOL, id _Nullable))completion failure:(void (^ _Nullable)(NSError * _Nullable))failure{
    NSString *user_type = [NSString stringWithFormat:@"%ld", (long)userType];
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"platform"    : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].platform,
                          @"device_id"   : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid,
                          @"username"    : userName,
                          @"user_type"   : user_type,
                          };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    SYLog(@"账号是否存在------params:%@-----", params);
    NSString *paramStr = @"ct=index&ac=checkUsername";
    [self getResponseWithUrl:paramStr parameters:params medthod:@"账号是否存在" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (([SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl.length > 0) || ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].gameCode.length > 0)){
                //  [weakSelf createFloatWindow];
                
            }
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)noticeBeforTheLoginCompletion:(void(^)(BOOL isSuccess, id respones))completion failure:(void(^)(NSError * error))failure{
    
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"device_id"   : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid,
                          @"token"       : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken,
                          @"type"        : @"sdk",
                          };

    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    SYLog(@"是否有登录后公告------params:%@-----", params);
    NSString *paramStr = @"ct=notice&ac=getHotNewGameNoticeList";
    
    [self getResponseWithUrl:paramStr parameters:params medthod:@"登录后公告" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (([SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl.length > 0) || ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].gameCode.length > 0)){
                //  [weakSelf createFloatWindow];
                
            }
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}



- (void)verifyDynamicPasswordWithKey:(NSString *)key completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"app_id"      : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                          @"device_id"   : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid,
                          @"token"       : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken,
                          @"key"         : key,
                          };
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    SYLog(@"验证动态口令------params:%@-----", params);
    NSString *paramStr = @"ct=index&ac=verifyDynamicPassword";
    
    [self getResponseWithUrl:paramStr parameters:params medthod:@"验证动态口令" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].isAppStatus) {
                [[SY_FloatWindowTool sharedSY_FloatWindowTool] createFloatWindow];
            }
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


//检查是否有登录公告
- (void)checkLoginNoticeCompletion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"app_id"      : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                          @"device_id"   : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid,
                          };
    
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=notice&ac=checkLoginNotice";
//    [self getSGAVMPWithParamStr:paramStr param:params];
    SYLog(@"是否有登录公告------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"是否有登录公告" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}




- (void)shareTheGameGiftInfoCompletion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"device_id"   : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid,
                          @"token"       : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken,
                          };
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=share&ac=getShareInfo";

    [self getResponseWithUrl:paramStr parameters:params medthod:@"请求分享内容" completion:^(BOOL isSuccess, id responesObj) {
        if (completion) {
            completion(isSuccess, responesObj);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


- (void)checkExpiredForToken:(NSString *)token userName:(NSString *)userName completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    Weak_Self;
    NSDictionary *paramterDict = @{
                          @"device_id"      :   [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] getUUID],
                          @"app_id"         :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                          @"app_channel"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].app_channel,
                          @"system_name"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model,
                          @"system_version" :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].system_Version,
                          @"platform"       :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].platform,//,
                          @"time"           :   [SS_PublicTool getTimeStamps],
                          @"idfa"           :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfa,
                          @"idfv"           :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfv,
                          @"sdk_version"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"username"       :   userName,
                          @"token"          :   token,
                          };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=index&ac=checkToken";
    
    SYLog(@"token是否过期 ------params:%@-----", params);
    [self getSGAVMPWithParamStr:paramStr param:params];
    
    //    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].wtoken = wToken;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SS_URL_Head, paramStr];
    
    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"登录-------success--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
            //            SYLog(@"dic-------- %@",dic);
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].fastUserName = dic[@"username"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].loginUser = dic[@"username"];
            //            [weakSelf saveWithUsername:userName password:password];
            
            
            //         NSString *str = dic[@"h5_game_url"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken = dic[@"token"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].gameCode = dic[@"code"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].requestUrl = dic[@"h5_game_url"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl = dic[@"o"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].userId = dic[@"user_id"];
            if ([SS_PublicTool isValidateTel:dic[@"username"]]) {
                NSMutableDictionary *passD = [KeyChainWrapper load:SSPasswordKey];
                NSString *password = [passD valueForKey:dic[@"username"]];
                [UserSafetyTool saveWithUsername:dic[@"username"] password:password token:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken];
            }
            [SS_PublicTool firstOpenApplication:YES];
            
            [weakSelf getUserBasicInfoCompletion:^(BOOL isSuccess, id respones) {
                if (isSuccess) {
                    SYLog(@"%@", respones);
                    NSDictionary *dict = respones[@"data"];
                    NSString *phoneNumber = dict[@"phone"];
                    if (phoneNumber.length > 1) {
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = YES;
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindPhoneNumber = phoneNumber;
                    }else{
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = NO;
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindPhoneNumber = @"";
                    }
                    SYLog(@"[SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = %d", [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone);
                    if (completion) {
                        completion(YES, originalDic);
                    }
                }else{
                    SYLog(@"%@", respones);
                    if (completion) {
                        completion(NO, originalDic);
                    }
                }
            } failure:^(NSError *error) {
                
            }];
            
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

- (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code completion:(void (^)(BOOL, id _Nullable, NSString *_Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    Weak_Self;
    
    NSDictionary *paramterDict = @{
                          @"device_id"      :   [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] getUUID],
                          @"app_id"         :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                          @"app_channel"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].app_channel,
                          @"system_name"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model,
                          @"system_version" :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].system_Version,
                          @"platform"       :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].platform,//,
                          @"time"           :   [SS_PublicTool getTimeStamps],
                          @"idfa"           :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfa,
                          @"idfv"           :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfv,
                          @"sdk_version"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"phone"          :   phoneNumber,
                          @"code"           :   code,
                          };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=index&ac=phoneLogin";
    
    SYLog(@"token 失效, 使用验证码登录 ------params:%@-----", params);
    [self getSGAVMPWithParamStr:paramStr param:params];
    
    //    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].wtoken = wToken;
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SS_URL_Head, paramStr];

    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"登录-------success--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
            //            SYLog(@"dic-------- %@",dic);
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].fastUserName = dic[@"username"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].loginUser = dic[@"username"];
            //            [weakSelf saveWithUsername:userName password:password];
            
            
            //         NSString *str = dic[@"h5_game_url"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken = dic[@"token"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].gameCode = dic[@"code"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].requestUrl = dic[@"h5_game_url"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].syUrl = dic[@"o"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].userId = dic[@"user_id"];
            if ([SS_PublicTool isValidateTel:dic[@"username"]]) {
                NSMutableDictionary *passD = [KeyChainWrapper load:SSPasswordKey];
                NSString *password = [passD valueForKey:dic[@"username"]];
                [UserSafetyTool saveWithUsername:dic[@"username"] password:password token:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken];
            }
            [SS_PublicTool firstOpenApplication:YES];
            
            [weakSelf getUserBasicInfoCompletion:^(BOOL isSuccess, id respones) {
                if (isSuccess) {
                    SYLog(@"%@", respones);
                    NSDictionary *dict = respones[@"data"];
                    NSString *phoneNumber = dict[@"phone"];
                    if (phoneNumber.length > 1) {
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = YES;
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindPhoneNumber = phoneNumber;
                    }else{
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = NO;
                        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindPhoneNumber = @"";
                    }
                    SYLog(@"[SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone = %d", [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindPhone);
                    if (completion) {
                        completion(YES, originalDic, @"");
                    }
                }else{
                    SYLog(@"%@", respones);
                    if (completion) {
                        completion(NO, originalDic, @"");
                    }
                }
            } failure:^(NSError *error) {
                
            }];
            
        }else{
            if (completion) {
                completion(NO, originalDic, @"");
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(NO, error, @"网络异常");
        }
        
    }];

}

- (void)checkGameNoticeCompletion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"app_id"      : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                          @"device_id"   : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid,
                          @"token"       : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken,
                          };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=notice&ac=checkUserGameNotice";

    SYLog(@"是否有未读游戏公告 ------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"是否有未读游戏公告" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}





//绑定手机号码
- (void)bindMobileWithToken:(NSString *)tokenStr code:(NSString *)code phoneNumber:(NSString *)phoneNum completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"phone"       : phoneNum,//phoneNum
                          @"token"       : tokenStr,
                          @"code"        : code,
                          };

    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=user&ac=bindPhone";

    SYLog(@"绑定手机号码------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"绑定手机号码" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    

}



- (void)getUserBasicInfoCompletion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"token"       : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken,
                          };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=user&ac=getUserInfo";

    SYLog(@"获取用户基本信息-------params:%@", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"获取用户基本信息" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            
            NSDictionary *dict = responesObj[@"data"];
            NSString *identityCardString = dict[@"idcard"];
            if (identityCardString.length < 7) {
                [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindingIdCard = NO;
            }else{
                [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindingIdCard = YES;
            }
            
            
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}


//通过老密码修改新密码
- (void)modifyPasswordWithToken:(NSString *)tokenStr oldPassword:(NSString *)oldPassword password:(NSString *)password repasswrod:(NSString *)repassword completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    NSDictionary *paramterDict = @{
                          @"token"              :           tokenStr,
                          @"old_password"       :           oldPassword,
                          @"password"           :           password,
                          @"repassword"         :           repassword,
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],

                          };
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    SYLog(@"通过老密码修改新密码-------params:%@", params);
    
    NSString *paramStr = @"ct=user&ac=editPwdByOldPassword";

    [self getResponseWithUrl:paramStr parameters:params medthod:@"老密码修改新密码" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}




//绑定手机验证码
- (void)bindPhoneSmsWithPhoneNumber:(NSString *)phoneNum completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"phone"       : phoneNum,//phoneNum
                          @"type"        : @"bind_phone",
                          };
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=index&ac=sms";

    SYLog(@"绑定手机验证码------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"绑定手机验证码" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


//注册手机账号验证码
- (void)loginForPhoneSmsWithPhoneNumber:(NSString *)phoneNum completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"phone"       : phoneNum,//phoneNum
                          @"type"        : @"phone_login",
                          };
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=index&ac=sms";
    
    SYLog(@"绑定手机验证码------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"绑定手机验证码" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

// 短信验证码
- (void)getFindPasswordSmsWithPhoneNumber:(NSString *)phoneNum completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"phone"       : phoneNum,//phoneNum
                          };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=index&ac=sendEditPwdSms";

    SYLog(@"短信验证码------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"短信验证" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
            }

        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

//检测短信验证码和手机号码...手机找回密码
- (void)checkSmsWithPhone:(NSString *)phoneNum code:(NSString *)code completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"phone"       : phoneNum,//phoneNum
                          @"code"        : code,
                          };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=index&ac=checkSms";

    SYLog(@"手机找回密码------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"验证短信和手机号码_手机找回密码" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//通过手机修改密码
- (void)changePassword:(NSString *)password phoneNum:(NSString *)phoneNum code:(NSString *)code completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"phone"       : phoneNum,//phoneNum
                          @"code"        : code,
                          @"password"    : password,
                          };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=index&ac=editPwd";

    SYLog(@"通过手机修改密码------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"手机修改密码" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

    
}

/*
 验证身份证
 */
- (void)verifyIdcardWithName:(NSString *)name idCard:(NSString *)idCard completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    NSDictionary *paramterDict = @{
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"        : [SS_PublicTool getTimeStamps],
                          @"token"       : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken,
                          @"device_id"   : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid,
                          @"name"        : name,
                          @"idcard"      : idCard,
                          };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    
    NSString *paramStr = @"ct=user&ac=verifyIdcard";
    
    SYLog(@"验证身份证------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"验证身份证" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

- (void)clearDeviceIdWithAppId:(NSString *)appId completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    NSDictionary *param = @{
                             @"app_id"      : appId,
                             @"device_id"   : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid,
                             };
    
    NSString *signStr = [SS_PublicTool makeSignStringWithParams:param];
    SYLog(@"---sign:%@", signStr);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:signStr forKey:@"sign"];
    
    
    NSString *paramStr = @"ct=sys&ac=clearDevice";
    SYLog(@"------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"清理deviceID" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

    
    
}




//获取基本数据 -> 主要用于切换中英文界面.
- (void)getInfoWithAppId:(NSString *)appId completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    //944A19D5514A4AC28BAA412133FBBCF9
    
    NSDictionary *params = @{
                          @"app_id"      : appId,
                          @"device_id"   : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid,
                          @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"platform"   :  @"ios",
                          };
    
   
    NSString *paramStr = @"ct=sys&ac=getInfo";

    SYLog(@"------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"基础数据" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    

    
}


//用户创建角色
- (void)userCreateRoleWithRoleId:(NSString *)roleId userId:(NSString *)userId htmlSign:(NSString *)htmlSign time:(NSString *)time completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    if (htmlSign.length < 1) {
        htmlSign = @"";
    }
    NSDictionary *param = @{
                            @"app_id"          : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                            @"app_channel"     : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].app_channel,
                            @"platform"        : @"ios",
                            @"time"            : time,
                            @"role_id"         : roleId,
                            @"game_sign"       : htmlSign,
                            @"user_id"         : userId,
                            };
    
    
    NSString *signStr = [SS_PublicTool makeSignStringWithParams:param];
    SYLog(@"---sign:%@", signStr);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:signStr forKey:@"sign"];
    
    NSString *paramStr = @"ct=index&ac=createRole";
     SYLog(@"用户创建角色------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"创建角色" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    

    
    
}

// 游戏角色在线5分钟
- (void)onlineFor5MinutesWithUserId:(NSString *)userId roleId:(NSString *)roleId time:(NSString *)time htmlSign:(NSString *)htmlSign completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    if (htmlSign.length < 1) {
        htmlSign = @"";
    }
    NSDictionary *param = @{
                            @"app_id"          : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                            @"app_channel"     : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].app_channel ,
                            @"platform"        : @"ios",
                            @"time"            : time,
                            @"role_id"         : roleId,
                            @"game_sign"       : htmlSign,
                            @"user_id"         : userId,
                            };
    
    NSString *signStr = [SS_PublicTool makeSignStringWithParams:param];
    SYLog(@"---sign:%@", signStr);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:signStr forKey:@"sign"];
    
    NSString *paramStr = @"ct=index&ac=roleOnline";
    SYLog(@"游戏角色在线5分钟------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"在线5分钟" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

    
}

//升级调用接口
- (void)levelUpWithUserId:(NSString *)userId roleId:(NSString *)roleId level:(NSString *)level time:(NSString *)time htmlSign:(NSString *)htmlSign completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    if (htmlSign.length < 1) {
        htmlSign = @"";
    }
    NSDictionary *param = @{
                            @"app_id"          : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                            @"platform"        : @"ios",
                            @"time"            : time,
                            @"role_id"         : roleId,
                            @"user_id"         : userId,
                            @"level"           : level,
                            @"game_sign"       : htmlSign,
                            };
    NSString *signStr = [SS_PublicTool makeSignStringWithParams:param];
    SYLog(@"---sign:%@", signStr);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:signStr forKey:@"sign"];
    
    NSString *paramStr = @"ct=index&ac=roleLevel";
    SYLog(@"升级调用接口------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"升级接口" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}


- (void)userServerLoginWithUserId:(NSString *)userId serverId:(NSString *)serverId loginTime:(NSString *)loginTime time:(NSString *)time gameSign:(NSString *)gameSign completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    if (gameSign.length < 1) {
        gameSign = @"";
    }
    if (time.length < 1) {
        time = @"";
    }
    
    NSDictionary *paramterDict = @{
                                   @"app_id"               : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                                   @"platform"             : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].platform,
                                   @"time"                 : time,
                                   @"server_id"            : serverId,
                                   @"login_time"           : loginTime,
                                   @"user_id"              : userId,
                                   @"game_sign"            : gameSign,
                                   };
    
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];
    NSString *paramStr = @"ct=index&ac=serverLogin";
    SYLog(@"用户登入区服调用接口------params:%@-----", params);
    [self getResponseWithUrl:paramStr parameters:params medthod:@"用户登入区服" completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    }failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}





- (void)checkWebSYSignWithParams:(NSDictionary *)params completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
//    NSString *signStr = [SS_PublicTool makeSignStringWithParams:param];
//    SYLog(@"---sign:%@", signStr);
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
//    [params setObject:signStr forKey:@"sign"];
    
    NSString *paramStr = @"ct=index&ac=checkWebPaySign";
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SS_SYUrl, paramStr];
    SYLog(@"验证游戏参数------params:%@-----", params);
    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"----success--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            //            NSDictionary *dic = originalDic[@"data"];
            //            SYLog(@"dic-------- %@",dic);
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SYLog(@"error: %@", error);
        if (failure) {
            failure(error);
        }
        
    }];
}


/*
 * 临时多一层封装
 */
- (void)getDataForResponseWithUrl:(NSString *)paramStr parameters:(id)params medthod:(NSString *)medthod completion:(void(^)(BOOL isSuccess, id responesObj))completion failure:(void(^)(NSError * error))failure{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SS_URL_Head, paramStr];
//    [self getSGAVMPWithParamStr:paramStr param:params];
    
    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        SYLog(@"%@", _manager.requestSerializer.stringEncoding);
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"%@----success--------------originalDic-------- %@------------message:%@", medthod,originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            //            NSDictionary *dic = originalDic[@"data"];
            //            SYLog(@"dic-------- %@",dic);
//            _manager.
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
    

    
}


- (void)testInfoToAnyParamCompletion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    NSDictionary *param = @{
                             @"username" :  @"king5566",
                             @"password" :  @"qweqwe123",
                            };
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@", SS_COM_Test];
    NSString *sign = [SS_PublicTool makeSignStringWithParams:param key:SS_BBS_KEY];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:sign forKey:@"sdk_code"];
    SYLog(@"登录------params:%@-----", params);
    [_manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"%@----success--------------originalDic-------- %@------------message:%@", @"测试社区模块",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"success"] intValue] == 1) {
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];

    
}


//公共请求方法..
- (void)getResponseWithUrl:(NSString *)paramStr parameters:(id)params medthod:(NSString *)medthod completion:(void(^)(BOOL isSuccess, id responesObj))completion failure:(void(^)(NSError * error))failure{
//    Weak_Self;
    [self getDataForResponseWithUrl:paramStr parameters:params medthod:medthod completion:^(BOOL isSuccess, id responesObj) {
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



- (void)checkSongyorkWithSongyorkInfo:(SongyorkInfo *_Nullable)songyorkInfo completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure{
    
    NSDictionary *paramterDict = @{
                          @"user_id"         :   songyorkInfo.uid,
                          @"game_role_level" :   songyorkInfo.roleLevel,
                          @"platform"        :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].platform,
                          @"app_id"          :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                          @"sdk_version"     :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"            :   [SS_PublicTool getTimeStamps],
                          };
    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    SYLog(@"------params:%@-----", params);
    NSString *urlString = [NSString stringWithFormat:@"%@ct=index&ac=check", SS_SYUrl];
    [_manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"----success--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            //            NSDictionary *dic = originalDic[@"data"];
            //            SYLog(@"dic-------- %@",dic);
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        SYLog(@"error: %@", error);
        if (failure) {
            failure(error);
        }
        
    }];
//    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].isAppStatus) {
//        [[NetworkTool sharedNetworkTool] createFloatWindow];
//    }
}

/**
 * 请求支付
 */

- (void)requestSongyorkWithInfo:(SongyorkInfo *_Nullable)songyorkInfo completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure{
    
    
    NSDictionary *paramterDict = @{
                          @"user_id"        :   songyorkInfo.uid,
                          @"money"          :   songyorkInfo.money,
                          @"money_type"     :   songyorkInfo.moneyType,
                          @"server"         :   songyorkInfo.serverId,
                          @"cp_trade_sn"    :   songyorkInfo.YYY,
                          @"goods_id"       :   songyorkInfo.proId,
                          @"goods_name"     :   songyorkInfo.productName,
                          @"game_role_id"   :   songyorkInfo.roleId,
                          @"game_role_name" :   songyorkInfo.roleName,
                          @"pay_type"       :   @"apple",
                          @"sub_pay_type"   :   @"apple",
                          @"app_channel"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].app_channel,
                          @"device_id"      :   [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] getUUID],
                          @"app_id"         :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                          @"idfv"           :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfv,
                          @"sdk_version"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"time"           :   [SS_PublicTool getTimeStamps],
                          };


    NSDictionary *params = [SS_PublicTool signKeyMustStringFromDictionary:paramterDict];

    SYLog(@"------params:%@-----", params);

    
    [_manager POST:SS_SYUrl_Head parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"----success--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"state"] intValue] == 1) {
            //            NSDictionary *dic = originalDic[@"data"];
            //            SYLog(@"dic-------- %@",dic);
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
        
    }];
    /*
    [self getResponseWithUrl:SS_SYUrl_Head parameters:params medthod:@"请求支付" completion:^(BOOL isSuccess, id responesObj) {
       
        if (isSuccess) {
            if (completion) {
                completion(YES, responesObj);
            }
        }else{
            if (completion) {
                completion(NO, responesObj);
                
            }
            
        }
     

    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
*/
    
}

/**
 * 检查是否有weifukuan的回调
 */
- (void)checkSYToServerWithReceiptInfo:(id)params completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    NSDictionary *dic = params;
    
//    NSString *deletSign = [NSString stringWithFormat:@"%@", dic[@"sign"]];
//    if (deletSign.length > 1) {
//        [dic removeObjectForKey:@"sign"];
//    }
    SYLog(@"检查支付--------------------Param:%@", dic);

    SYLog(@"------params:%@-----", params);


    [_manager POST:SS_SYUrl_CallBack parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"检查支付--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"status"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
            SYLog(@"dic-------- %@",dic);
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
}


/**
 * 支付完成的回调
 */

- (void)callBackToSongyorkServerWithReceiptInfo:(id)params completion:(void (^)(BOOL, id _Nullable))completion failure:(void (^)(NSError * _Nullable))failure{
    
    

//    [self getSGAVMPWithParamStr:@"" param:param];

    [_manager POST:SS_SYUrl_CallBack parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *originalDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SYLog(@"支付完成------success--------------originalDic-------- %@------------message:%@",originalDic, originalDic[@"msg"]);
        if ([originalDic[@"status"] intValue] == 1) {
            NSDictionary *dic = originalDic[@"data"];
            SYLog(@"dic-------- %@",dic);
            if (completion) {
                completion(YES, originalDic);
            }
        }else{
            if (completion) {
                completion(NO, originalDic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];

}


#pragma mark ----------------------------------------------保存账号信息
//*** 登录或者注册成功后保存账号、密码，最多保存5个
-(void)saveWithUsername:(NSString *)username password:(NSString *)password{
    if ([KeyChainWrapper load:SSUsernameKey] == nil) {
        NSMutableArray *userNameArray = [NSMutableArray array];
        [userNameArray insertObject:username atIndex:0];
        [KeyChainWrapper save:SSUsernameKey data:userNameArray];
    }else{
        NSMutableArray *userNameArr = [KeyChainWrapper load:SSUsernameKey];
        if ([userNameArr containsObject:username]) {
//            NSMutableDictionary *haveUserDict = [KeyChainWrapper load:SSPasswordKey];
//            [haveUserDict removeObjectForKey:username];
//            [KeyChainWrapper save:SSPasswordKey data:haveUserDict];

            [userNameArr removeObject:username];
            [userNameArr insertObject:username atIndex:0];
            [KeyChainWrapper save:SSUsernameKey data:userNameArr];

        }else{
            if (userNameArr.count == 5) {
                NSMutableDictionary *userDict = [KeyChainWrapper load:SSPasswordKey];
                [userDict removeObjectForKey:userNameArr[4]];
                [KeyChainWrapper save:SSPasswordKey data:userDict];
                
                [userNameArr removeObjectAtIndex:4];
                [userNameArr insertObject:username atIndex:0];
                [KeyChainWrapper save:SSUsernameKey data:userNameArr];
            }else{
                [userNameArr insertObject:username atIndex:0];
                [KeyChainWrapper save:SSUsernameKey data:userNameArr];
            }
        }
    }
    //*** 、字典保存账号、密码，最多5个
    if ([KeyChainWrapper load:SSPasswordKey] == nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:password forKey:username];
        [KeyChainWrapper save:SSPasswordKey data:dict];
    }else{
        NSMutableDictionary *userDict = [KeyChainWrapper load:SSPasswordKey];
        if ([userDict objectForKey:username]) {
            if (![password isEqualToString:[userDict objectForKey:username]]) {
                [userDict setObject:password forKey:username];
                [KeyChainWrapper save:SSPasswordKey data:userDict];
            }
            
        }else{
            [userDict setObject:password forKey:username];
            [KeyChainWrapper save:SSPasswordKey data:userDict];
        }
    }
}

//创建HTLM游戏页面
- (void)creatHtmlGameWithUrl:(NSString *)openuUrl zUrl:(NSString *)zUrl{
//    Weak_Self;
    self.htmlWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    self.htmlWindow.backgroundColor = SYWhiteColor;
    SS_GameToHtmlViewController *h5 = [[SS_GameToHtmlViewController alloc] init];
    h5.requestURL = openuUrl;
    h5.zUrl = zUrl;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:h5];
    nav.navigationBar.hidden = YES;

    self.htmlWindow.rootViewController = nav;

    [self.htmlWindow makeKeyAndVisible];
}

/**
 * 接收通知的响应事件方法
 */
- (void)signOutGame:(NSNotification *)notification{
    BOOL isOut = [[notification.userInfo valueForKey:notification.object] boolValue];
    
    if (isOut) {
        if (self.htmlWindow) {
            self.htmlWindow.hidden = YES;
            self.htmlWindow = nil;
            [self destroyFloatWindow];
        }
    }
}


//创建悬浮窗
- (void)createFloatWindow{
    Weak_Self;//

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(),^{


        /*
         * [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isAppStatus
         * 判断是否上线
         */
//        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isAppStatus = YES;
//        if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].isAppStatus) {
        
//    }
        if (self.change_floatWindow) {
            return ;
        }
        if ([[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5S"] || [[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5C"] || [[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5"]){
            weakSelf.change_floatWindow = [[SS_FloatWindow alloc] initWithFrame:CGRectMake(30, 30, 60, 60) mainImageName:@"xf_tb" titleArr:@[@"tb_zh",@"tb_lb",@"tb_kf", @"tb_gg", @"tb_back"] startBtnTag:100 animationColor:[UIColor clearColor]];
        }else{
            weakSelf.change_floatWindow = [[SS_FloatWindow alloc] initWithFrame:CGRectMake(30, 30, 60, 60) mainImageName:@"xf_tb" titleArr:@[@"tb_zh",@"tb_lb",@"tb_kf", @"tb_gg", @"ling", @"tb_back"] startBtnTag:100 animationColor:[UIColor clearColor]];
        }

        weakSelf.change_floatWindow.hidden = NO;

            //*** 点击悬浮窗按钮
            weakSelf.change_floatWindow.backBlock = ^(NSInteger tag){
                if (tag == 100) {
                    //*** 账号
                    if (weakSelf.userManagerW == nil) {
                        SYLog(@"========账号");

                        

                        weakSelf.uVC = [[SS_UserManagerController alloc] init];
                        weakSelf.userManagerNav = [[SS_UserManagerNavController alloc] initWithRootViewController:weakSelf.uVC];
//                        [SS_PublicTool stopSystemPopGestureRecognizerForNavigationController:weakSelf.userManagerNav];
//                        [weakSelf.change_floatWindow.rootViewController presentViewController:weakSelf.userManagerNav animated:YES completion:^{
//                            [weakSelf destroyFloatWindow];
//                        }];

                        
                        weakSelf.userManagerW = [[SS_UserManager alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                        weakSelf.userManagerW.UserBlock = ^{
                            weakSelf.userManagerW.hidden = YES;
                            weakSelf.userManagerW = nil;
                        };
                        [weakSelf.userManagerW makeKeyAndVisible];
//                        UIWindow *window = [[UIApplication sharedApplication].delegate window];
//                        if (window != nil && window.rootViewController != nil)
//                        {
//                            [window addSubview:weakSelf.userManagerW];
//                            [window makeKeyAndVisible];
//                        }
                    }
                }else if (tag == 101){
                    //*** 礼包
                    SYLog(@"========礼包");

                    /*
                    
                    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:nil message:@"暂未开放,敬请期待" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf createFloatWindow];
                    }];
                    
                    [alerController addAction:cancel];
                    UIViewController *viewController = [SS_PublicTool getKeyWindowRootVcr];
                    [viewController presentViewController:alerController animated:YES completion:nil];
                    */
                    
                    
                    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].selectedIndex = 1;
                    
//                    SS_PersonTabBarController *tabBarC = [[SS_PersonTabBarController alloc] init];
//                    tabBarC.changeBind = NO;
//                    [weakSelf.change_floatWindow.rootViewController presentViewController:tabBarC animated:YES completion:^{
//                        [weakSelf destroyFloatWindow];
//                    }];
                    
                     if (weakSelf.personCenterW == nil) {
                         if (weakSelf.userManagerW) {
                             weakSelf.userManagerW.hidden = YES;
                             weakSelf.userManagerW = nil;
                             [weakSelf destroyFloatWindow];
                         }else{
                             [weakSelf destroyFloatWindow];
                         }
                     weakSelf.personCenterW = [[SS_PersonCenterWindow alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, Screen_Height) rootViewControllerIndex:1 isChangeBindPhone:NO];
                     weakSelf.personCenterW.TabBarBlock = ^{
                         [UIView animateWithDuration:0.3 animations:^{
                         weakSelf.personCenterW.frame = CGRectMake(0, Screen_Height, Screen_Width, Screen_Height);
                         } completion:^(BOOL finished) {
                         weakSelf.personCenterW.alpha = 0;
                         weakSelf.personCenterW = nil;
                         [weakSelf createFloatWindow];
                         }];   
                     };
                     
                     [weakSelf.personCenterW makeKeyAndVisible];
                     [UIView animateWithDuration:0.3 animations:^{
                     weakSelf.personCenterW.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
                     }];
                     
//                     [weakSelf destroyFloatWindow];
                     }
                    
                    
                    
                }else if (tag == 102){
                    //*** 客服
                    SYLog(@"========客服");

                    
                    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].selectedIndex = 2; 
//                    SS_PersonTabBarController *tabBarC = [[SS_PersonTabBarController alloc] init];
//
//
//                    tabBarC.changeBind = NO;
//                    [weakSelf.change_floatWindow.rootViewController presentViewController:tabBarC animated:YES completion:^{
//                        [weakSelf destroyFloatWindow];
//                    }];
                     if (weakSelf.personCenterW == nil) {
                         if (weakSelf.userManagerW) {
                             weakSelf.userManagerW.hidden = YES;
                             weakSelf.userManagerW = nil;
                             [weakSelf destroyFloatWindow];
                         }else{
                             [weakSelf destroyFloatWindow];
                         }
                     weakSelf.personCenterW = [[SS_PersonCenterWindow alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, Screen_Height) rootViewControllerIndex:2 isChangeBindPhone:NO];
                     weakSelf.personCenterW.TabBarBlock = ^{
                         [UIView animateWithDuration:0.3 animations:^{
                             weakSelf.personCenterW.frame = CGRectMake(0, Screen_Height, Screen_Width, Screen_Height);
                         } completion:^(BOOL finished) {
                             weakSelf.personCenterW.alpha = 0;
                             weakSelf.personCenterW = nil;
                             [weakSelf createFloatWindow];
                         }];
                     };
                     [weakSelf.personCenterW makeKeyAndVisible];
                     [UIView animateWithDuration:0.3 animations:^{
                         weakSelf.personCenterW.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
                     }];
//                     [weakSelf destroyFloatWindow];
                     }
                    
                    /*
                    if (weakSelf.kefuWindow == nil) {
                        weakSelf.kefuWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                        weakSelf.kefuWindow.backgroundColor = [UIColor clearColor];
                        KeFuViewController *kfVC = [[KeFuViewController alloc] init];
                        kfVC.BackBlock = ^{
                            weakSelf.kefuWindow = nil;
                            weakSelf.kefuWindow.hidden = YES;
                        };
                        weakSelf.kefuWindow.rootViewController = kfVC;
                        [weakSelf.kefuWindow makeKeyAndVisible];
                    }
                    */
                    
                }else if (tag == 103){
                    SYLog(@"公告");

                    
                    SS_WebTipSController *webTips = [[SS_WebTipSController alloc] init];
                    
//                    weakSelf.userManagerNav = [[UserManagerNavController alloc] initWithRootViewController:webTips];
//                    [weakSelf.change_floatWindow.rootViewController presentViewController:weakSelf.userManagerNav animated:YES completion:^{
//                        [weakSelf destroyFloatWindow];
//                    }];
                    
                    
                    if (weakSelf.tipsWebWindow == nil) {
                        if (weakSelf.userManagerW) {
                            weakSelf.userManagerW.hidden = YES;
                            weakSelf.userManagerW = nil;
                            [weakSelf destroyFloatWindow];
                        }else{
                            [weakSelf destroyFloatWindow];
                        }
                        weakSelf.tipsWebWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, Screen_Height)];
                        SS_WebTipSController *webTips = [[SS_WebTipSController alloc] init];

                        weakSelf.userManagerNav = [[SS_UserManagerNavController alloc] initWithRootViewController:webTips];
                        webTips.GoBackBlock = ^{
                            [UIView animateWithDuration:0.3 animations:^{
                                weakSelf.tipsWebWindow.frame = CGRectMake(0, Screen_Height, Screen_Width, Screen_Height);
                            } completion:^(BOOL finished) {
                                weakSelf.tipsWebWindow.alpha = 0;
                                weakSelf.tipsWebWindow = nil;
                                [weakSelf createFloatWindow];
                            }];
                           
                        };
                        weakSelf.tipsWebWindow.rootViewController = weakSelf.userManagerNav;
                        [weakSelf.tipsWebWindow makeKeyAndVisible];
                        [UIView animateWithDuration:0.3 animations:^{
                            weakSelf.tipsWebWindow.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
                        }];
                        //                     [weakSelf destroyFloatWindow];
                    }
                    

                }else if (tag == 104){
                    if ([[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5S"] || [[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5C"] || [[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5"]){
                        SYLog(@"返回");

                    }else{
                        NSURL *storeURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id1314361976?mt=8"];
                        
                        if ([[UIApplication sharedApplication] canOpenURL:storeURL]){
                            [[UIApplication sharedApplication] openURL:storeURL options:@{} completionHandler:^(BOOL success) {
                                if (success) {
                                    SYLog(@"1111111111111");
                                }
                            }];
                        }
                    }

                }else if (tag == 105){
                    SYLog(@"返回");

                }
        

        
            };
    });
}


/**
 * 改绑手机
 */
- (void)changeBindMobilPhone{
    Weak_Self;
    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].selectedIndex = 3;

    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].changeBind = YES;

//    SS_PersonTabBarController *tabBarC = [[SS_PersonTabBarController alloc] init];

    
//    SS_PersonTabBarController *tabBarC = [[SS_PersonTabBarController alloc] init];
//    self.change_floatWindow = [[SS_FloatWindow alloc] initWithFrame:CGRectMake(0, 0, 0, 0) mainImageName:nil titleArr:nil startBtnTag:100 animationColor:SYNOColor];
//    self.change_floatWindow.alpha = 0.0;
//    self.change_floatWindow.hidden = YES;
//    [self.change_floatWindow.rootViewController presentViewController:tabBarC animated:YES completion:^{
//        [weakSelf.uVC dismissViewControllerAnimated:YES completion:^{
//            [weakSelf destroyFloatWindow];
//        }];
//    }];
    
    
    if (self.personCenterW == nil) {
        
       
         if (self.userManagerW) {
         self.userManagerW.hidden = YES;
         self.userManagerW = nil;
         [self destroyFloatWindow];
         }else{
         [self destroyFloatWindow];
         }
         
        self.personCenterW = [[SS_PersonCenterWindow alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) rootViewControllerIndex:3 isChangeBindPhone:YES];
        self.personCenterW.TabBarBlock = ^{
            weakSelf.personCenterW.alpha = 0;
            weakSelf.personCenterW = nil;
            [weakSelf createFloatWindow];
        };
         [self.personCenterW makeKeyAndVisible];
    }

       
}




// 销毁悬浮窗
-(void)destroyFloatWindow{
    [self.change_floatWindow stopTiming];
    self.change_floatWindow.hidden = YES;
    self.change_floatWindow.alpha = 0;
    self.change_floatWindow = nil;
   
}



@end
