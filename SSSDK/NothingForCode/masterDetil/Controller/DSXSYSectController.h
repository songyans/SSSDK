//
//  DSXSYSectController.h
//  善信
//
//  Created by LQ on 2017/6/6.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXSYSectModel.h"
//typedef void(^SectBlock)(DSXSYSectModel *info);

@interface DSXSYSectController : UIViewController

@property (nonatomic, copy) void(^SectBlock)(DSXSYSectModel *info);


@end
