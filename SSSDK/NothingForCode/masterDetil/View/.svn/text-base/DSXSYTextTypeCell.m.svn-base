//
//  DSXSYTextTypeCell.m
//  善信
//
//  Created by LQ on 2017/6/5.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYTextTypeCell.h"
#import "DSXSYLabelAndTextField.h"

@interface DSXSYTextTypeCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, strong) UILabel *selectTitleLab;
@property (nonatomic, strong) UILabel *selectDetailLab;
@property (nonatomic, strong) UIImageView *arrowImgView;

@property (nonatomic, strong) UILabel *textFieldLab;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isChange;


@end

@implementation DSXSYTextTypeCell

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
        
    }
    return _titleLab;
}

- (UILabel *)textFieldLab{
    if (!_textFieldLab) {
        _textFieldLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero FontSize:17 TextColor:[UIColor blackColor] TextAlignment:0];
        
    }
    return _textFieldLab;
}


- (UITextField *)textField{
    if (!_textField) {
        _textField = [DSXSYLabelAndTextField createTextFieldWithFrame:CGRectZero Placeholder:nil TextFiledFontSize:17 BorderStyle:UITextBorderStyleRoundedRect TextColor:[UIColor blackColor] TextFieldBackgroundColor:[UIColor clearColor] KeyboardType:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyDone];
        _textField.delegate = self;
        
        
    }
    return _textField;
}



- (UILabel *)selectTitleLab{
    if (!_selectTitleLab) {
        _selectTitleLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero FontSize:17 TextColor:[UIColor blackColor] TextAlignment:0];
        _selectTitleLab.userInteractionEnabled = YES;
    }
    return _selectTitleLab;
}

- (UILabel *)selectDetailLab{
    if (!_selectDetailLab) {
        _selectDetailLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero FontSize:14 TextColor:[UIColor clearColor] TextAlignment:0];
        _selectDetailLab.userInteractionEnabled = YES;
    }
    return _selectDetailLab;
}
//img_classify
- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [UIImage imageNamed:@"icon_enter_gary"];
        _arrowImgView.userInteractionEnabled = YES;
    }
    return _arrowImgView;
}

- (UIImageView *)selectImgView{
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];
        _selectImgView.image = [UIImage imageNamed:@"Input-box"];
        _selectImgView.userInteractionEnabled = YES;
        _selectImgView.backgroundColor = [UIColor clearColor];
        _selectImgView.layer.cornerRadius = 3;
        _selectImgView.layer.masksToBounds = YES;
    }
    return _selectImgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.titleLab];
        [self addSubview:self.textField];
        [self addSubview:self.selectImgView];
        [self addSubview:self.textFieldLab];
        [self.selectImgView addSubview:self.selectTitleLab];
        [self.selectImgView addSubview:self.selectDetailLab];
        [self.selectImgView addSubview:self.arrowImgView];
        
        [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
       
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.textField];
        
        
        
        UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tap:)];
        //    配置属性
        //    轻拍次数
        tapGestureRecognizer.numberOfTapsRequired =1;
        //    轻拍手指个数
        tapGestureRecognizer.numberOfTouchesRequired =1;
        //    讲手势添加到指定的视图上
        [self.selectImgView addGestureRecognizer:tapGestureRecognizer];
        
       
        
       
    }
    return self;
}

- (void)layoutSubviews{
    Weak_Self;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(0);
        make.left.equalTo(weakSelf).offset(12);
    }];
    
    if (self.textFieldtype == 1) {
        self.textField.hidden = NO;
        [self selectHidden:YES];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(10);
            make.left.equalTo(weakSelf).offset(12);
            make.size.mas_equalTo(CGSizeMake(21312 - 24, 44));
        }];
       
        
    }else if (self.textFieldtype == 2){
               
        self.textField.frame = CGRectZero;
        self.textField.hidden = YES;
        [self selectHidden:NO];
        
        [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(10);
            make.left.equalTo(weakSelf).offset(12);
            make.size.mas_equalTo(CGSizeMake(21312 - 24, 44));
        }];
        
        [self.selectTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.selectImgView).offset(12);
            make.centerY.equalTo(weakSelf.selectImgView).offset(0);
        }];
        
        [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.selectImgView).offset(-12);
            make.centerY.equalTo(weakSelf.selectImgView).offset(0);
        }];
        
        [self.selectDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.arrowImgView.mas_left).offset(-10);
            make.centerY.equalTo(weakSelf.selectImgView).offset(0);
        }];
        
        
       
               
    }else{
        self.textField.hidden = NO;
         [self selectHidden:NO];
       
        
        [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(10);
            make.left.equalTo(weakSelf).offset(12);
            make.size.mas_equalTo(CGSizeMake(21312 - 24, 44));
        }];
        
        [self.selectTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.selectImgView).offset(12);
            make.centerY.equalTo(weakSelf.selectImgView).offset(0);
        }];
        
        [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.selectImgView).offset(-12);
            make.centerY.equalTo(weakSelf.selectImgView).offset(0);
        }];
        
        [self.selectDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.arrowImgView.mas_left).offset(-10);
            make.centerY.equalTo(weakSelf.selectImgView).offset(0);
        }];
        
        [self.textFieldLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.selectImgView.mas_bottom).offset(10);
            make.left.equalTo(weakSelf).offset(12);
            make.size.mas_equalTo(CGSizeMake(21312 - 24, 44));
        }];
        
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.bottom.and.right.equalTo(weakSelf.textFieldLab).offset(0);
        }];
        
       
    }

    
}

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer{
    if ([self.delegate respondsToSelector:@selector(pushVCForType:)]) {
        [self.delegate pushVCForType:self.textFieldtype];
    }
}

