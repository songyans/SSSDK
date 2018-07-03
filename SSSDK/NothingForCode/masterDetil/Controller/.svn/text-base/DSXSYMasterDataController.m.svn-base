//
//  DSXSYMasterDataController.m
//  善信
//
//  Created by LQ on 2017/6/2.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYMasterDataController.h"
#import "DSXSYLabelAndTextField.h"
#import "DSXSYAddressController.h"
#import "DSXSYSectController.h"
#import "ShareArea.h"
#import "DSXSYSectModel.h"
#import "DSXSYInputInfoTextController.h"
#import "DSXSYWaitingReviewController.h"



#import "DSXSYMassterDetailTool.h"


//DSXSYGestureRegognizer
@interface DSXSYMasterDataController ()<UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    double  _duration;//键盘弹出收起时间
    CGSize _experSize;//个人经历TextView高度
    CGSize _introSize;//个人介绍TextView高度
    CGSize _addreSize;//详细地址TextView高度
    UILabel *_experPlaceHolderLabel;//自定义占位text
    UILabel *_introPlaceHolderLabel;//自定义占位text
    UILabel *_addressPlaceHolderLabel;//自定义占位text
    UILabel * _experienceLab;
    UILabel *_introduceLab;
    
    NSString *_experienceString;
    NSString *_introduceString;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *monkNameTextField;//法号输入框
@property (nonatomic, strong) UITextField *templeNameTextField;//寺院输入框
@property (nonatomic, strong) UITextField *temoleDutiesTextField;//寺院职务
@property (nonatomic, strong) UITextField *universityTextField;//毕业佛学院
@property (nonatomic, strong) UITextField *educationTextField;//学历
@property (nonatomic, strong) UITextView *addressTextView;//地址
@property (nonatomic, strong) UITextField *phoneNumberTextField;//电话

@property (nonatomic, strong) UILabel *fromFectarianLab;//宗派lab
@property (nonatomic, strong) UILabel *fromSectLab;
@property (nonatomic, strong) UILabel *PhoneNumberLab;
@property (nonatomic, strong) UITextView *experienceTextView;
@property (nonatomic, strong) UITextView *introduceTextView;

@property (nonatomic, strong) UIView *footLine;

@property (nonatomic, strong) NSArray *textFieldArray;//保存textField数组

@property (nonatomic, copy) NSString *addressStr;//地址str
@property (nonatomic, strong) DSXSYSectModel *infoMd;//宗派

@property (nonatomic ,strong)UIButton *BottomBtn;//提交

@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIView *introduceView;

@property (nonatomic, strong) UIImageView *addressImgView;
@property (nonatomic, strong) UILabel *addressDetailLab;
@property (nonatomic, strong) UIImageView *addressArrowImgView;

@property (nonatomic, strong) UIImageView *sectImgView;
//@property (nonatomic, strong) UILabel *sectTitleLab;
@property (nonatomic, strong) UILabel *sectDetailLab;
@property (nonatomic, strong) UIImageView *sectArrowImgView;

@property (nonatomic, assign) BOOL isSubmit;//回调,是否提交成功

//客服

@end

@implementation DSXSYMasterDataController

# pragma mark --------------------------------------------------------------- 懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 324, 234 - 64 - 50)];
        _scrollView.scrollEnabled = YES;
        _scrollView.bounces = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = YES;
//        _scrollView.contentSize = CGSizeMake(123, 123);
    }
    return _scrollView;
}

- (UITextView *)experienceTextView{
    if (!_experienceTextView) {
        _experienceTextView = [DSXSYMassterDetailTool createTextViewWithFontSize:17 TextColor:[UIColor blackColor]];
        _experienceTextView.delegate = self;
        _experPlaceHolderLabel = [DSXSYMassterDetailTool createPlaceholderWithText:_experienceString TextColor:[UIColor whiteColor] FontSize:15 TextAlignment:0];
        [_experienceTextView addSubview:_experPlaceHolderLabel];
    }
    return _experienceTextView;
}

- (UITextView *)introduceTextView{
    if (!_introduceTextView) {
        _introduceTextView = [DSXSYMassterDetailTool createTextViewWithFontSize:17 TextColor:[UIColor blackColor]];
        _introduceTextView.delegate = self;
        _introPlaceHolderLabel = [DSXSYMassterDetailTool createPlaceholderWithText:_experienceString TextColor:[UIColor grayColor] FontSize:15 TextAlignment:0];
        [_introduceTextView addSubview:_introPlaceHolderLabel];
    }
    return _introduceTextView;
}

