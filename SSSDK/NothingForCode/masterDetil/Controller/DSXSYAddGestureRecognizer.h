//
//  DSXSYAddGestureRecognizer.h
//  善信
//
//  Created by LQ on 2017/6/22.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSXSYAddGestureRecognizer : NSObject

+ (UIViewController *)callCustomerServiceController;

+ (id)addGestureRecognizerToView:(id)view Tag:(int)tag Type:(NSInteger)type;

+ (void)limitTextLengthFor:(UITextField *)textField length:(NSInteger)maxLength;

+ (UITextView *)createTextViewWithFontSize:(NSInteger)size TextColor:(UIColor *)textColor;

+ (UILabel *)createPlaceholderWithText:(NSString *)placeholderText TextColor:(UIColor *)textColor FontSize:(NSInteger)size TextAlignment:(NSTextAlignment)textAlignment;
@end