- (void)selectHidden:(BOOL)isHidden{
    if (isHidden) {
        self.selectImgView.frame = CGRectZero;
        self.selectImgView.hidden = YES;
        
        self.selectTitleLab.frame = CGRectZero;
        self.selectTitleLab.hidden = YES;
        
        self.selectDetailLab.frame = CGRectZero;
        self.selectDetailLab.hidden = YES;
        
        self.arrowImgView.frame = CGRectZero;
        self.arrowImgView.hidden = YES;

    }else{
        self.selectImgView.hidden = NO;
        self.selectTitleLab.hidden = NO;
        self.selectDetailLab.hidden = NO;
        self.arrowImgView.hidden = NO;
    }
    
}

/*
 [_model.title containsString:@"*"]
 */
- (void)setModel:(DSXSYTitleModel *)model{
    _model = model;
    if ([_model.title containsString:@"*"]) {
        self.titleLab = [DSXSYLabelAndTextField changeTextColor:[UIColor redColor] ChangeTitle:@"*" Titile:_model.title ToLabel:self.titleLab];
    }else{
        self.titleLab.text = _model.title;
    }
    
    if (_model.selectTitle.length > 0) {
        self.selectTitleLab.text = _model.selectTitle;
    }
    
    if (_model.selectDetail.length == 0) {
        self.selectDetailLab.text = @"请选择";
    }else{
        self.selectDetailLab.text = _model.selectDetail;
    }
    if (self.textField.hidden == NO) {
        self.textField = [DSXSYLabelAndTextField changePlaceholderState:ChangeFontSizeState Placeholder:_model.placeholder PlaceholderTextColor:nil PlaceholderTextFontSize:15 ToTextField:self.textField];
    }
    
   

}

# pragma mark --------------------------------------------------------------- UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"开始编辑");
//    if (self.textField.isFirstResponder) {
////        self.textField.hidden = NO;
//        self.textFieldLab.hidden = YES;
//    }

    
    self.isFirst = YES;
    [self TextFieldIsFirst];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
//    [self labShow];
    
    return YES;
}

//label取代textField
- (void)labShow{
    
    if (!self.textField.isFirstResponder) {
        self.textFieldLab.text = self.textField.text;
//        self.textField.hidden = YES;
        self.textField.text = @"";
        self.textFieldLab.hidden = NO;
        CGSize textFieldSize = [self.textField.text boundingRectWithSize:CGSizeMake(21312 - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.textField.font} context:nil].size;
        if (textFieldSize.height > 44) {
            self.textFieldLab.size = CGSizeMake(21312 - 24, textFieldSize.height);
        }else{
            self.textFieldLab.size = CGSizeMake(21312 - 24, 44);
            
        }
    }
    

}
/*输入框输入的文字限制*/
-(void)textFieldEditChanged:(NSNotification *)obj{
    
    
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position && (self.textLimit > 0))
    {
        if (toBeString.length > self.textLimit)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.textLimit];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:self.textLimit];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.textLimit)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
    /*
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;

    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.textLimit) {
                textField.text = [toBeString substringToIndex:self.textLimit];
            }
        }       // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else
        {
            if (toBeString.length > self.textLimit)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.textLimit];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:self.textLimit];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.textLimit)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
     */
}



# pragma mark --------------------------------------------------------------- TextTypeCellTextFieldDelegate

- (void)TextFieldIsFirst{
    if (self.isFirst) {
        if ([self.delegate respondsToSelector:@selector(isFirstResponderForTextFiled:)]) {
            [self.delegate isFirstResponderForTextFiled:self.textField];
        }
    }
}


- (void)textFieldDidChange:(UITextField *)textField{
    self.isChange = YES;
    if ([self.delegate respondsToSelector:@selector(TextFieldIsChnagetToText:)]) {
        [self.delegate TextFieldIsChnagetToText:textField.text];

    }
    
    if (self.TextFieldBlock) {
        self.TextFieldBlock(textField.text);
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
