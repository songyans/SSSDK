//
//  DSXSYReviewFailureController.m
//  善信
//
//  Created by LQ on 2017/6/9.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYReviewFailureController.h"
#import "DSXSYMasterDataController.h"
#import "DSXSYInputMIModel.h"

@interface DSXSYReviewFailureController ()
{
    CGSize _failSize;
    NSString *_timeString;
}
@property (nonatomic, strong) UIImageView *successImageView;
@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *modifyBtn;
@property (nonatomic, strong) UIButton *lookOverBtn;
@property (nonatomic, strong) UILabel *customerServiceLabel;
@property (nonatomic, strong) DSXSYInputMIModel *inputModel;

//客服
@end

@implementation DSXSYReviewFailureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善师父详细资料";
    self.view.backgroundColor = [UIColor clearColor];
   
    [self createContent];
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)successImageView{
    if (!_successImageView) {
        _successImageView = [[UIImageView alloc] init];
        _successImageView.image = [UIImage imageNamed:@"img_shibai_renzheg"];
    }
    return _successImageView;
}

- (UILabel *)successLabel{
    if (!_successLabel) {
        _successLabel = [[UILabel alloc] init];
        _successLabel.textColor = [UIColor blackColor];
        _successLabel.font = [UIFont systemFontOfSize:17];
        _successLabel.text = @"审核失败";
        _successLabel.numberOfLines = 0;
        _successLabel.textAlignment = 1;
    }
    return _successLabel;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor clearColor];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _timeString = [self transformTimeWithString:self.auditTime];
        _messageLabel.text = [NSString stringWithFormat:@"师兄大善，你于%@提交的资料未通过审核，（%@）请联系客服或者修改后重新提交",_timeString, self.failureReason];
        _messageLabel.textAlignment = 1;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UILabel *)customerServiceLabel{
    if (!_customerServiceLabel) {
        _customerServiceLabel = [[UILabel alloc] init];
        _customerServiceLabel.textColor = [UIColor clearColor];
        _customerServiceLabel.font = [UIFont systemFontOfSize:14];
        _customerServiceLabel.text = @"联系客服";
        _customerServiceLabel.textAlignment = 1;
        _customerServiceLabel.numberOfLines = 0;
    }
    return _customerServiceLabel;
}

- (UIButton *)modifyBtn{
    if (!_modifyBtn) {
        _modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_button_n"] forState:UIControlStateNormal];
        [_modifyBtn setBackgroundImage:[UIImage imageNamed:@"btn_button_p"] forState:UIControlStateHighlighted];
        [_modifyBtn setTitle:@"修改资料" forState:UIControlStateNormal];
        _modifyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_modifyBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_modifyBtn setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [_modifyBtn addTarget:self action:@selector(modifyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyBtn;
}

- (UIButton *)lookOverBtn{
    if (!_lookOverBtn) {
        _lookOverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookOverBtn setBackgroundImage:[UIImage imageNamed:@"btn_button2_n"] forState:UIControlStateNormal];
        [_lookOverBtn setBackgroundImage:[UIImage imageNamed:@"btn_button2_p"] forState:UIControlStateHighlighted];
        [_lookOverBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_lookOverBtn setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        [_lookOverBtn setTitle:@"查看现有资料" forState:UIControlStateNormal];
        _lookOverBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_lookOverBtn addTarget:self action:@selector(lookOverClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookOverBtn;
}

/*
 *年月日改为中文
 *Parma string : 时间戳字符串
 */
- (NSString *)transformTimeWithString:(NSString *)string{
    NSTimeInterval time = [string doubleValue] / 1000;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
//    SYLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];//HH:mm  -dd
//    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//    SYLog(@"====%@====", currentDateStr);
    NSDateComponents *sourceComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour) fromDate:detailDate];
    NSString * dateStr = [NSString stringWithFormat:@"%@年%@月%@日",@(sourceComp.year),@(sourceComp.month),@(sourceComp.day)];
    return dateStr;

}

/*
- (NSString *)changeDateLanguage:(NSDate *)date{
    
    NSDateComponents *sourceComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour) fromDate:date];
    
    NSString * dateStr = [NSString stringWithFormat:@"%@年%@月%@日",@(sourceComp.year),@(sourceComp.month),@(sourceComp.day)];
//    NSString *dateString = [NSString stringWithFormat:@"%@ %@",dateStr,[date stringWithFormat:@"HH:mm"]];
    return dateStr;
}
*/

- (void)createContent{
    Weak_Self;
    [self.view addSubview:self.successImageView];
    [self.successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(40);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(weakSelf.view);
    }];
    
    [self.view addSubview:self.successLabel];
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.successImageView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(123, 20));
    }];
    
    _failSize = [self.messageLabel.text boundingRectWithSize:CGSizeMake(123 - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.messageLabel.font} context:nil].size;
    
    [self.view addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.successLabel.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.view).offset(35);
        make.size.mas_equalTo(CGSizeMake(123 - 70, _failSize.height + 10));
    }];
    
    [self.view addSubview:self.modifyBtn];
    [self.view addSubview:self.lookOverBtn];
    [self.view addSubview:self.customerServiceLabel];
     self.customerServiceLabel = [self addGestureRecognizerToView:self.customerServiceLabel Tag:100 Type:1];
    
    [self.modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.messageLabel.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(200, 44));
        make.centerX.equalTo(weakSelf.view);
    }];

    if (!self.isFirst) {
        
        
        
        [self.lookOverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.modifyBtn.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(200, 44));
            make.centerX.equalTo(weakSelf.view);
        }];
        
        
       
        [self.customerServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.lookOverBtn.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(123, 20));
            make.centerX.equalTo(weakSelf.view);
            
        }];

    }else{
        
        [self.customerServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.modifyBtn.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(123, 20));
            make.centerX.equalTo(weakSelf.view);
            
        }];
    }
    
}

