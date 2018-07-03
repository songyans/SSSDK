//
//  DSXSYTextTypeCell.h
//  善信
//
//  Created by LQ on 2017/6/5.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXSYTitleModel.h"


@protocol TextTypeCellTextFieldDelegate <NSObject>

- (void)isFirstResponderForTextFiled:(UITextField *)textField;
- (void)TextFieldIsChnagetToText:(NSString *)text;
- (void)pushVCForType:(NSInteger)type;
@end

@interface DSXSYTextTypeCell : UITableViewCell
//textFieldtype : 1-输入框, 2-选择栏, 3-输入框+选择栏
@property (nonatomic, assign) NSInteger textFieldtype;
/**是否换行*/
@property (nonatomic, assign) BOOL isLineFeed;

/**textLimit : 输入框文字限制<任意输入多少>*/
@property (nonatomic, assign) NSInteger textLimit;

@property (nonatomic, strong) DSXSYTitleModel *model;
@property (nonatomic, weak) id <TextTypeCellTextFieldDelegate>delegate;
/**
 * 回调textField.text
 * 在controller区分是哪个textField
 */
@property (nonatomic, copy) void(^TextFieldBlock)(NSString *text);
@end
