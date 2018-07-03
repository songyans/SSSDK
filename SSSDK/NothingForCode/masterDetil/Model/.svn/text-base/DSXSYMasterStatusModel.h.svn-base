//
//  DSXSYMasterStatusModel.h
//  善信
//
//  Created by LQ on 2017/6/9.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSXSYMasterStatusModel : NSObject

/**审核状态 0表示审核中 ；1表示审核成功 ；2表示审核失败 3：没有提交过*/
@property (nonatomic, assign) NSInteger auditStatus;
/**审核成功详细资料url*/
@property (nonatomic, copy) NSString *auditSuccessDetailUrl;
/**审核时间*/
@property (nonatomic, copy) NSString *auditTime;
/**认证失败原因*/
@property (nonatomic, copy) NSString *failureReason;
/**是否是师父 0表示不是 ；1表示是*/
@property (nonatomic, assign) BOOL isMaster;
/**审核几个工作日*/
@property (nonatomic, copy) NSString *masterDetailAuditdays;
/**师父详细资料ID*/
@property (nonatomic, assign) NSInteger masterDetailId;
/**审核提交时间*/
@property (nonatomic, copy) NSString *submitTime;

/*
 auditStatus (integer, optional): 审核状态 0表示审核中 ；1表示审核成功 ；2表示审核失败 3：没有提交过 ,
 auditSuccessDetailUrl (string, optional): 审核成功详细资料url ,
 auditTime (Timestamp, optional): 审核时间 ,
 failureReason (string, optional): 认证失败原因 ,
 isMaster (integer, optional): 是否是师父 0表示不是 ；1表示是 ,
 masterDetailAuditdays (string, optional): 审核几个工作日 ,
 masterDetailId (string, optional): 师父详细资料ID ,
 submitTime (Timestamp, optional): 审核提交时间
 
 */


@end