- (void)modifyClick{
    SYLog(@"修改");
     self.inputModel = [[DSXSYInputMIModel alloc] init];
 
    [self loadDataForModify];

    
}

- (void)loadDataForModify{
    Weak_Self;
    NSString *urlString = @"/api/master/attestation/getMasterDetail.do";
    NSString *url = [NSString stringWithFormat:@"%@%@",@"",urlString];
    NSDictionary *param = @{
                            @"uid"  : url,
                            };
   if (param) {
        SYLog(@"++++++++++++++++++++++++++++++%@-----------------%@",param, param[@"message"]);
        if ([param[@"code"] intValue] == 200) {
            weakSelf.inputModel = [[DSXSYInputMIModel alloc ]init];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                if (weakSelf.isFirst) {
//                    DSXSYMasterDataController *mdVC = [[DSXSYMasterDataController alloc] init];
//                    [weakSelf.navigationController pushViewController:mdVC animated:YES];
//
//                }else{
                    if (weakSelf.inputModel.uid > 0) {
                        DSXSYMasterDataController *mdVC = [[DSXSYMasterDataController alloc] init];
                        mdVC.inputModel = weakSelf.inputModel;
                        mdVC.isFail = YES;
                        [weakSelf.navigationController pushViewController:mdVC animated:YES];
                    }
//                }
                
               
            });
        }else{
        }
        
    }     
}

- (void)lookOverClick{
    
    SYLog(@"查看");
    
}


/**
 * param view : 需要添加手势的空间
 * param tag  : tag值,区分
 * param type : <1-label, 2-imageView, 3-textView>
 */
- (id)addGestureRecognizerToView:(id)view Tag:(int)tag Type:(NSInteger)type{
    
    UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self     action:@selector(tap:)];
    //    配置属性
    //    轻拍次数
    tapGestureRecognizer.numberOfTapsRequired =1;
    //    轻拍手指个数
    tapGestureRecognizer.numberOfTouchesRequired =1;
    //    讲手势添加到指定的视图上
    
    if (type == 1) {
        UILabel *lab = (UILabel *)view;
        lab.userInteractionEnabled = YES;
        lab.tag = tag;
        [lab addGestureRecognizer:tapGestureRecognizer];
        return lab;
    }else if (type == 2){
        UIImageView *imgV = (UIImageView *)view;
        imgV.userInteractionEnabled = YES;
        imgV.tag = tag;
        [imgV addGestureRecognizer:tapGestureRecognizer];
        return imgV;
    }else if (type == 3){
        UITextView *textV = (UITextView *)view;
        textV.userInteractionEnabled = YES;
        textV.tag = tag;
        [textV addGestureRecognizer:tapGestureRecognizer];
        return textV;
    }
    
    
    return nil;
    
}

- (void)tap:(UITapGestureRecognizer *)ges{
    SYLog(@"联系客服");
    
    //客服
    UIViewController *chatC = [[UIViewController alloc]init];
    
    NSDictionary *response = @{@"":@""};   if (response) {
        
        if ([response[@"code"] intValue] == 200) {
            
            
            [self.navigationController pushViewController:chatC animated:YES];
        }
        else
        {
            
        }
        SYLog(@"客服+++++++++++++WWW++++++++%@",response);
        
    }
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
