//
//  DSXSYMassterDetailTool.m
//  善信
//
//  Created by LQ on 2017/6/23.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYMassterDetailTool.h"

#import "DSXSYGestureRecognizerTool.h"
@interface DSXSYMassterDetailTool ()



@end

@implementation DSXSYMassterDetailTool


/*
 添加手势
 */
+ (id)addGestureRecognizerToView:(id)view Tag:(int)tag Type:(NSInteger)type Completion:(void (^)(UITapGestureRecognizer *tap))completion{
    //WithTarget:self  action:@selector(tap:)
    DSXSYGestureRecognizerTool *tapGestureRecognizer =[[DSXSYGestureRecognizerTool alloc]init];
    
    //    配置属性
    //    轻拍次数
//    tapGestureRecognizer.numberOfTapsRequired =1;
    //    轻拍手指个数
//    tapGestureRecognizer.numberOfTouchesRequired =1;
    //    讲手势添加到指定的视图上
    
    if (type == 1) {
        UILabel *lab = (UILabel *)view;
        lab.userInteractionEnabled = YES;
        lab.tag = tag;
        [lab addGestureRecognizer:tapGestureRecognizer];
//        tapGestureRecognizer.TapGestureBlock = completion;
        
        return lab;
    }else if (type == 2){
        UIImageView *imgV = (UIImageView *)view;
        imgV.userInteractionEnabled = YES;
        imgV.tag = tag;
        [imgV addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer addTapBlock:^(UITapGestureRecognizer *tap) {
            
        }];
        return imgV;
    }else if (type == 3){
        UITextView *textV = (UITextView *)view;
        textV.userInteractionEnabled = YES;
        textV.tag = tag;
        [textV addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer.TapGestureBlock = completion;
        return textV;
    }
    
    
    return nil;
    
}


// placeholderText
+ (UILabel *)createPlaceholderWithText:(NSString *)placeholderText TextColor:(UIColor *)textColor FontSize:(NSInteger)size TextAlignment:(NSTextAlignment)textAlignment{
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8,32423 - 37, 50)];
    placeHolderLabel.textAlignment = textAlignment;
    placeHolderLabel.font = [UIFont systemFontOfSize:size];
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = textColor; //DSXColor1(178, 178, 178)
    //    placeHolderLabel.text = placeholderText;
    
    
    return placeHolderLabel;
}


+ (UIViewController *)callCustomerServiceController{
    //客服
    
    NSDictionary  *response = @{@"":@""}; if ( response) {
        
        if ([response[@"code"] intValue] == 200) {
            
            
//            [self.navigationController pushViewController:chatC animated:YES];
            
        }
        else
        {
        }
        
    }
    
       return nil;
}


//TextView
+ (UITextView *)createTextViewWithFontSize:(NSInteger)size TextColor:(UIColor *)textColor{
    UITextView *text = [[UITextView alloc] init];
    //    text = [[UITextView alloc] init];
    //    text.frame = CGRectMake(12,0, SCREEN_WIDTH - 24, SCREEN_HEIGHT);
    text.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    text.editable = NO;        //是否允许编辑内容，默认为“YES”
    //    text.delegate = self;       //设置代理方法的实现类
    
    
    text.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    text.dataDetectorTypes = UIDataDetectorTypeAll;
    text.textColor = textColor;
    
    text.alwaysBounceVertical = YES;
    text.font = [UIFont systemFontOfSize:size];
    text.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    text.layer.borderWidth = 0.6f;
    text.layer.cornerRadius = 6.0f;
    return text;
}


+ (void)limitTextLengthFor:(UITextField *)textField length:(NSInteger)maxLength{
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
}



@end
