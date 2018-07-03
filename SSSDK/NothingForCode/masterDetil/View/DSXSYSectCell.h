//
//  DSXSYSectCell.h
//  善信
//
//  Created by LQ on 2017/6/6.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXSYSectModel.h"


@interface DSXSYSectCell : UITableViewCell

//@property (nonatomic, copy) NSString *sectName;

@property (nonatomic, strong) DSXSYSectModel *model;

@property (nonatomic, strong) UIView *lineView;
@end