- (UITextView *)addressTextView{
    if (!_addressTextView) {
        _addressTextView = [[UITextView alloc] init];
//        _addressTextView.frame = CGRectMake(12,0, 123 - 24, 123);
        _addressTextView.backgroundColor = [UIColor clearColor];
        _addressTextView.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
        _addressTextView.editable = YES;        //是否允许编辑内容，默认为“YES”
        _addressTextView.delegate = self;       //设置代理方法的实现类
        _addressTextView.returnKeyType = UIReturnKeyDefault;//return键的类型
        _addressTextView.keyboardType = UIKeyboardTypeDefault;//键盘类型
        _addressTextView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
        _addressTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        _addressTextView.textColor = [UIColor blackColor];
        _addressTextView.tag = 1001;
        _addressTextView.alwaysBounceVertical = YES;
        _addressTextView.font = [UIFont systemFontOfSize:17];
        _addressTextView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
        _addressTextView.layer.borderWidth = 0.6f;
        _addressTextView.layer.cornerRadius = 6.0f;
        
        _addressPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12,324 - 37, 20)];
        _addressPlaceHolderLabel.textAlignment = NSTextAlignmentLeft;
        _addressPlaceHolderLabel.font = [UIFont systemFontOfSize:15];
        _addressPlaceHolderLabel.numberOfLines = 0;
        _addressPlaceHolderLabel.text = @"请输入详细地址";
        [_addressTextView addSubview:_addressPlaceHolderLabel];

    }
    return _addressTextView;
}

- (UIView *)footLine{
    if (_footLine) {
        _footLine = [[UIView alloc] init];
    }
    return _footLine;
}

- (UIImageView *)addressImgView{
    if (!_addressImgView) {
        _addressImgView = [[UIImageView alloc] init];
        _addressImgView = [self createImageView];
    }
    return _addressImgView;
}

- (UIImageView *)sectImgView{
    if (!_sectImgView) {
        _sectImgView = [[UIImageView alloc] init];
        _sectImgView = [self createImageView];
        
    }
    return _sectImgView;
}

- (UIImageView *)createImageView{
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.image = [UIImage imageNamed:@"Input-box"];
    imgV.userInteractionEnabled = YES;
    imgV.backgroundColor = [UIColor grayColor];
    imgV.layer.cornerRadius = 3;
    imgV.layer.masksToBounds = YES;
    return imgV;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"编辑师父资料";
    [self createScrollView];
       [self addTextFieldToArray];
    [self createBottomView];
    self.infoMd = [[DSXSYSectModel alloc] init];
    
    /*
     监听键盘出现和收起
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    /*
     监听textField输入是否发生改变
     */
    [self.monkNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.temoleDutiesTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    /*
     接收通知
     监听textField变化
     没有高亮选择的字，则对已输入的文字进行字数统计和限制
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.monkNameTextField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.temoleDutiesTextField];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.templeNameTextField];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.universityTextField];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.educationTextField];

}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//创建底部button
- (void)createBottomView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 24324-50 - 64, 234234, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    self.BottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.BottomBtn.frame = CGRectMake(12, 5.5+1, 34234-24, 38);
    self.BottomBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [view addSubview:self.BottomBtn];
    [self.BottomBtn addTarget:self action:@selector(bottomClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BottomBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.BottomBtn setBackgroundImage:[UIImage imageNamed:@"btn_button_n"] forState:UIControlStateNormal];
    [self.BottomBtn setBackgroundImage:[UIImage imageNamed:@"btn_button_p"] forState:UIControlStateHighlighted];
    [self.BottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.BottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.BottomBtn.enabled = NO;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14323, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [view addSubview:lineView];
}

//Btn响应时间
- (void)bottomClick{
       /*
     monkNameTextField;//法号输入框
     templeNameTextField;//寺院输入框
     
     universityTextField;//毕业佛学院
     
     addressTextField;//地址
     
     */

    
    /*
     判断条件
     */
    if (self.monkNameTextField.text.length == 0) {
        return;
    }
    
    
    if (self.templeNameTextField.text.length == 0) {
        return;
    }
    
    if (self.universityTextField.text.length == 0) {
        return;
    }

    if (self.addressStr.length == 0) {
        return;
    }

    if (self.addressTextView.text.length == 0) {
        return;
    }
    
    if (self.infoMd.sectarianId == 0) {
        return;
    }

    if (self.experienceTextView.text.length == 0) {
        return;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交后部分信息不可修改,确认提交?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"我再看看" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self postDate];
        
    }];
    [alertController addAction:report];
    [alertController addAction:Cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    

    
    

    
}

