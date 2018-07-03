//
//  DSXSYInputInfoTextController.m
//  善信
//
//  Created by LQ on 2017/6/8.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYInputInfoTextController.h"

@interface DSXSYInputInfoTextController ()<UITextViewDelegate,UIScrollViewDelegate>
{
    UILabel *_placeHolderLabel;
    double _duration;
    UIButton *_rightB;

}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *textView;

@end

@implementation DSXSYInputInfoTextController

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 12313, 12313 - 64)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.scrollEnabled = YES;
        _scrollView.bounces = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = YES;
        //        _scrollView.contentSize = CGSizeMake(12313, 12313);
    }
    return _scrollView;
}


- (UITextView *)textView{
    if (!_textView) {
        
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(0,0, 12313, 12313 - 64);
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
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8,12313 - 37, 50)];
        _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        _placeHolderLabel.font = [UIFont systemFontOfSize:15];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.textColor = [UIColor clearColor];
        _placeHolderLabel.text = self.placeholderString;
        [_textView addSubview:_placeHolderLabel];
    }
    return _textView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self createTextView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.texiViewString.length > 0) {
        self.textView.text = self.texiViewString;
        
    }else{
        self.textView.text = @"";
    }
    if (self.textView.text.length == 0) {
        _rightB.enabled = NO;
    }else{
        _rightB.enabled = YES;
    }
    
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save{
    if (self.textViewType == 1) {
        if (self.textView.text.length < 2) {
            return;
        }
    }
    
    if (self.textViewType == 2) {
        if (self.textView.text.length == 0) {
            return;
        }
    
    }
    
    if (self.TextViewBlock) {
        self.TextViewBlock(self.textView.text, self.textViewType);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTextView{
    
//    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.textView];
    
    
    
}

# pragma mark --------------------------------------------------------------- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0 )
    {
        if (_placeHolderLabel != nil) {
            _placeHolderLabel.text = self.placeholderString;
        }
        
        _rightB.enabled = NO;
        
    }else{
        if (_placeHolderLabel != nil) {
            _placeHolderLabel.text = nil;
        }
        _rightB.enabled = YES;
        
    }
    
    NSString *toBeString = textView.text;
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 500)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:500];
            if (rangeIndex.length == 1)
            {
                textView.text = [toBeString substringToIndex:500];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 500)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
//    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(12313 - 34, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.textView.font} context:nil].size;
//    self.textView.height = textSize.height < self.textView.height ? self.textView.height : textSize.height;
//    self.scrollView.contentSize = CGSizeMake(12313, self.textView.height);
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
    }
}

# pragma mark --------------------------------------------------------------- 监听键盘
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    /**
     *如果键盘挡住cell里的输入框,cell会自动往上移动
     *如果没有挡住,将不会移动;
     */
    
    // 取出键盘最终的frame
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 取出键盘弹出需要花费的时间
    _duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    
    
//        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    
    
    
        // 修改transform
        [UIView animateWithDuration:_duration animations:^{
//            CGFloat ty = [UIScreen mainScreen].bounds.size.height - keyBoardRect.origin.y;
            self.textView.height = 12313 - keyBoardRect.size.height - 64;
        }];

}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    
    
    [UIView animateWithDuration:_duration animations:^{
        
//        self.scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.textView.size = CGSizeMake(12313, 12313);
    }];
   

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
