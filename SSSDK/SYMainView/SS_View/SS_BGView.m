//
//  AYAYBGView.m
//  AYSDK
//
//  Created by songyan on 2017/8/28.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "SS_BGView.h"

@interface SS_BGView ()<UITextFieldDelegate>
{
    BOOL _isShowInfo;
}
@property (nonatomic, strong) UIButton *cleanDevice;

@property (nonatomic, strong) UIView *cleanDeviceInfoView;

@property (nonatomic, strong) UILabel *deviceDetailLabel;

@property (nonatomic, strong) UILabel *idfaDetailLabel;

@property (nonatomic, strong) UILabel *schemeDetailLabel;


//@property (nonatomic, strong) UITextField *deviceDetailField;

@property (nonatomic, assign) int countForCleanInfo;

@property (nonatomic, strong) UIImageView *securityImage;

@property (nonatomic, strong) UIImageView *bgViewImg;


@end

@implementation SS_BGView

/**
 * init BGView
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0.94 alpha:1];
//        self.backgroundColor = [UIColor whiteColor];
        [self initAYBGView];
        
    }
    return self;
}


- (id)initWithShowImage:(BOOL)isShow showBGView:(BOOL)isShowBG{
    self = [super init];
    if (self) {
        [self initAYBGView];
        self.securityImage.hidden = !isShow;
        self.bgViewImg.hidden = !isShowBG;
    }
    
    return self;
}

- (id)initWithShowImage:(BOOL)isShow showBGView:(BOOL)isShowBG showCleanView:(BOOL)isShowCleanView{
    self = [super init];
    if (self) {
        
        _isShowInfo = isShowCleanView;
        [self initAYBGView];
        self.securityImage.hidden = !isShow;
        self.bgViewImg.hidden = !isShowBG;
    }
    
    return self;
}


- (void)initAYBGView{
    self.userInteractionEnabled = YES;
    
    if ([[SS_SDKBasicInfo sharedSS_SDKBasicInfo] directionNumber] == 0) {
        if ([[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5S"] || [[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5C"] || [[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5"]){
            self.frame = CGRectMake(0, 0, 300, 280);
            
        }else{
            self.frame = CGRectMake(0, 0, 325, 280);
            
        }
    }else{
        if ([[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5S"] || [[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5C"] || [[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_5"]){
            self.frame = CGRectMake(0, 0, 300, 280);
            
        }else{
            self.frame = CGRectMake(0, 0, 325, 280);
            
        }
        
    }
    CGPoint point = CGPointMake(Screen_Width / 2, Screen_Height / 2);
    self.center = point;
    
    self.bgViewImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [self.bgViewImg setImage:get_BundleImage(@"BG")];
    self.bgViewImg.userInteractionEnabled = YES;
    [self addSubview:self.bgViewImg];
    
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    CGFloat imageSize = 30;
    
    self.securityImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - imageSize - 15, 10, imageSize, imageSize)];
    self.securityImage.userInteractionEnabled = YES;
    //self.securityImage.backgroundColor = [UIColor redColor];
    
    
    [self addSubview:self.securityImage];
    if (!self.securityImage.isHidden) {
        [self.securityImage setImage:get_BundleImage(@"ling")];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchClick:)];
        [self.securityImage addGestureRecognizer:tapGR];
    }
    if (_isShowInfo) {
        [self createView];
    }
}

- (void)createView{
    self.cleanDevice = [SS_PublicTool createBtnWithButton:self.cleanDevice buttonType:UIButtonTypeSystem frame:CGRectZero backgroundColor:SYNOColor image:nil normalTitle:nil selectedTitle:nil highlightTitle:nil textAlignment:1 selected:NO titleNormalColor:SYNOColor titleSelectedColor:SYNOColor titleHighlightedColor:SYNOColor];
    self.cleanDevice.enabled = YES;
    [self.cleanDevice addTarget:self action:@selector(showInfoViewClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cleanDevice];
    [self.cleanDevice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)touchClick:(UITapGestureRecognizer *)tap{
    
    NSURL *storeURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id1314361976?mt=8"];
    
    if ([[UIApplication sharedApplication] canOpenURL:storeURL]){
        [[UIApplication sharedApplication] openURL:storeURL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                SYLog(@"跳转到App Store");
            }
        }];
    }
    
}

- (void)showInfoViewClick{
    self.countForCleanInfo++;
    SYLog(@"countForCleanInfo : %d", self.countForCleanInfo);
    if (self.countForCleanInfo == 8) {
        [self addSubview:self.cleanDeviceInfoView];
        [UIView animateWithDuration:.2f animations:^{
            self.cleanDeviceInfoView.alpha = 1.0f;
        }];
        self.countForCleanInfo = 0;
        self.cleanDevice.enabled = NO;
    }
}

- (void)cleanClick{
    [self rebuildInfo];
    if (![self.deviceDetailLabel.text isEqualToString:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid]) {
        //        self.deviceDetailLabel.text = [SDKInfo sharedSDKInfo].uuid;
        [UIView animateWithDuration:.2f animations:^{
            if (self.CleanDeviceBlock) {
                self.CleanDeviceBlock(YES);
            }
        } completion:^(BOOL finished) {
            
            self.cleanDevice.enabled = YES;
            self.cleanDeviceInfoView.alpha = 0.0f;
            [self.cleanDeviceInfoView removeFromSuperview];
            self.cleanDeviceInfoView = nil;
        }];
        
    }else{
        if (self.CleanDeviceBlock) {
            self.CleanDeviceBlock(NO);
        }
    }
    
}

- (void)backClick{
    SYLog(@"返回");
    [UIView animateWithDuration:.2f animations:^{
        self.cleanDevice.enabled = YES;
        self.cleanDeviceInfoView.alpha = 0.0f;
        [self.cleanDeviceInfoView removeFromSuperview];
        self.cleanDeviceInfoView = nil;
    } completion:^(BOOL finished) {
        
       
    }];
}



- (void)rebuildInfo{
    [KeyChainWrapper delete:@"uuid"];
    [SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid = [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] getUUID];
    [KeyChainWrapper save:SS_UserName_Fast data:nil];
    [KeyChainWrapper save:SS_Password_Fast data:nil];
    [KeyChainWrapper save:SSUsernameKey data:nil];
    [KeyChainWrapper save:SSPasswordKey data:nil];
    [KeyChainWrapper save:SYMobilTokenKey data:nil];
    [SS_PublicTool saveFirstOpen:NO];
    [SS_PublicTool firstOpenApplication:NO];
    [SS_PublicTool useToTouristLogin:NO];
    [SS_PublicTool saveActivateFlag:NO];
}


- (UILabel *)createLabelWithText:(NSString *)text{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textAlignment = 0;
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

- (UILabel *)createLabelWithText:(NSString *)text tag:(NSInteger)tag{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:12];
    label.tag = tag;
    label.textColor = [UIColor redColor];
    label.userInteractionEnabled = YES;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.borderWidth = .5f;
    //    长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    //用几个手指触屏，默认1
    longPressGesture.numberOfTouchesRequired = 1;
    //设置最短长按时间，单位为秒（默认0.5）
    longPressGesture.minimumPressDuration = .5f;
    //设置手势识别期间所允许的手势可移动范围
    longPressGesture.allowableMovement = 10;
    [label addGestureRecognizer:longPressGesture];
 
    return label;
}

- (void)addGestureRecognizerForLabel:(UILabel *)label{
    
    
}

- (void)longPressClick:(UILongPressGestureRecognizer *)press{
    
    if(press.state == UIGestureRecognizerStateBegan){
        NSLog(@"长按手势开始响应!");
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        switch (press.view.tag) {
            case 100:
            {
                pasteboard.string = self.deviceDetailLabel.text;
                if ([pasteboard.string isEqualToString:self.deviceDetailLabel.text]) {
                    [SS_PublicTool showHUDWithViewController:self.vc Text:@"复制成功"];
                }
            }
                break;
                
            case 101:
            {
                pasteboard.string = self.idfaDetailLabel.text;
                if ([pasteboard.string isEqualToString:self.idfaDetailLabel.text]) {
                    [SS_PublicTool showHUDWithViewController:self.vc Text:@"复制成功"];
                }
            }
                break;
                
            case 102:
            {
                pasteboard.string = self.schemeDetailLabel.text;
                if ([pasteboard.string isEqualToString:self.schemeDetailLabel.text]) {
                    [SS_PublicTool showHUDWithViewController:self.vc Text:@"复制成功"];
                }
            }
                break;
                
            default:
                break;
        }
        
        SYLog(@"-----复制");
    }else if (press.state == UIGestureRecognizerStateChanged){
        NSLog(@"长按手势状态发生改变!");
    }else{
        NSLog(@"长按手势结束!");
    }
    
    
   
}


- (UITextField *)createTextFieldWithText:(NSString *)text{
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    
    textField.text =  text;
    textField.textColor = [UIColor redColor];
    textField.font = [UIFont systemFontOfSize:12];
    return textField;
    

}


- (void)createDeviceInfoUI{
    UILabel *deviceInfoLabel = [self createLabelWithText:@"设备号 :"];
    self.deviceDetailLabel = [self createLabelWithText:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid tag:100];
//    [self addGestureRecognizerForLabel:self.deviceDetailLabel];
//    UITextField *deviceDetailField = [self createTextFieldWithText:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].uuid];
    

    UILabel *idfaLabel = [self createLabelWithText:@"IDFA :"];
    self.idfaDetailLabel = [self createLabelWithText:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfa tag:101];
//    [self addGestureRecognizerForLabel:self.idfaDetailLabel];
//    UITextField *idfaDetailTextField = [self createTextFieldWithText:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfa];
    
    UILabel *schemeLabel = [self createLabelWithText:@"URL Scheme :"];
    self.schemeDetailLabel = [self createLabelWithText:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].urlScheme tag:102];
//    [self addGestureRecognizerForLabel:self.schemeDetailLabel];
//    UITextField *schemeDetailTextField = [self createTextFieldWithText:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].urlScheme];
    
    UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cleanBtn setBackgroundColor:button_Color];
    [cleanBtn setTitleColor:SYWhiteColor forState:UIControlStateNormal];
    [cleanBtn setTitleColor:SYWhiteColor forState:UIControlStateHighlighted];
    [cleanBtn setTitle:@"清除设备号" forState:UIControlStateNormal];
    [cleanBtn setTitle:@"清除设备号" forState:UIControlStateHighlighted];
    [cleanBtn addTarget:self action:@selector(cleanClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setBackgroundColor:code_Color];
    [backBtn setTitleColor:SYWhiteColor forState:UIControlStateNormal];
    [backBtn setTitleColor:SYWhiteColor forState:UIControlStateHighlighted];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];

    [self.cleanDeviceInfoView addSubview:deviceInfoLabel];
    [self.cleanDeviceInfoView addSubview:self.deviceDetailLabel];
    [self.cleanDeviceInfoView addSubview:idfaLabel];
    [self.cleanDeviceInfoView addSubview:self.idfaDetailLabel];
    [self.cleanDeviceInfoView addSubview:schemeLabel];
    [self.cleanDeviceInfoView addSubview:self.schemeDetailLabel];
    [self.cleanDeviceInfoView addSubview:cleanBtn];
    [self.cleanDeviceInfoView addSubview:backBtn];
    
    [deviceInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cleanDeviceInfoView).offset(10);
        make.left.equalTo(self.cleanDeviceInfoView).offset(20);
        make.size.mas_equalTo(CGSizeMake(self.cleanDeviceInfoView.width - 40, 20));
    }];
    
    [self.deviceDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceInfoLabel.mas_bottom).offset(3);
        make.left.equalTo(self.cleanDeviceInfoView).offset(20);
        make.size.mas_equalTo(CGSizeMake(self.cleanDeviceInfoView.width - 40, 20));
    }];
    
    [idfaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.deviceDetailLabel.mas_bottom).offset(10);
        make.left.equalTo(self.cleanDeviceInfoView).offset(20);
        make.size.mas_equalTo(CGSizeMake(self.cleanDeviceInfoView.width - 40, 20));
    }];

    [self.idfaDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idfaLabel.mas_bottom).offset(3);
        make.left.equalTo(self.cleanDeviceInfoView).offset(20);
        make.size.mas_equalTo(CGSizeMake(self.cleanDeviceInfoView.width - 40, 20));
    }];

    [schemeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idfaDetailLabel.mas_bottom).offset(10);
        make.left.equalTo(self.cleanDeviceInfoView).offset(20);
        make.size.mas_equalTo(CGSizeMake(self.cleanDeviceInfoView.width - 40, 20));
    }];

    [self.schemeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(schemeLabel.mas_bottom).offset(3);
        make.left.equalTo(self.cleanDeviceInfoView).offset(20);
        make.size.mas_equalTo(CGSizeMake(self.cleanDeviceInfoView.width - 40, 20));
    }];

    [cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.schemeDetailLabel.mas_bottom).offset(15);
        make.left.equalTo(self.cleanDeviceInfoView).offset(20);
        make.size.mas_equalTo(CGSizeMake((self.cleanDeviceInfoView.width - 40) / 2 - 10, 30));
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.schemeDetailLabel.mas_bottom).offset(15);
        make.right.equalTo(self.cleanDeviceInfoView).offset(-20);
        make.size.mas_equalTo(CGSizeMake((self.cleanDeviceInfoView.width - 40) / 2 - 10, 30));
    }];
}

- (UIView *)cleanDeviceInfoView{
    if (!_cleanDeviceInfoView) {
        _cleanDeviceInfoView = [[UIView alloc] initWithFrame:self.bounds];
        _cleanDeviceInfoView.backgroundColor = SYWhiteColor;
        _cleanDeviceInfoView.alpha = 0.0f;
        _cleanDeviceInfoView.height += 30;
        [self createDeviceInfoUI];
    }
    return _cleanDeviceInfoView;
}


    


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