//读取数据
- (void)postDate{
    DSXSYWaitingReviewController *wrVC = [[DSXSYWaitingReviewController alloc] init];
    Weak_Self;
    NSString *urlString = @"/api/master/attestation/saveMasterDetail.do";
    //  http://192.168.1.254:8089/shanxin/api/master/attestation/saveMasterDetail.do
    NSString *url = [NSString stringWithFormat:@"%@%@",@"123123",urlString];
    SYLog(@"%@", url);

    NSDictionary *param = @{
                            @"uid"                   : @1213,
                            @"methodNumber"          : self.monkNameTextField.text,
                            @"templeName"            : self.templeNameTextField.text,
                            @"templeDuty"            : self.temoleDutiesTextField.text,
                            @"graduatedCollege"      : self.universityTextField.text,
                            @"maxDiploma"            : self.educationTextField.text,
                            @"templeAddress"         : self.addressStr,
                            @"detailAddress"         : self.addressTextView.text,
                            @"sectarianId"           : @(self.infoMd.sectarianId),
                            @"companyPhone"          : self.phoneNumberTextField.text,
                            @"personalExperience"    : self.experienceTextView.text,
                            @"personalIntroduce"     : self.introduceTextView.text,
                            };
    
    if(param) {
        if ([param[@"sdf"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.isFail) {
                   wrVC.wherePush = 3;
                }else{
                    wrVC.wherePush = 1;
                }
                weakSelf.isSubmit = YES;
                if (weakSelf.IsSubmitBlock) {
                    weakSelf.IsSubmitBlock(weakSelf.isSubmit);
                }
                
                [weakSelf.navigationController pushViewController:wrVC animated:YES];
            });
        }else{
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ShareArea *manager = [ShareArea shareAre];
    if (manager.allPlace.length > 0) {
        self.addressStr = [manager.allPlace stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        manager.allPlace = @"";
    }
    NSLog(@"-----address:%@",self.addressStr);
    NSLog(@"-----infoMd:%@",self.infoMd);
    /*
     判断是否是有提交记录
     判断使用记录还是使用新数据
     */
    if (self.inputModel.templeAddress.length > 0 && self.addressStr.length > 0) {
        self.addressDetailLab.text = self.addressStr;
    }
    if (self.inputModel.templeAddress.length > 0 && self.addressStr.length == 0){
        self.addressDetailLab.text = self.inputModel.templeAddress;
        self.addressStr = self.inputModel.templeAddress;
    }
    if (self.inputModel.templeAddress.length == 0 && self.addressStr.length > 0){
        self.addressDetailLab.text = self.addressStr;
    }
    if (self.inputModel.templeAddress.length == 0 && self.addressStr.length == 0){
        self.addressDetailLab.text = @"请选择";
    }
    
    
    
    if (self.infoMd.sectarianName.length > 0 && self.inputModel.sectarianName.length > 0) {
        self.sectDetailLab.text = self.infoMd.sectarianName;
    }
    if (self.inputModel.sectarianName.length > 0 && self.infoMd.sectarianName.length == 0){
        self.sectDetailLab.text = self.inputModel.sectarianName;
        self.infoMd.sectarianId = self.inputModel.sectarianId;
        self.sectImgView.userInteractionEnabled = NO;
        
    }
    if (self.inputModel.sectarianName.length == 0 && self.infoMd.sectarianName.length > 0){
        self.sectDetailLab.text = self.infoMd.sectarianName;
    }
    if (self.inputModel.sectarianName.length == 0 && self.infoMd.sectarianName.length == 0){
        self.sectDetailLab.text = @"请选择";
        
    }
    
    if (self.addressTextView.text.length > 0 )
    {
        
        if (_addressPlaceHolderLabel != nil) {
            _addressPlaceHolderLabel.text = nil;
        }
        
    }else{
        
        if (_addressPlaceHolderLabel != nil) {
            _addressPlaceHolderLabel.text = @"请输入详细地址";
        }
    }

    
   /*
    改变高度
    */
    _experSize = [self.experienceTextView.text boundingRectWithSize:CGSizeMake(234 - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.experienceTextView.font} context:nil].size;
    _introSize = [self.introduceTextView.text boundingRectWithSize:CGSizeMake(234 - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.introduceTextView.font} context:nil].size;
    
    //
    if (self.experienceTextView.text.length > 0) {
        _experienceString = @"";
//        self.experienceTextView.height = _experSize.height;
    }else{
        _experienceString = @"如：2005.07XXX寺发心出家，2009.06~2011.09浙江普陀山佛学院学习";
        
    }
    _experPlaceHolderLabel.text = _experienceString;
    if (self.introduceTextView.text.length > 0) {
        _introduceString = @"";
//        self.introduceTextView.height = _introSize.height;
    }else{
        _introduceString = @"个人作品、参加过的大型弘法、比赛取得的荣誉、其他等";

    }
    _introPlaceHolderLabel.text = _introduceString;
    
    [self setScrollViewContentSize];
    
    [self ButtonEnabledIsYes];
}


- (void)viewWillDisappear:(BOOL)animated{
//    self.experienceTextView = nil;
//    self.introduceTextView = nil;
}

- (void)addTextFieldToArray{
    /*
     monkNameTextField;//法号输入框
     templeNameTextField;//寺院输入框
     temoleDutiesTextField;//寺院职务
     universityTextField;//毕业佛学院
     educationTextField;//学历
     addressTextField;//地址
     phoneNumberTextField;//电话
     
     , self.addressTextView
     
     */
    
    

     self.textFieldArray = @[self.monkNameTextField ,self.templeNameTextField, self.temoleDutiesTextField, self.universityTextField, self.educationTextField, self.phoneNumberTextField];
}

//
- (void)createScrollView{
    
    
    [self.view addSubview:self.scrollView];
    
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 324, 2342)];
    self.infoView.userInteractionEnabled = YES;
    self.infoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.infoView];
    
    self.introduceView = [[UIView alloc] init];
    self.introduceView.userInteractionEnabled = YES;
    self.introduceView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.introduceView];
   
    

    [self createInfoViewContent];
    [self createIntroduceViewContent];
    
}


- (UIView *)ctreatLineViewWithFloatY:(CGFloat)y{
    UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(0, y, 2342, 0.5)];
    Line.backgroundColor = [UIColor whiteColor];
    return Line;
}


