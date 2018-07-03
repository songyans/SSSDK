//
//  DSXSYLabelAndTextField.m
//  善信
//
//  Created by LQ on 2017/6/2.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYLabelAndTextField.h"
@interface DSXSYLabelAndTextField()

//@property (nonatomic, strong) UITextField *textField;

@end

@implementation DSXSYLabelAndTextField

- (void)setTextField:(UITextField *)textField{
    self.textField = textField;
}




+ (UILabel *)createLabelWithFrame:(CGRect)frame TextColorState:(AttributedState)attributedState WantChangeColor:(UIColor *)changeColor ChangeTitle:(NSString *)changeTitleText Titile:(NSString *)titleText FontSize:(NSInteger)fontSize TextColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.text = titleText;
    label.numberOfLines = 0;
    if (attributedState == ChangeColor) {
        NSDictionary *subStringAttribute = @{
                                             NSForegroundColorAttributeName     : changeColor,
                                             NSFontAttributeName                : label.font
                                             };
        label.attributedText = [titleText toAttributedStringWithChangeWords:@[changeTitleText] andAttributes:@[subStringAttribute]];
    }
    return label;
}



+ (UILabel *)createLabelWithFrame:(CGRect)frame FontSize:(NSInteger)fontSize TextColor:(UIColor *)textColor TextAlignment:(NSTextAlignment)textAlignment{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    
    label.numberOfLines = 0;
    
    return label;
    
}

+ (UILabel *)changeTextColorState:(AttributedState)attributedState WantChangeColor:(UIColor *)changeColor ChangeTitle:(NSString *)changeTitleText Titile:(NSString *)titleText ToLabel:(UILabel *)label{
    
    if (attributedState == ChangeColor) {
        NSDictionary *subStringAttribute = @{
                                             NSForegroundColorAttributeName     : changeColor,
                                             NSFontAttributeName                : label.font
                                             };
        label.attributedText = [titleText toAttributedStringWithChangeWords:@[changeTitleText] andAttributes:@[subStringAttribute]];
    }
    return label;
}


+ (UILabel *)changeTextColor:(UIColor *)changeColor ChangeTitle:(NSString *)changeTitleText Titile:(NSString *)titleText ToLabel:(UILabel *)label{
        NSDictionary *subStringAttribute = @{
                                             NSForegroundColorAttributeName     : changeColor,
                                             NSFontAttributeName                : label.font
                                             };
        label.attributedText = [titleText toAttributedStringWithChangeWords:@[changeTitleText] andAttributes:@[subStringAttribute]];
    return label;

}


+ (UITextField *)createTextFieldWithFrame:(CGRect)frame Placeholder:(NSString *)placeholderText TextFiledFontSize:(NSInteger)fontSize BorderStyle:(UITextBorderStyle)borderStyle TextColor:(UIColor *)textColor TextFieldBackgroundColor:(UIColor *)textFieldbackgroundColor KeyboardType:(UIKeyboardType)keyboardType ReturnKeyType:(UIReturnKeyType)returnKeyType{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeholderText;
    textField.borderStyle = borderStyle;
    textField.textColor = textColor;
    textField.backgroundColor = textFieldbackgroundColor;
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.keyboardType = keyboardType;
    textField.returnKeyType = returnKeyType;
   
    
    return textField;
    
}


+ (UITextField *)changePlaceholderState:(PlaceholderState)placeholderState Placeholder:(NSString *)placeholderText PlaceholderTextColor:(UIColor *)placeholderTextColor PlaceholderTextFontSize:(NSInteger)placeholderTextFontSize ToTextField:(UITextField *)textField{
    if (placeholderText.length > 0) {
        textField.placeholder = placeholderText;
    }
    
    
    switch (placeholderState) {
        case ChangeFontSizeState:
            [textField setValue:[UIFont systemFontOfSize:placeholderTextFontSize] forKeyPath:@"_placeholderLabel.font"];
            break;
            
        case ChangeTextColorState:
            [textField setValue:placeholderTextColor forKeyPath:@"_placeholderLabel.textColor"];
            break;
            
        case ChangeTextAndBgState:
            [textField setValue:[UIFont systemFontOfSize:placeholderTextFontSize] forKeyPath:@"_placeholderLabel.font"];
            [textField setValue:placeholderTextColor forKeyPath:@"_placeholderLabel.textColor"];
            break;
            
        case NormoalState:
            break;
            
        default:
            break;
    }
    

    return textField;
}

@end





/**
 _textField = [[UITextField alloc] init];
 _textField.placeholder = @"仅可使用1~10位中英文、数字、下划线及其组合";
 _textField.delegate = self;
 [_textField setValue:DSX178GrayColor forKeyPath:@"_placeholderLabel.textColor"];
 [_textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
 _textField.borderStyle = UITextBorderStyleRoundedRect;
 _textField.textColor = DSXColor1(35, 35, 35);
 _textField.backgroundColor = DSXColor1(250, 250, 250);
 if (IS_IPHONE_5) {
 _textField.font = [UIFont systemFontOfSize:12];
 }else{
 _textField.font = [UIFont systemFontOfSize:17];
 }
 _textField.keyboardType = UIKeyboardTypeDefault;
 _textField.returnKeyType = UIReturnKeyDone;


 */
