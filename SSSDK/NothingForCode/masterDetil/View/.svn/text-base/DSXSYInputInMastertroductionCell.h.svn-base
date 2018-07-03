//
//  DSXSYInputInMastertroductionCell.h
//  善信
//
//  Created by LQ on 2017/6/5.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXSYInputMIModel.h"

@protocol InputInMastertroductionCellDelegate <NSObject>

- (void)isFirstResponderForTextView:(UITextView *)textView;
- (void)TextFieldIsChnagetToText:(NSString *)text;
@end


@interface DSXSYInputInMastertroductionCell : UITableViewCell

@property (nonatomic, strong) DSXSYInputMIModel *model;

@property (nonatomic, weak) id <InputInMastertroductionCellDelegate>delegate;

@end