- (void)createInfoViewContent{
    Weak_Self;
    //创建UI
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.image = [UIImage imageNamed:@"img_shifuziliao_bg"];
    [self.infoView addSubview:headerImageView];
    headerImageView.frame = CGRectMake(0, 0, 234, 545 / 2);
 
    
    
    UILabel *noticeLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:Normoal WantChangeColor:nil ChangeTitle:nil Titile:@"表单所示带*号为必填项，所填信息仅为“师父资料”展示所用，审核成功后一个月内不可重复修改，且法号、毕业佛学院及宗派不可修改，请慎重填写。（如需完善或咨询，请在帮助与反馈中联系“一善师兄”）" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    CGSize notLabSize = [noticeLab.text boundingRectWithSize:CGSizeMake(123123 - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : noticeLab.font} context:nil].size;
    noticeLab.frame = CGRectMake(12, headerImageView.height, 12312 - 24, notLabSize.height);
    [self.infoView addSubview:noticeLab];
    
    
    
    UILabel *monkNameLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectMake(12, (noticeLab.height + noticeLab.y) + 20, 123123 - 24, 20) TextColorState:ChangeColor WantChangeColor:[UIColor redColor] ChangeTitle:@"*" Titile:@"* 法号" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.infoView addSubview:monkNameLab];
    
    
    
    self.monkNameTextField = [DSXSYLabelAndTextField createTextFieldWithFrame:CGRectMake(12, (monkNameLab.y + monkNameLab.height) + 10, 123123 - 24, 44) Placeholder:@"请输入法号" TextFiledFontSize:17 BorderStyle:UITextBorderStyleRoundedRect TextColor:[UIColor blackColor] TextFieldBackgroundColor:[UIColor clearColor] KeyboardType:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyDone];
    self.monkNameTextField = [DSXSYLabelAndTextField changePlaceholderState:ChangeFontSizeState Placeholder:nil PlaceholderTextColor:nil PlaceholderTextFontSize:15 ToTextField:self.monkNameTextField];
    self.monkNameTextField.delegate = self;
    [self.infoView addSubview:self.monkNameTextField];
    
    
    
    UILabel *templeNameLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectMake(12, (self.monkNameTextField.y + self.monkNameTextField.height) + 20, 12321 - 24, 20) TextColorState:ChangeColor WantChangeColor:[UIColor redColor] ChangeTitle:@"*" Titile:@"* 寺院名称" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.infoView addSubview:templeNameLab];
    
    
    
    self.templeNameTextField = [DSXSYLabelAndTextField createTextFieldWithFrame:CGRectZero Placeholder:@"请输入常住寺院/精舍名称" TextFiledFontSize:17 BorderStyle:UITextBorderStyleRoundedRect TextColor:[UIColor blackColor] TextFieldBackgroundColor:[UIColor redColor] KeyboardType:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyDone];
    self.templeNameTextField = [DSXSYLabelAndTextField changePlaceholderState:ChangeFontSizeState Placeholder:nil PlaceholderTextColor:nil PlaceholderTextFontSize:15 ToTextField:self.templeNameTextField];
    self.templeNameTextField.delegate = self;
    [self.infoView addSubview:self.templeNameTextField];
    
    
    
    UILabel *templeDutiesLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:Normoal WantChangeColor:nil ChangeTitle:nil Titile:@"寺院职务" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.infoView addSubview:templeDutiesLab];
    
    
    
    self.temoleDutiesTextField = [DSXSYLabelAndTextField createTextFieldWithFrame:CGRectZero Placeholder:@"主持、首座、堂主、监院、知客等" TextFiledFontSize:17 BorderStyle:UITextBorderStyleRoundedRect TextColor:[UIColor blackColor] TextFieldBackgroundColor:[UIColor redColor] KeyboardType:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyDone];
    self.temoleDutiesTextField = [DSXSYLabelAndTextField changePlaceholderState:ChangeFontSizeState Placeholder:nil PlaceholderTextColor:nil PlaceholderTextFontSize:15 ToTextField:self.temoleDutiesTextField];
    self.temoleDutiesTextField.delegate = self;
    [self.infoView addSubview:self.temoleDutiesTextField];
    
    
    
    UILabel *universityLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:ChangeColor WantChangeColor:[UIColor redColor] ChangeTitle:@"*" Titile:@"* 毕业佛学院" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.infoView addSubview:universityLab];
    
    
    
    self.universityTextField = [DSXSYLabelAndTextField createTextFieldWithFrame:CGRectZero Placeholder:@"请输入毕业佛学院" TextFiledFontSize:17 BorderStyle:UITextBorderStyleRoundedRect TextColor:[UIColor blackColor] TextFieldBackgroundColor:[UIColor redColor] KeyboardType:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyDone];
    self.universityTextField = [DSXSYLabelAndTextField changePlaceholderState:ChangeFontSizeState Placeholder:nil PlaceholderTextColor:nil PlaceholderTextFontSize:15 ToTextField:self.universityTextField];
    self.universityTextField.delegate = self;
    [self.infoView addSubview:self.universityTextField];
    
    
    
    UILabel *educationLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:Normoal WantChangeColor:nil ChangeTitle:nil Titile:@"最高学历" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.infoView addSubview:educationLab];
    
    
    
    self.educationTextField = [DSXSYLabelAndTextField createTextFieldWithFrame:CGRectZero Placeholder:@"请输入最高学历" TextFiledFontSize:17 BorderStyle:UITextBorderStyleRoundedRect TextColor:[UIColor blackColor] TextFieldBackgroundColor:[UIColor redColor] KeyboardType:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyDone];
    self.educationTextField = [DSXSYLabelAndTextField changePlaceholderState:ChangeFontSizeState Placeholder:nil PlaceholderTextColor:nil PlaceholderTextFontSize:15 ToTextField:self.educationTextField];
    self.educationTextField.delegate = self;
    [self.infoView addSubview:self.educationTextField];
    
    
    
    UILabel *addressLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:ChangeColor WantChangeColor:[UIColor redColor] ChangeTitle:@"*" Titile:@"* 寺院/精舍地址" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.infoView addSubview:addressLab];
    
    
    
    [self.infoView addSubview:self.addressImgView];
    self.addressImgView = [self addGestureRecognizerToView:self.addressImgView Tag:100 Type:2];
