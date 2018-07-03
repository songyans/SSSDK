//
//  DSXSYShowMasterDetailController.h
//  善信
//
//  Created by LQ on 2017/6/12.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IsMasterSelf) {
    Myself              = 0,    //师傅自己进入
    Other               = 1,    //他人进入
    
};


@interface DSXSYShowMasterDetailController : UIViewController

/**
 * 是否是自己查看自己详细资料  <必填> 
 * 师父需要修改资料 填 Myself
 * 其他 Other
 */
@property (nonatomic, assign) IsMasterSelf isMasterSelf;

/**师父详细资料展示链接*/
@property (nonatomic, copy) NSString *showMasterUrl;

/**审核时间*/
@property (nonatomic, copy) NSString *auditTime;


@end
