//
//  KeFuViewController.m
//  AYSDK
//
//  Created by SDK on 2017/9/21.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "KeFuViewController.h"
#import <WebKit/WebKit.h>

@interface KeFuViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@property (strong, nonatomic) UIProgressView *progressView;


@property (nonatomic ,strong) SS_BGView *bgView;

@property (nonatomic, strong) UIButton *backBtn;//返回

@property (nonatomic, strong) UIButton *callPhoneBtn;//客服电话

@property (nonatomic, strong) UIButton *chatWebBtn;//客服链接

@property (nonatomic, strong) UIButton *webBackBtn;

@property (nonatomic, strong) UIView *bg;

@property (nonatomic, strong) UIImageView *logoImgView;

@end

@implementation KeFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgView];
    [self createUI];
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getManagerBySingleton];

}


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)createUI{
    [self.bgView addSubview:self.logoImgView];
    [self.bgView addSubview:self.callPhoneBtn];
    [self.bgView addSubview:self.chatWebBtn];
    [self.bgView addSubview:self.backBtn];
    [self layoutSubview];
}

- (void)layoutSubview{
    Weak_Self;
    if ([[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_6_Plus"] || [[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_6s_Plus"] || [[SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model isEqualToString:@"iPhone_7_Plus"]){
        [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.bgView).offset(50);
            make.centerX.equalTo(weakSelf.bgView);
            make.size.mas_equalTo(CGSizeMake(150, 30));
        }];
    }else{
        [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.bgView).offset(40);
            make.centerX.equalTo(weakSelf.bgView);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
    }

    
    [self.callPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(weakSelf.bgView.width, 30));
//        make.center.equalTo(weakSelf.bgView);
        make.top.equalTo(weakSelf.logoImgView.mas_bottom).offset(40);
        make.left.equalTo(weakSelf.bgView).offset(53);
        make.right.equalTo(weakSelf.bgView).offset(-53);
        make.height.mas_equalTo(36);
    }];
    
    [self.chatWebBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.callPhoneBtn.mas_bottom).offset(30);
        make.left.equalTo(weakSelf.bgView).offset(53);
        make.right.equalTo(weakSelf.bgView).offset(-53);
        make.height.mas_equalTo(36);

    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.bgView).offset(40);
        make.centerY.equalTo(weakSelf.logoImgView);
        make.left.equalTo(weakSelf.bgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

- (void)callClick{
    NSURL *url = [NSURL URLWithString:@"tel:02029058850"];

    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                SYLog(@"-----yes------");
                
            }
        }];
    }
}

- (void)webClick{
    
//    NSURL *url = [NSURL URLWithString:@"http://kefu.qycn.com/vclient/chat/?websiteid=129289&groupid=41922"];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
//            if (success) {
//                SYLog(@"-----yes------");
//                
//            }
//        }];
//    }
    [[SY_FloatWindowTool sharedSY_FloatWindowTool] destroyFloatWindow];
    [self setUpWebView];
}

- (void)setUpWebView{
    
    if (!self.webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        configuration.preferences = preferences;
        
        self.bg = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, Screen_Height)];
        self.bg.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.bg];
        [UIView animateWithDuration:0.2f animations:^{
            self.bg.y = 0;
        }];
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, Screen_Width, Screen_Height - 20)];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        NSString *requestUrl = [SS_SDKBasicInfo sharedSS_SDKBasicInfo].customerService;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]]];
        
        self.webView.scrollView.bounces = NO;
        //    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        [self.bg addSubview:self.webView];
        [self initProgressView];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 38)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.webView addSubview:backView];
        [backView addSubview:self.webBackBtn];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = @"在线客服";
        titleLab.textAlignment = 1;
        titleLab.textColor = [UIColor blackColor];
        [backView addSubview:titleLab];
        
        
        [self.webBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(5);
            make.centerY.equalTo(backView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.centerY.equalTo(backView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
  
    }
    
    
}

- (void)initProgressView
{
    //    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 2)];
    progressView.tintColor = [UIColor redColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}




#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
    
}

- (void)webBackClick{
    [UIView animateWithDuration:0.2f animations:^{
        self.webView.y = Screen_Height;
        self.bg.y = Screen_Height;
    } completion:^(BOOL finished) {
        if (self.webView) {
            self.webView = nil;
            self.bg = nil;
        }
    }];
}

- (void)backClick{
    if (self.isPush){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (self.BackBlock) {
            self.BackBlock();
        }
  
    }
   
}

#pragma mark ------------------------------------------------懒加载

- (UIImageView *)logoImgView{
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] init];
        
        
        [_logoImgView setImage:get_SSWL_Logo];
            
    }
    return _logoImgView;
}


- (SS_BGView *)bgView{
    if (!_bgView) {
        _bgView = [[SS_BGView alloc] initWithShowImage:NO showBGView:NO];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}


- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //         _backBtn.backgroundColor = [UIColor redColor];
//        [_backBtn setTitle:@" 返回" forState:UIControlStateNormal];
//        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"back" withType:@"png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backBtn;
}

- (UIButton *)webBackBtn{
    if (!_webBackBtn) {
        _webBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //         _backBtn.backgroundColor = [UIColor redColor];
//        [_webBackBtn setTitle:@"< 返回" forState:UIControlStateNormal];
//        [_webBackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_webBackBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"back" withType:@"png"] forState:UIControlStateNormal];
        [_webBackBtn addTarget:self action:@selector(webBackClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _webBackBtn;
}

- (UIButton *)callPhoneBtn{
    if (!_callPhoneBtn) {
        _callPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_callPhoneBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"kf_2_01" withType:@"png"] forState:UIControlStateNormal];
        [_callPhoneBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"kf_2_02" withType:@"png"] forState:UIControlStateHighlighted];
//        [_callPhoneBtn setTitle:@"客服电话: 02029058850" forState:UIControlStateNormal];
//        _callPhoneBtn.backgroundColor = [UIColor whiteColor];
//        _callPhoneBtn.titleLabel.textAlignment = 1;
        [_callPhoneBtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _callPhoneBtn;
}

- (UIButton *)chatWebBtn{
    if (!_chatWebBtn) {
        _chatWebBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_chatWebBtn setTitle:@"在线客服" forState:UIControlStateNormal];
//        _chatWebBtn.backgroundColor = [UIColor whiteColor];
//        _chatWebBtn.titleLabel.textAlignment = 1;
        [_chatWebBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"kf_1_01" withType:@"png"] forState:UIControlStateNormal];
        [_chatWebBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"kf_1_02" withType:@"png"] forState:UIControlStateHighlighted];
        [_chatWebBtn addTarget:self action:@selector(webClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatWebBtn;
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