//    self.addressImgView = [DSXSYMassterDetailTool addGestureRecognizerToView:self.addressImgView Tag:100 Type:2 Completion:^(UITapGestureRecognizer *tap) {
//        DSXSYAddressController *addressVC = [[DSXSYAddressController alloc] init];
//        [weakSelf.navigationController pushViewController:addressVC animated:YES];
//        }];

    

    self.addressArrowImgView = [self createImgViewWithImgName:@"icon_enter_gary"];
    [self.addressImgView addSubview:self.addressArrowImgView];
    
    

    UILabel *addressTitleLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:Normoal WantChangeColor:nil ChangeTitle:nil Titile:@"选择地区" FontSize:17 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.addressImgView addSubview:addressTitleLab];
    
    
    
    self.addressDetailLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero FontSize:14 TextColor:[UIColor redColor] TextAlignment:2];
    [self.addressImgView addSubview:self.addressDetailLab];
    
    /*
     
     self.addressTextField = [DSXSYLabelAndTextField createTextFieldWithFrame:CGRectZero Placeholder:@"请输入详细地址" TextFiledFontSize:17 BorderStyle:UITextBorderStyleRoundedRect TextColor:[UIColor blackColor] TextFieldBackgroundColor:[UIColor redColor] KeyboardType:UIKeyboardTypeDefault ReturnKeyType:UIReturnKeyDone];
     self.addressTextField = [DSXSYLabelAndTextField changePlaceholderState:ChangeFontSizeState Placeholder:nil PlaceholderTextColor:nil PlaceholderTextFontSize:15 ToTextField:self.addressTextField];
     self.addressTextField.delegate = self;
     [self.infoView addSubview:self.addressTextField];
     
     */
   
    [self.infoView addSubview:self.addressTextView];
