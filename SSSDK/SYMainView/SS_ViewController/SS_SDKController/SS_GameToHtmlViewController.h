//
//  GameToHtmlViewController.h
//  AYSDK
//
//  Created by songyan on 2018/2/3.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SS_GameToHtmlViewController : UIViewController
@property (nonatomic, copy) void(^OutBlock)(void);

@property (nonatomic, copy)NSString *requestURL;//游戏链接
@property (nonatomic, copy)NSString *zUrl;//支付链接


@end
