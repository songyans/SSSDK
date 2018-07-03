//
//  DSXSYLabelAndTextField.h
//  善信
//
//  Created by LQ on 2017/6/2.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, AttributedState) {
    Normoal             = 0,    //不使用富文本改变字体颜色
    ChangeColor         = 1,    //使用富文本改变字体颜色
    
};

typedef NS_ENUM(NSInteger, PlaceholderState) {
    NormoalState                       = 0,    //不改变
    ChangeFontSizeState                = 1,    //改变Placeholder字体大小
    ChangeTextColorState               = 2,    //改变Placeholder文字颜色
    ChangeTextAndBgState               = 3,    //改变Placeholder 字体和文字
};


@interface DSXSYLabelAndTextField : NSObject


/**
 *创建Label
 *param frame : 位置大小
 *param attributedState : 富文本编辑状态 <是否编辑>
 *param changeColor : 要改变的颜色
 *param changeTitleText : 要改变的文字
 *param titleText : label的text
 *param fontSize : label字体大小
 *param textAlignment : 文字对齐方式
 *param textColor : 字体颜色
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame TextColorState:(AttributedState)attributedState WantChangeColor:(UIColor *)changeColor ChangeTitle:(NSString *)changeTitleText Titile:(NSString *)titleText FontSize:(NSInteger)fontSize TextColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)textAlignment;


/*创建一个label*/
+ (UILabel *)createLabelWithFrame:(CGRect)frame FontSize:(NSInteger)fontSize TextColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)textAlignment;

/*利用富文本改变label的字体颜色*/
+ (UILabel *)changeTextColorState:(AttributedState)attributedState WantChangeColor:(UIColor *)changeColor ChangeTitle:(NSString *)changeTitleText Titile:(NSString *)titleText ToLabel:(UILabel *)label;

/*利用富文本改变label的字体颜色*/
+ (UILabel *)changeTextColor:(UIColor *)changeColor ChangeTitle:(NSString *)changeTitleText Titile:(NSString *)titleText ToLabel:(UILabel *)label;

/**
 *创建TextField
 *param frame : 位置大小
 *param placeholderText : 占位文字
 *param fontSize : 字体大小
 *param borderStyle : textfield边框样式
 *param textColor : 字体颜色
 *param textFieldbackgroundColor : 背景颜色
 *param keyboardType : 键盘样式
 *param returnKeyType : return键样式
 */

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame Placeholder:(NSString *)placeholderText TextFiledFontSize:(NSInteger)fontSize BorderStyle:(UITextBorderStyle)borderStyle TextColor:(UIColor *)textColor TextFieldBackgroundColor:(UIColor *)textFieldbackgroundColor KeyboardType:(UIKeyboardType)keyboardType ReturnKeyType:(UIReturnKeyType)returnKeyType;



/**
 *设置textfield占位文字的字体颜色和字体大小
 *param placeholderState : 编辑占位文字状态
 *param placeholderTextColor : 字体颜色
 *param placeholderTextFontSize : 字体大小
 */

+ (UITextField *)changePlaceholderState:(PlaceholderState)placeholderState Placeholder:(NSString *)placeholderText PlaceholderTextColor:(UIColor *)placeholderTextColor PlaceholderTextFontSize:(NSInteger)placeholderTextFontSize ToTextField:(UITextField *)textField;



@end