//    _addressPlaceHolderLabel = [self createPlaceholderWithText:@"请输入详细地址"];
//    [self.addressTextView addSubview:_addressPlaceHolderLabel];
    
   
    
    self.fromSectLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:ChangeColor WantChangeColor:[UIColor redColor] ChangeTitle:@"*" Titile:@"* 所属宗派" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.infoView addSubview:self.fromSectLab];
    
    
    
    [self.infoView addSubview:self.sectImgView];
    self.sectImgView = [self addGestureRecognizerToView:self.sectImgView Tag:101 Type:2];
    
    
    UILabel *sectLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:Normoal WantChangeColor:nil ChangeTitle:nil Titile:@"选择宗派" FontSize:17 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.sectImgView addSubview:sectLab];
    if (self.inputModel.sectarianId > 0) {
        sectLab.textColor = [UIColor redColor];
    }
    
    
    
    self.sectArrowImgView = [self createImgViewWithImgName:@"icon_enter_gary"];
    [self.sectImgView addSubview:self.sectArrowImgView];
    
    
    
    self.sectDetailLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero FontSize:14 TextColor:[UIColor redColor] TextAlignment:2];
    [self.sectImgView addSubview:self.sectDetailLab];
    
    
    
    self.fromFectarianLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:ChangeColor WantChangeColor:[UIColor redColor] ChangeTitle:@"联系客服" Titile:@"没有你的宗派？联系客服" FontSize:12 TextColor:[UIColor blackColor] TextAlignment:2];
    self.fromFectarianLab.tag = 10010;
    self.fromFectarianLab.userInteractionEnabled = YES;
    [self.infoView addSubview:self.fromFectarianLab];
    self.fromFectarianLab = [self addGestureRecognizerToView:self.fromFectarianLab Tag:10010 Type:1];
    
    
    
    self.PhoneNumberLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:Normoal WantChangeColor:nil ChangeTitle:nil Titile:@"客堂电话" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.infoView addSubview:self.PhoneNumberLab];
    
    
    
    self.phoneNumberTextField = [DSXSYLabelAndTextField createTextFieldWithFrame:CGRectZero Placeholder:@"请输入客堂电话" TextFiledFontSize:17 BorderStyle:UITextBorderStyleRoundedRect TextColor:[UIColor blackColor] TextFieldBackgroundColor:[UIColor redColor] KeyboardType:UIKeyboardTypePhonePad ReturnKeyType:UIReturnKeyDone];
    self.phoneNumberTextField = [DSXSYLabelAndTextField changePlaceholderState:ChangeFontSizeState Placeholder:nil PlaceholderTextColor:nil PlaceholderTextFontSize:15 ToTextField:self.phoneNumberTextField];
    self.phoneNumberTextField.delegate = self;
    [self.infoView addSubview:self.phoneNumberTextField];
    
    
    
    //布局
    self.templeNameTextField.frame = CGRectMake(12, (templeNameLab.y + templeNameLab.height) + 10, 123 - 24, 44);
    
    templeDutiesLab.frame = CGRectMake(12, (self.templeNameTextField.y + self.templeNameTextField.height) + 20,123 - 24, 20);
    
    self.temoleDutiesTextField.frame = CGRectMake(12, (templeDutiesLab.y + templeDutiesLab.height) + 10, 123 - 24, 44);
    
    universityLab.frame = CGRectMake(12, (self.temoleDutiesTextField.y + self.temoleDutiesTextField.height) + 20,123 - 24, 20);
    
    self.universityTextField.frame = CGRectMake(12, (universityLab.y + universityLab.height) + 10, 123 - 24, 44);
    
    educationLab.frame = CGRectMake(12, (self.universityTextField.y + self.universityTextField.height) + 20,123 - 24, 20);
    
    self.educationTextField.frame = CGRectMake(12, (educationLab.y + educationLab.height) + 10, 123 - 24, 44);
    
    addressLab.frame = CGRectMake(12, (self.educationTextField.y + self.educationTextField.height) + 20, 123 - 24, 20);
    
    self.addressImgView.frame = CGRectMake(12, (addressLab.y + addressLab.height) + 10, 123 - 24, 44);
    
    
    [self setValueForTextField];
    [self setInfoViewHeight];

    [addressTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressImgView).offset(5);
        make.centerY.mas_equalTo(weakSelf.addressImgView.centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(123 / 2, 20));
    }];
    
    [self.addressArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.addressImgView).offset(-12);
        make.centerY.equalTo(weakSelf.addressImgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.addressDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressTitleLab.mas_right).offset(0);
        make.right.equalTo(weakSelf.addressArrowImgView.mas_left).offset(-5);
        make.centerY.mas_equalTo(weakSelf.addressImgView).offset(0);
    }];
    
    [sectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.sectImgView).offset(5);
        make.centerY.mas_equalTo(weakSelf.sectImgView.centerY).offset(0);
        make.size.mas_equalTo(CGSizeMake(123 / 2, 20));
    }];
    
    [self.sectArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.sectImgView).offset(-12);
        make.centerY.equalTo(weakSelf.sectImgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.sectDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectLab.mas_right).offset(0);
        make.right.equalTo(weakSelf.sectArrowImgView.mas_left).offset(-5);
        make.centerY.equalTo(weakSelf.sectImgView).offset(0);
    }];
    
  
   
    self.infoView.height = (self.phoneNumberTextField.y + self.phoneNumberTextField.height + 15);

}

/*
 *读取记录,如果有记录就给textField赋值
 *部分textField不允许更改
 */
- (void)setValueForTextField{
    
    /*
     monkNameTextField;//法号输入框
     templeNameTextField;//寺院输入框
     temoleDutiesTextField;//寺院职务
     universityTextField;//毕业佛学院
     educationTextField;//学历
     addressTextField;//地址
     phoneNumberTextField;//电话
     */

    if (self.inputModel.methodNumber.length > 0) {
        self.monkNameTextField.text = self.inputModel.methodNumber;
        self.monkNameTextField.enabled = NO;
        self.monkNameTextField.textColor = [UIColor redColor];
    }
    
    if (self.inputModel.graduatedCollege.length > 0) {
        self.universityTextField.text = self.inputModel.graduatedCollege;
        self.universityTextField.enabled = NO;
        self.universityTextField.textColor = [UIColor redColor];

    }
    
    if (self.inputModel.companyPhone.length > 0) {
        self.phoneNumberTextField.text = self.inputModel.companyPhone;
    }
    
    if (self.inputModel.detailAddress.length > 0) {
        self.addressTextView.text = self.inputModel.detailAddress;
    }
    

    if (self.inputModel.maxDiploma.length > 0) {
        self.educationTextField.text = self.inputModel.maxDiploma;
    }
    
    if (self.inputModel.templeName.length > 0) {
        self.templeNameTextField.text = self.inputModel.templeName;
    }
    
    if (self.inputModel.templeDuty.length > 0) {
        self.temoleDutiesTextField.text = self.inputModel.templeDuty;
    }
    
    if (self.inputModel.personalExperience.length > 0) {
        self.experienceTextView.text = self.inputModel.personalExperience;
    }
    
    if (self.inputModel.personalIntroduce.length > 0) {
        self.introduceTextView.text = self.inputModel.personalIntroduce;
    }
}



/*
 InfoView的高度
 自适应
 */
