//
//  NetworkTool.h
//  AYSDK
//
//  Created by SDK on 2017/7/25.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYSYSingleton.h"

/**
 * 四个基础请求参数
 *param @"sdk_version" : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkVer,
 *
 *param @"time"        : [PublicTool getTimeStamps],
 *
 *param @"device_id"   : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid,
 *
 *param @"token"       : [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken,
 *
 */



@class SongyorkInfo;

typedef NS_ENUM(NSInteger, RegistType) {
    RegistTypeName             = 0, //用户名
    RegistTypePhone            = 1, // 手机号
    
};


@interface SS_SDKNetworkTool : NSObject

SYSingletonH(SS_SDKNetworkTool)

#pragma mark --- 1、初始化属性_manager
-(void)getManagerBySingleton;

#pragma mark --- 2、点击切换账号调用方法:1、关闭悬浮窗；2、调用登录接口
//- (void)switchBtnClick;


/*获取网络状态*/
- (void)getNetWorkStateBlock:(void(^_Nullable)(NSInteger netStatus))statusBlock;

#pragma mark --- 5、删除保存的账号密码
//- (void)deleteUserInfoWithIndex:(NSUInteger)index;


#pragma mark ---------------网络请求------------
#pragma mark -------------激活
/**
 激活
 
 @param completion block
 */
- (void)getUserActivateCompletion:(void(^_Nullable)(BOOL isActivate, id _Nullable response)) completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;


/**
 获取客服html接口
 
 @param completion Finished block
 */
- (void)getCustomerServiceCompletion:(void(^_Nullable)(BOOL isSuccess, id _Nullable response))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;


/**
 获取游戏基本信息
 
 @param completion Finished block
 @param failure Error block
 */
- (void)getGameInfoCompletion:(void(^_Nullable)(BOOL isSuccess, id _Nullable response)) completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;


/**
 获取正则表达式
 
 @param completion Finished block
 @param failure Error block
 */
- (void)getRegexpCompletion:(void(^_Nullable)(BOOL isSuccess, id _Nullable response)) completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;


/**
 检测用户是否存在
 
 @param userName 用户名
 @param userType 用户类型
 */
- (void)checkIfTheUserExistsWithUserName:(NSString *_Nullable)userName userType:(NSInteger)userType completion:(void(^_Nullable)(BOOL isSuccess, id _Nullable response)) completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;;

/**
 登录前公告
 
 @param completion Finished block
 @param failure Error block
 */
- (void)checkLoginNoticeCompletion:(void(^_Nullable)(BOOL isSuccess, id _Nullable response)) completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;




/**
 给市场同事方便删除自己的deviceI的接口
 
 @param appId APPID
 @param completion Finished block
 @param failure Error block
 */
- (void)clearDeviceIdWithAppId:(NSString *_Nullable)appId completion:(void(^_Nullable)(BOOL isSuccess, id _Nullable resp))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;





/**
 检查token是否过期
 
 @param token token
 @param userName 用户名
 @param completion Finished block
 @param failure Error block
 */
- (void)checkExpiredForToken:(NSString *_Nullable)token userName:(NSString *_Nullable)userName completion:(void(^_Nullable)(BOOL isSuccess, id _Nullable resp))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;


/**
 token过期是用验证码登录接口
 
 @param phoneNumber 电话号码
 @param code 验证码
 @param completion Finished block
 @param failure Error block
 */
- (void)phoneLoginWithPhoneNumber:(NSString *_Nullable)phoneNumber code:(NSString *_Nullable)code completion:(void(^_Nullable)(BOOL isSuccess, id _Nullable resp, NSString *_Nullable message))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;



/**
 一键注册接口
 
 @param completion Finished block
 @param failure Error block
 */
