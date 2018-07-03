//
//  UsernameTableViewCell.h
//  AYSDK
//
//  Created by songyan on 2018/1/30.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SS_UserModel.h"

@protocol SYUserCellDelegate <NSObject>

- (void)cell:(UITableViewCell *)cell deleteUsernameInfoIsDone:(BOOL)isDone deleteUsername:(NSString *)username;

//- (BOOL)ifCellFrameIsZero;

@end
@interface UsernameTableViewCell : UITableViewCell

@property (nonatomic, weak)id<SYUserCellDelegate>delegate;


@property (nonatomic ,strong) SS_UserModel *model;

@end