- (void)setInfoViewHeight{
    
     self.addressTextView.frame = CGRectMake(12, (self.addressImgView.y + self.addressImgView.height) + 10, 123 - 24, (_addreSize.height < 44 ? 44 : _addreSize.height + 10));
    
    self.fromSectLab.frame = CGRectMake(12, (self.addressTextView.y + self.addressTextView.height) + 20, 123 - 24, 20);
    
    self.sectImgView.frame = CGRectMake(12, (self.fromSectLab.y + self.fromSectLab.height) + 10, 123 - 24, 44);
    
    self.fromFectarianLab.frame = CGRectMake(12, (self.sectImgView.y + self.sectImgView.height) + 10, 123 - 24, 20);
    
    self.PhoneNumberLab.frame = CGRectMake(12, (self.fromFectarianLab.y + self.fromFectarianLab.height) + 15, 123 - 24, 20);
    
    self.phoneNumberTextField.frame = CGRectMake(12, (self.PhoneNumberLab.y + self.PhoneNumberLab.height) + 10, 123 - 24, 44);
    self.footLine = [self ctreatLineViewWithFloatY:(self.phoneNumberTextField.y + self.phoneNumberTextField.height + 14.5)];
    [self.infoView addSubview:self.footLine];
}



//IntroduceView
- (void)createIntroduceViewContent{
   //UI
    self.introduceView.frame = CGRectMake(0, (self.infoView.height + self.infoView.y + 15), 123, 123);
    
    UIView *headLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 123, 0.5)];
    headLine.backgroundColor = [UIColor redColor];
    [self.introduceView addSubview:headLine];
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, 123, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.introduceView addSubview:titleView];
    
    UILabel *titleLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectMake(12, 10, 123 - 12, 20) FontSize:14 TextColor:[UIColor redColor] TextAlignment:0];
    titleLab.text = @"师父简介";
    [titleView addSubview:titleLab];
    
    UIView *titleFootLine = [self ctreatLineViewWithFloatY:(titleView.height)];
    [self.introduceView addSubview:titleFootLine];
    
    _experienceLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectMake(12, (titleFootLine.y + titleFootLine.height + 20), 123 - 24, 20) TextColorState:ChangeColor WantChangeColor:[UIColor redColor] ChangeTitle:@"*" Titile:@"* 个人经历" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.introduceView addSubview:_experienceLab];
    
    
    [self.introduceView addSubview:self.experienceTextView];
    
    
    _introduceLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:Normoal WantChangeColor:nil ChangeTitle:nil Titile:@"个人介绍" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    [self.introduceView addSubview:_introduceLab];
    
    
    [self.introduceView addSubview:self.introduceTextView];
   
    
    [self setScrollViewContentSize];
    self.experienceTextView = [self addGestureRecognizerToView:self.experienceTextView Tag:200 Type:3];
    self.introduceTextView = [self addGestureRecognizerToView:self.introduceTextView Tag:201 Type:3];

    
}


/*
 设置ScrollViewContentSize
 根据内容改变自适应
 */
- (void)setScrollViewContentSize{
    self.experienceTextView.frame = CGRectMake(12, (_experienceLab.y + _experienceLab.height + 10), 123 - 24, _experSize.height < 68 ? 68 : _experSize.height + 50);
    
    _introduceLab.frame = CGRectMake(12, (self.experienceTextView.height + self.experienceTextView.y + 15), 123 - 224, 20);
    
    self.introduceTextView.frame = CGRectMake(12, (_introduceLab.y + _introduceLab.height + 10), 123 - 24, _introSize.height < 68 ? 68 : _introSize.height + 50);
    
    
    self.introduceView.height = (self.introduceTextView.y + self.introduceTextView.height + 100);
    
    self.scrollView.contentSize = CGSizeMake(123, (self.introduceView.height + self.introduceView.y));
    

}




//imgView
- (UIImageView *)createImgViewWithImgName:(NSString *)imgName{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:imgName];
    return imgView;
}


/*
 添加手势
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


- (void)tap:(UITapGestureRecognizer *)sender{
    Weak_Self;
    DSXSYInputInfoTextController *inputVC = [[DSXSYInputInfoTextController alloc] init];
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger tag = tap.view.tag;
    if (tag == 100) {
        SYLog(@"111");
        DSXSYAddressController *addressVC = [[DSXSYAddressController alloc] init];
        [self.navigationController pushViewController:addressVC animated:YES];
    }else if (tag == 101){
        DSXSYSectController *sectVC = [[DSXSYSectController alloc] init];
        sectVC.SectBlock = ^(DSXSYSectModel *info) {
            weakSelf.infoMd = info;
            weakSelf.inputModel.sectarianId = weakSelf.infoMd.sectarianId;
        };
        
        [self.navigationController pushViewController:sectVC animated:YES];
        SYLog(@"222");
    }else if (tag == 200){
        inputVC.textViewType = 1;
        inputVC.placeholderString = _experienceString;
        inputVC.texiViewString = self.experienceTextView.text;
        inputVC.TextViewBlock = ^(NSString *text, int textType) {
            if (text.length > 0) {
                if (textType == 1) {
                    weakSelf.experienceTextView.text = text;
                    
                }
            }
        };

        [self.navigationController pushViewController:inputVC animated:YES];
    }else if (tag == 201){
        inputVC.textViewType = 2;
        inputVC.placeholderString = _introduceString;
        inputVC.texiViewString = self.introduceTextView.text;
        inputVC.TextViewBlock = ^(NSString *text, int textType) {
            if (text.length > 0) {
                if (textType == 2) {
                    weakSelf.introduceTextView.text = text;
                }
            }
        };
        [self.navigationController pushViewController:inputVC animated:YES];

    }else if (tag == 10010){
        SYLog(@"10010");
//        //客服
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"123123response",@"123123"];
        NSDictionary *response = @{
                                   @"" : @"",
                                   };
        if (urlStr) {
            
            UIViewController *chatC = [[UIViewController alloc] init];
//                NSDictionary *dic = response[@"data"];
        [self.navigationController pushViewController:chatC animated:YES];
            SYLog(@"客服+++++++++++++WWW++++++++%@",response);
            
        }
    }
}

# pragma mark --------------------------------------------------------------- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    UITextField *textField = [self witchTextFieldIsFirstResponder];
    if (textField.isFirstResponder) {
        [textField resignFirstResponder];
    }
    if (self.addressTextView.isFirstResponder) {
        [self.addressTextView resignFirstResponder];
    }
    SYLog(@"用户滑动屏幕");
}


/*
 判断是哪个textField响应
 */