- (void)registTouristCompletion:(void(^_Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;

/**
 注册
 
 @param userName 用户名
 @param password 密码
 @param registType 注册方式 (1-手机号注册, 0-用户名注册)
 @param code 手机号注册的验证码
 @param completion Finished block
 @param failure Error block
 */
- (void)registWithUserName:(NSString *_Nullable)userName password:(NSString *_Nullable)password regType:(RegistType)registType code:(NSString *_Nullable)code completion:(void(^_Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;





/**
 获取登录后公告
 
 @param completion Finished block
 @param failure Error block
 */
- (void)noticeBeforTheLoginCompletion:(void(^_Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;


/**
 *  游客登录
 */

//- (void)touristLoginCompletion:(void(^)(BOOL isSuccess, id respones))completion;


/**
 登录接口
 
 @param userName 用户名
 @param password 密码
 @param completion Fnished block
 @param failure Error block
 */
- (void)loginWithUserName:(NSString *_Nullable)userName password:(NSString *_Nullable)password completion:(void(^_Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;






/**
 * 验证动态口令
 */
- (void)verifyDynamicPasswordWithKey:(NSString *_Nullable)key completion:(void(^_Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;


/**绑定手机号码
 * @param tokenStr : 登录后的token值
 
 * @param code     : 手机验证码
 
 * @param phoneNum : 手机号码
 */
- (void)bindMobileWithToken:(NSString *_Nullable)tokenStr code:(NSString *_Nullable)code phoneNumber:(NSString *_Nullable)phoneNum completion:(void(^_Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;


- (void)getUserBasicInfoCompletion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;


/**
 * 通过老密码修改新密码
 * @param tokenStr              :   token值
 * @param oldPassword           :   老密码
 * @param password              :   新密码(new是系统关键字忽略)
 * @param repassword            :   新密码确认
 */
- (void)modifyPasswordWithToken:(NSString *_Nullable)tokenStr oldPassword:(NSString *_Nullable)oldPassword password:(NSString *_Nullable)password repasswrod:(NSString *_Nullable)repassword completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;

/**找回密码短信发送接口
 * param phoneNum : 电话号码
 */
- (void)getFindPasswordSmsWithPhoneNumber:(NSString *_Nullable)phoneNum completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^_Nullable)(NSError * _Nullable error))failure;


/**
 * 绑定手机信息
 */
- (void)bindPhoneSmsWithPhoneNumber:(NSString *_Nullable)phoneNum completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;



/**
 手机号登录 验证码

 @param phoneNum 手机号
 @param completion 回调
 @param failure error回调
 */
- (void)loginForPhoneSmsWithPhoneNumber:(NSString *_Nullable)phoneNum completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;


/**找回密码短信验证接口
 * param phoneNum : 电话号码
 * param code : 验证码

 */
- (void)checkSmsWithPhone:(NSString *_Nullable)phoneNum code:(NSString *_Nullable)code completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;

/**修改密码
 * param password : 新密码
 * param phoneNum : 电话号码
 * param code : 验证码

 */
- (void)changePassword:(NSString *_Nullable)password phoneNum:(NSString *_Nullable)phoneNum code:(NSString *_Nullable)code completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;


/*获取是否有未读的新公告*/
- (void)checkGameNoticeCompletion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;



/**
 验证身份证信息

 @param name 用户姓名
 @param idCard 用户身份证号码
 @param completion 完成后回调
 @param failure error回调
 */
- (void)verifyIdcardWithName:(NSString *_Nullable)name idCard:(NSString *_Nullable)idCard completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;


/**
 * 分享游戏礼包
 * 查看是否有分享礼包信息
 @param completion 请求成功回调 (BOOL, id)
 @param failure 请求失败回调 (NSError)
 */
- (void)shareTheGameGiftInfoCompletion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable response))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;

/**
 * 获取应用信息, 切换中英文;
 */
- (void)getInfoWithAppId:(NSString *_Nullable)appId completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;


/**
 * 用户注册角色
 */
- (void)userCreateRoleWithRoleId:(NSString *_Nullable)roleId userId:(NSString *_Nullable)userId htmlSign:(NSString *_Nullable)htmlSign time:(NSString *_Nullable)time completion:(void(^_Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^_Nullable)(NSError *_Nullable error))failure;



/**
 
 * 用户在线5分钟
 */
- (void)onlineFor5MinutesWithUserId:(NSString *_Nullable)userId roleId:(NSString *_Nullable)roleId time:(NSString *_Nullable)time htmlSign:(NSString *_Nullable)htmlSign completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError * _Nullable error))failure;




/**
 
 * 用户角色升级
 */
- (void)levelUpWithUserId:(NSString *_Nullable)userId roleId:(NSString *_Nullable)roleId level:(NSString *_Nullable)level time:(NSString *_Nullable)time htmlSign:(NSString *_Nullable)htmlSign completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;


/**
 用户登录哪个服务器
 
 @param userId uid
 @param serverId 服务器id
 @param loginTime 登录时间
 @param time 时间戳
 @param gameSign HTML签名
 @param completion finished block
 @param failure error block
 */
- (void)userServerLoginWithUserId:(NSString *)userId
                         serverId:(NSString *)serverId
                        loginTime:(NSString *)loginTime
                             time:(NSString *)time
                         gameSign:(NSString *)gameSign
                       completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion
                          failure:(void(^ _Nullable)(NSError *_Nullable error))failure;

/**
 验证游戏参数与签名

 @param params 参数+签名
 @param completion 完成后回调
 @param failure error回调
 */
- (void)checkWebSYSignWithParams:(NSDictionary *_Nullable)params completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;

/**
 检查以哪种方式zhifu

 @param songyorkInfo : zhifu信息
 @param completion : 完成回调
 @param failure : error回调
 */
- (void)checkSongyorkWithSongyorkInfo:(SongyorkInfo *_Nullable)songyorkInfo
                           completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion
                              failure:(void(^ _Nullable)(NSError *_Nullable error))failure;


/**
 * zhifu下订单接口
 * @param pInfo : 数据模型(需要传给后台的各种参数)
 */
- (void)requestSongyorkWithInfo:(SongyorkInfo *_Nullable)songyorkInfo
                     completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion
                        failure:(void(^ _Nullable)(NSError *_Nullable error))failure;


/**
 * zhifu成功后给服务器的回调
 */

- (void)callBackToSongyorkServerWithReceiptInfo:(id _Nullable)params
                                     completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion
                                        failure:(void(^ _Nullable)(NSError *_Nullable error))failure;

/**
 * 检查是否有weifukuan的信息
 */
- (void)checkSYToServerWithReceiptInfo:(id _Nullable)params completion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;

//- (void)loginForForumWithUserName:(NSString *_Nullable)userName Password:(NSString *_Nullable)password failure:(void(^ _Nullable)(NSError *_Nullable error))failure;




/**
 测试接口

 @param completion  : block
 @param failure     : block
 */
- (void)testInfoToAnyParamCompletion:(void(^ _Nullable)(BOOL isSuccess, id _Nullable respones))completion failure:(void(^ _Nullable)(NSError *_Nullable error))failure;


//穿件悬浮窗
- (void)createFloatWindow;

//改绑手机
- (void)changeBindMobilPhone;


//销毁悬浮窗
- (void)destroyFloatWindow;


//创建HTLM游戏页面
- (void)creatHtmlGameWithUrl:(NSString *_Nullable)openuUrl zUrl:(NSString *_Nullable)zUrl;


@end
