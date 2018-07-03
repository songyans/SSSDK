//
//  DSXSYMasterDataController.h
//  善信
//
//  Created by LQ on 2017/6/2.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXSYInputMIModel.h"
@interface DSXSYMasterDataController : UIViewController

@property (nonatomic, strong) DSXSYInputMIModel *inputModel;

@property (nonatomic, assign) BOOL isFail;

/*
 * 提交成功 返回一个bool值回调;
 * YES-提交成功, NO-条件失败
 */
@property (nonatomic, copy) void(^IsSubmitBlock)(BOOL isSubmit);
@end