- (UITextField *)witchTextFieldIsFirstResponder{
    UITextField *text = [[UITextField alloc] init];
    for (int i = 0; i < self.textFieldArray.count; i++) {
        text = self.textFieldArray[i];
        if (text.isFirstResponder) {
            return text;
            
        }
    }
    return text;
}

# pragma mark --------------------------------------------------------------- UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    SYLog(@"开始编辑");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField = [self witchTextFieldIsFirstResponder];
    if (textField.isFirstResponder) {
        [textField resignFirstResponder];
    }
    
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField == self.monkNameTextField) {
        if (textField.text.length > 15) {

        }
    }
    else if (textField == self.temoleDutiesTextField){
        if (textField.text.length > 10) {
     
        }
    }else{
        if (textField.text.length > 15) {
     
        }
    }
     
    if (textField == self.phoneNumberTextField) {
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
    
    [self ButtonEnabledIsYes];
}



/*输入框输入的文字限制*/

-(void)textFieldEditChanged:(NSNotification *)obj{
    
    /*
     monkNameTextField;//法号输入框
     templeNameTextField;//寺院输入框
     universityTextField;//毕业佛学院
     educationTextField;//学历
     phoneNumberTextField;//电话
     */
    
    UITextField *textField = (UITextField *)obj.object;
    if (textField == self.temoleDutiesTextField) {
        [DSXSYMassterDetailTool limitTextLengthFor:textField length:10];
    }else if(textField == self.monkNameTextField || textField == self.templeNameTextField || textField == self.universityTextField || textField == self.educationTextField){
        [DSXSYMassterDetailTool limitTextLengthFor:textField length:15];
    }
}



# pragma mark --------------------------------------------------------------- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0 )
    {
       
        if (_addressPlaceHolderLabel != nil) {
            _addressPlaceHolderLabel.text = nil;
        }
        
    }else{
       
        if (_addressPlaceHolderLabel != nil) {
            _addressPlaceHolderLabel.text = @"请输入详细地址";
        }
    }
    
    [self ButtonEnabledIsYes];
    
    NSString *toBeString = textView.text;
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > 50)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:50];
            if (rangeIndex.length == 1)
            {
                textView.text = [toBeString substringToIndex:50];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 50)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    _addreSize = [textView.text boundingRectWithSize:CGSizeMake(123 - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.addressTextView.font} context:nil].size;
   
    [self setInfoViewHeight];
    self.infoView.height = (self.phoneNumberTextField.y + self.phoneNumberTextField.height + 15);

    self.introduceView.y = (self.infoView.y + self.infoView.height) + 15;
   
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
    
//    NSDictionary *userInfo = [note userInfo];
//    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboard = [value CGRectValue];
//    _keyboard = keyboard.size.height;
    UITextField *textField = [self witchTextFieldIsFirstResponder];
    if (textField.isFirstResponder) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    }
    
    SYLog(@"y:- %f --- h:- %f",keyBoardRect.origin.y, keyBoardRect.size.height);
   
    if (self.addressTextView.isFirstResponder) {
        // 修改transform
        [UIView animateWithDuration:_duration animations:^{
            SYLog(@"________%f", self.scrollView.contentOffset.y - 123);
            if (self.scrollView.contentOffset.y < (123 + (123 / 2) - 100)) {
                self.scrollView.contentOffset = CGPointMake(0, self.addressTextView.y - 90);
            }else if (self.scrollView.contentOffset.y == (123 + (123 / 2))){
                self.scrollView.contentOffset = CGPointMake(0, self.addressTextView.y - 90);
            }
            
        }];

    }
 
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
//    if (self.textView.isFirstResponder) {
//        self.tableView.y = 0;
//    }
    [UIView animateWithDuration:_duration animations:^{
        
        self.scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    if (self.experienceTextView.isFirstResponder) {
        
    }
    
}

- (void)ButtonEnabledIsYes{
    if ((self.monkNameTextField.text.length > 0) && (self.templeNameTextField.text.length > 0) && (self.universityTextField.text.length > 0) && (self.addressTextView.text.length > 0) && (self.addressStr.length > 0) && (self.infoMd.sectarianId > 0) && (self.experienceTextView.text.length > 0)) {
        self.BottomBtn.enabled = YES;
    }else{
        self.BottomBtn.enabled = NO;
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SYLog(@"------移除通知");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
