//
//  DSXSYInputInMastertroductionCell.m
//  善信
//
//  Created by LQ on 2017/6/5.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYInputInMastertroductionCell.h"
#import "DSXSYLabelAndTextField.h"
@interface DSXSYInputInMastertroductionCell ()<UITextViewDelegate, UIScrollViewDelegate>
{
     UILabel *_placeHolderLabel;//自定义占位text
}
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation DSXSYInputInMastertroductionCell

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(0,0, 21312, 21312);
        _textView.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
        _textView.editable = YES;        //是否允许编辑内容，默认为“YES”
        _textView.delegate = self;       //设置代理方法的实现类
        _textView.returnKeyType = UIReturnKeyDefault;//return键的类型
        _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
        _textView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;
        _textView.textColor = [UIColor blackColor];
        _textView.tag = 1001;
        _textView.alwaysBounceVertical = YES;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
        _textView.layer.borderWidth = 0.6f;
        _textView.layer.cornerRadius = 6.0f;
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5,21312, 40)];
        _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        _placeHolderLabel.font = [UIFont systemFontOfSize:15];
        _placeHolderLabel.numberOfLines = 0;
        
        [_textView addSubview:_placeHolderLabel];
        
    }
    return _textView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
        
    }
    return _titleLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.textView];
    }
    return self;
}

- (void)layoutSubviews{
    Weak_Self;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(15);
        make.left.equalTo(weakSelf).offset(12);
    }];
    
    CGSize textSize = [self.textView.text boundingRectWithSize:CGSizeMake(21312 - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.textView.font} context:nil].size;
    SYLog(@"%lf", textSize.width);
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(10);
        make.left.equalTo(weakSelf).offset(12);
        make.size.mas_equalTo(CGSizeMake(21312 - 24, 68));
    }];
    
}

- (void)setModel:(DSXSYInputMIModel *)model{
    _model = model;
    
    if ([_model.title containsString:@"*"]) {
        self.titleLab = [DSXSYLabelAndTextField changeTextColor:[UIColor redColor] ChangeTitle:@"*" Titile:_model.title ToLabel:self.titleLab];
    }else{
        self.titleLab.text = _model.title;
    }

    _placeHolderLabel.text = _model.placeHolderStr;
}


# pragma mark --------------------------------------------------------------- UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{

//    [self.textView becomeFirstResponder];
    if (self.textView.isFirstResponder) {
        self.isFirst = YES;
        [self TextViewIsFirst];
    }
    
    
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        if (_placeHolderLabel.text.length > 0) {
            _placeHolderLabel.text = nil;

        }
    }else{
        if (_placeHolderLabel.text.length == 0) {
            
           _placeHolderLabel.text = _model.placeHolderStr;
        }

        
    }
    
    if (textView.markedTextRange == nil && [textView.text length] > 500)
    {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 500)];
        [textView.undoManager removeAllActions];
        [textView becomeFirstResponder];
        return;
    }

    
    
    
}


# pragma mark --------------------------------------------------------------- UIScrollViewDelegate

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self.textView resignFirstResponder];
//}


# pragma mark --------------------------------------------------------------- InputInMastertroductionCellDelegate

- (void)TextViewIsFirst{
    if (self.isFirst) {
        if ([self.delegate respondsToSelector:@selector(isFirstResponderForTextView:)]) {
            [self.delegate isFirstResponderForTextView:self.textView];
        }
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
