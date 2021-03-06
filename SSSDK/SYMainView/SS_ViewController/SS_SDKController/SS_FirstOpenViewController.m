//
//  FirstOpenViewController.m
//  AYSDK
//
//  Created by SDK on 2017/7/25.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "SS_FirstOpenViewController.h"
#import "SS_LoginViewController.h"
#import "SS_VerifyDynamicView.h"
#import "SYSaveTouristInfo.h"
#import "SS_LoginForPhoneViewController.h"
#import "SS_RegisterMobilUserViewController.h"

@interface SS_FirstOpenViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

{
    BOOL _isTourist;
}
@property (nonatomic, strong)SS_BGView *BGView;

@property (nonatomic, strong) SS_VerifyDynamicView *verifyDynamicView;

@property (nonatomic, strong) SYSaveTouristInfo *saveTouristInfoView;

@property (nonatomic ,strong) SS_AddIdentityInfo *addIdentityView;

@property (nonatomic, strong)UIImageView *logoImgView;//logo图片

@property (nonatomic, strong)UIButton *userBtn;//账号登录btn

@property (nonatomic, strong)UIButton *phoneBtn;//手机登录btn

@property (nonatomic, strong)UIButton *touristBtn;//游客登录btn

@property (nonatomic, strong)UIButton *closeBtn;//关闭BTN

@property (nonatomic, strong)UILabel *chooseLab;//选择label

@property (nonatomic, strong)UILabel *userLab;//账号登录Lable

@property (nonatomic, strong)UILabel *touristLab;//游客登录label

@property (nonatomic, strong)UILabel *phoneLab;//手机登录label

@property (nonatomic ,strong) UIImageView *logoBG;//logo背景


@property (nonatomic, strong) UIButton *backBtn;//返回


@property (nonatomic, strong)UIButton *knowBtn;//知道了BTN

@property (nonatomic ,copy) NSString *requestUrl;//请求的链接

@property (nonatomic ,strong) WKWebView *webView;//wkwebview

@property (strong, nonatomic) UIProgressView *progressView;//进度条

@property (nonatomic ,strong) UIImageView *ggLogo;//logo背景

@property (nonatomic, strong)dispatch_source_t time;

@property (nonatomic, assign) int secNum;

@property (nonatomic, assign) int page;

@property(nonatomic,strong)MBProgressHUD *HUD;

@property(nonatomic,strong)MBProgressHUD *webHUD;

@property (nonatomic, strong) SS_BGView *tipsView;

@property (nonatomic, strong) SS_ErrorView *errorView;

@property (nonatomic, strong) NSDictionary *responesParam;

@property (nonatomic, assign) BOOL isLoginAfter;//登陆后公告


@end

@implementation SS_FirstOpenViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getManagerBySingleton];
    self.isLoginAfter = NO;

    if (!self.isPush) {
        if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].tipsID.length > 0) {
            [self.view addSubview:self.tipsView];
            self.tipsView.center = self.view.center;
            self.requestUrl = [NSString stringWithFormat:@"%@?platform=ios&appid=%@",  SS_URL_Tips, [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId];
            self.webHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.webHUD.mode = MBProgressHUDModeIndeterminate;
            self.webHUD.label.text = @"正在加载";
            
            [self setUpWebView];
            
            [self layouttipsView];
            
        }else{
            [self setUpWebView];
            
            [self makeTheViewForLogin];
        }
    }else{
        [self setUpWebView];
        
        [self makeTheViewForLogin];
    }

    

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"getInfo"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"getInfo"];
}

- (void)layouttipsView{
    [self.tipsView addSubview:self.ggLogo];
    [self.tipsView addSubview:self.knowBtn];
    
    Weak_Self;
    [self.ggLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tipsView.mas_top).offset(15);
        make.centerX.equalTo(weakSelf.tipsView);
        make.size.mas_equalTo(CGSizeMake(150, 30));
   }];
    
    
    [self.knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.tipsView.mas_bottom).offset(-15);
        make.centerX.equalTo(weakSelf.tipsView);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];
    [self judgeNet];
    
}



//自己看.h文件
- (void)setUpWebView{
    
    if (!self.webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        configuration.preferences = preferences;
        
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 60, self.tipsView.width - 20, self.tipsView.height - 120)];
        self.webView.backgroundColor = [UIColor whiteColor];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
        
        self.webView.scrollView.bounces = NO;
        //    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        [self.tipsView addSubview:self.webView];
        
        
    }
}

// 判断网络
- (void)judgeNet
{
    
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getNetWorkStateBlock:^(NSInteger netStatus) {
        if (netStatus == 1 || netStatus == 2) {
            [self isNetWorking:YES];
            if (self.time) {
                dispatch_source_cancel(_time);
                
            }
            
        }else{
            [self webViewDidLoadFail];
            [self isNetWorking:NO];
        }
    }];
    
    if (![SS_SDKBasicInfo sharedSS_SDKBasicInfo].haveInterNet) {
        
    }else{
    }
    [self keepNetWoking];
    
    
}


- (void)keepNetWoking{
    _secNum = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(1.0* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    SYLog(@"再次刷新网络");
    
    dispatch_source_set_event_handler(self.time, ^{
        if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].haveInterNet) {
            //            _time = nil; // 将 dispatch_source_t 置为nil
            dispatch_source_cancel(_time);
            _secNum = 0;
        }else{
            _secNum++;
            if (_secNum == 5) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self judgeNet];
                    dispatch_source_cancel(_time);
                    _secNum = 0;
                    
                });
            }
            SYLog(@"重读网络%d", _secNum);
            
        }
    });
    
    
    
    //由于定时器默认是暂停的所以我们启动一下
    //启动定时器
    dispatch_resume(self.time);
    
    
}



- (void)webViewDidLoadFail{
    self.webHUD.mode = MBProgressHUDModeText;
    self.webHUD.label.text = @"网速不给力";
    [self.webHUD hideAnimated:YES afterDelay:0.5f];
    //    self.webHUD = nil;
    //    [self isNetWorking:NO];
    
}



- (void)isNetWorking:(BOOL)isNetWorking{
    if (!isNetWorking) {
        SYLog(@"没网");
        if (self.webView) {
            
            self.webView.hidden = YES;
            [self.webView removeFromSuperview];
            [self.progressView setHidden:YES];
            [self.progressView removeFromSuperview];
            self.progressView = nil;
            
            [self.tipsView addSubview:self.errorView];
            
            
        }
    }
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"getInfo"]) {
        [self sendDataForPrama:message.body messageName:message.name];
    }
    
}

/*处理签名*/
- (void)sendDataForPrama:(NSDictionary *)param messageName:(NSString *)name{
    NSString *jsString = [NSString string];
    //    NSArray *paramArr = [NSArray array];
    //    param = @{
    //              @"token"      :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].token,
    //              };
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    NSString *string = [NSString stringWithFormat:@"%@", dict[@"sign"]];
    if (string.length > 0) {
        [dict removeObjectForKey:@"sign"];
    }
    //        [dict setObject:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].token forKey:@"token"];
    //        [dict setValue:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].token forKey:@"token"];
    NSString *sign = [SS_PublicTool makeSignStringWithParams:dict];
    jsString = [NSString stringWithFormat:@"getiOSSign('%@')", sign];
    
    //    paramArr = [param allValues];
    SYLog(@"-----------------dict:%@------------", dict);
    [dict setObject:sign forKey:@"sign"];
    [self.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        SYLog(@"----------%@____%@", result, error);
    }];
    
    
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

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.webHUD hideAnimated:YES afterDelay:0.3f];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    SYLog(@"%s",__FUNCTION__);
    
    [self webViewDidLoadFail];
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    SYLog(@"%s",__FUNCTION__);
    [self webViewDidLoadFail];
    
}


#pragma mark WKWebView终止
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    SYLog(@"%s",__FUNCTION__);
    [self webViewDidLoadFail];
    
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         //         SYLog(@"转屏前调入");
         CGPoint point = CGPointMake(Screen_Width / 2, Screen_Height / 2);
         self.BGView.center = point;
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         //         SYLog(@"转屏后调入");
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


- (void)makeTheViewForLogin{
    
    self.page = 0;
    
    [self.view addSubview:self.BGView];
    //self.BGView.center = self.view.center;
    [self createUI];
    
}


- (void)createUI{
    
    
    [self.BGView addSubview:self.logoImgView];
    //    [self.touristBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"AI" withType:@"png"] forState:UIControlStateNormal];
    if (![SS_SDKBasicInfo sharedSS_SDKBasicInfo].isTouristLogin) {
        self.touristBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.touristBtn.tag = 100;
//        [self.touristBtn setBackgroundColor:[UIColor blueColor]];
        [self.touristBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"yjdl" withType:@"png"] forState:UIControlStateNormal];
        [self.touristBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"yjdl" withType:@"png"] forState:UIControlStateHighlighted];
        [self.touristBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.BGView addSubview:self.touristBtn];
    }
   
    
    self.userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userBtn.tag = 101;
//    [self.userBtn setBackgroundColor:[UIColor redColor]];
    [self.userBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"zhdl" withType:@"png"] forState:UIControlStateNormal];
    [self.userBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"zhdl" withType:@"png"] forState:UIControlStateHighlighted];

    [self.userBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.BGView addSubview:self.userBtn];
    
    self.phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneBtn.tag = 102;
//    [self.phoneBtn setBackgroundColor:[UIColor yellowColor]];
    [self.phoneBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"sjdl" withType:@"png"] forState:UIControlStateNormal];
    [self.phoneBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"sjdl" withType:@"png"] forState:UIControlStateHighlighted];
    [self.phoneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.BGView addSubview:self.phoneBtn];
    
    if (self.isPush) {
        [self.BGView addSubview:self.backBtn];
    }
    
    
    self.touristLab = [[UILabel alloc] init];
    self.touristLab.textAlignment = 1;
    self.touristLab.font = [UIFont systemFontOfSize:16];
    self.touristLab.text = @"一键登录";
    [self.BGView addSubview:self.touristLab];
    
    self.userLab = [[UILabel alloc] init];
    self.userLab.textAlignment = 1;
    self.userLab.font = [UIFont systemFontOfSize:16];
    self.userLab.text = @"账号";
    [self.BGView addSubview:self.userLab];
    
    self.phoneLab = [[UILabel alloc] init];
    self.phoneLab.textAlignment = 1;
    self.phoneLab.font = [UIFont systemFontOfSize:16];
    self.phoneLab.text = @"手机账号";
    [self.BGView addSubview:self.phoneLab];
   
    
    self.chooseLab = [[UILabel alloc] init];
    self.chooseLab.textAlignment = 1;
    self.chooseLab.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1];
    self.chooseLab.font = [UIFont systemFontOfSize:18];
    self.chooseLab.text = @"请选择登录方式";
    [self.BGView addSubview:self.chooseLab];
    
    [self layoutSubView];
    
    
}

- (void)layoutSubView{
    Weak_Self;
    //约束
    
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.BGView).offset(30);
        //            make.left.equalTo(weakSelf.BGView).offset(90);
        //            make.right.equalTo(weakSelf.BGView).offset(-90);
        //            make.height.mas_equalTo(30);
        make.centerX.equalTo(weakSelf.BGView);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];

    [self.chooseLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.logoImgView.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.BGView).offset(20);
        make.right.equalTo(weakSelf.BGView).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    if (![SS_SDKBasicInfo sharedSS_SDKBasicInfo].isTouristLogin) {
        [self.touristBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.BGView).offset(30);
            //        make.top.equalTo(weakSelf.BGView).offset(20);
            make.left.equalTo(weakSelf.BGView).offset(20);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        
        [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.BGView);
            make.centerY.equalTo(weakSelf.BGView).offset(30);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.BGView).offset(30);
            make.right.equalTo(weakSelf.BGView.mas_right).offset(-20);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        [self.touristLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.touristBtn.mas_bottom).offset(15);
            make.left.equalTo(weakSelf.touristBtn);
            make.right.equalTo(weakSelf.touristBtn);
        }];
        
        [self.userLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.userBtn.mas_bottom).offset(15);
            make.left.equalTo(weakSelf.userBtn);
            make.right.equalTo(weakSelf.userBtn);
        }];
        
        [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.phoneBtn.mas_bottom).offset(15);
            make.left.equalTo(weakSelf.phoneBtn);
            make.right.equalTo(weakSelf.phoneBtn);
        }];
        
    }else{
        [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.BGView).offset(30);
            make.left.equalTo(weakSelf.BGView).offset(60);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.BGView).offset(30);
            make.right.equalTo(weakSelf.BGView.mas_right).offset(-60);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        [self.userLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.userBtn.mas_bottom).offset(15);
            make.left.equalTo(weakSelf.userBtn);
            make.right.equalTo(weakSelf.userBtn);
        }];
        
        [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.phoneBtn.mas_bottom).offset(15);
            make.left.equalTo(weakSelf.phoneBtn);
            make.right.equalTo(weakSelf.phoneBtn);
        }];
    }
    
    if (self.isPush) {
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.BGView).offset(20);
            make.centerY.equalTo(weakSelf.logoImgView).offset(0);
            make.size.mas_equalTo(CGSizeMake(15, 20));
        }];
    }
    
    self.userBtn.layer.cornerRadius = self.userBtn.width / 2;
    self.userBtn.layer.masksToBounds = YES;
    
    self.phoneBtn.layer.cornerRadius = self.phoneBtn.width / 2;
    self.phoneBtn.layer.masksToBounds = YES;
    
    self.touristBtn.layer.cornerRadius = self.touristBtn.width / 2;
    self.touristBtn.layer.masksToBounds = YES;
}

- (void)backClick
{
    SYLog(@"返回");
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)knowClick:(id)sender{
    
    
    
    if (self.isLoginAfter) {
        
        if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].tipsNumber > 0) {
            
            self.page ++;
            
            NSString *string = [NSString stringWithFormat:@"%d", self.page];
            NSString *jsString = [NSString stringWithFormat:@"nextPage('%@')", string];
            [self.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                SYLog(@"----------%@____%@", result, error);
            }];
            
            if (([SS_SDKBasicInfo sharedSS_SDKBasicInfo].tipsNumber - self.page) == 1) {
                [self.knowBtn setBackgroundImage:get_BundleImage(@"knowBtn") forState:UIControlStateNormal];
            }
            if (self.page == [SS_SDKBasicInfo sharedSS_SDKBasicInfo].tipsNumber || [SS_SDKBasicInfo sharedSS_SDKBasicInfo].tipsNumber == 1) {
                self.tipsView = nil;
                self.webView = nil;
                if (_isTourist) {
                    [self saveScreenShotToLocal];

                }else{
                    [self createFloatWindowIntoGame];
                }

                
            }
        }
        
        
    }else{
        self.tipsView.hidden = YES;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
        [self makeTheViewForLogin];
    }
    
    
}

- (void)btnClick:(UIButton *)sender{
    Weak_Self;
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getManagerBySingleton];
    
    if (sender.tag == 101) {
        SYLog(@"用户登录...");
        SS_LoginViewController *loginVC = [[SS_LoginViewController alloc]init];
        loginVC.isPush = YES;
        loginVC.block = ^{
            if (weakSelf.block) {
                weakSelf.block();
            }
        };
        [self.navigationController pushViewController:loginVC animated:NO];
    }else if(sender.tag == 100){
        SYLog(@"游客登录....");

        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.mode = MBProgressHUDModeIndeterminate;   //选择不同类型的mode；
        _HUD.label.text = @"正在登录..." ;
        _isTourist = YES;
        [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] registTouristCompletion:^(BOOL isSuccess, id respones) {
            if (isSuccess) {
                SYLog(@"----respones:%@,----message:%@", respones, respones[@"msg"]);
#pragma mark ----------------------------------------------强制进入身份证页面
//                [SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindModel.user_Idcard_Check = YES;
                if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindModel.user_Idcard_Check && ! [SS_SDKBasicInfo sharedSS_SDKBasicInfo].isBindingIdCard) {
                    [weakSelf checkIdentityBeforeLoggingIsConstraint:[SS_SDKBasicInfo sharedSS_SDKBasicInfo].bindModel.user_Idcard_Check_Need completion:^(AddIdentityInfoViewClickStates addViewClickStates) {
                        if (addViewClickStates == 0) {
                            [weakSelf verificationFailedStayHere];
                        }else{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                                int authType = [respones[@"data"][@"auth_type"] intValue];
                                if (authType == 1) {
                                    [weakSelf.HUD hideAnimated:YES];
                                    [weakSelf alertVerifyDynamicView];
                                }else{
                                    self.HUD.mode = MBProgressHUDModeText;
                                    weakSelf.HUD.label.text = @"登录成功";
                                    [weakSelf.HUD hideAnimated:YES afterDelay:1.0f];
                                    //*** 回调消除登录的window
                                    [weakSelf readTipsForLoginAfterWhitIsTourist:_isTourist];
                                    
                                }
                            });
                            
                        }
                    }];
                    
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                        int authType = [respones[@"data"][@"auth_type"] intValue];
                        if (authType == 1) {
                            [weakSelf.HUD hideAnimated:YES];
                            [weakSelf alertVerifyDynamicView];
                        }else{
                            self.HUD.mode = MBProgressHUDModeText;
                            weakSelf.HUD.label.text = @"登录成功";
                            [weakSelf.HUD hideAnimated:YES afterDelay:1.0f];
                            //*** 回调消除登录的window
                            [weakSelf readTipsForLoginAfterWhitIsTourist:_isTourist];
                            
                        }
                    });
                    
                }
                
                
                
                
            }else{
                SYLog(@"----respones:%@,----message:%@", respones, respones[@"msg"]);
                weakSelf.HUD.mode = MBProgressHUDModeText;
                
                weakSelf.HUD.label.text = respones[@"msg"];
               
                [weakSelf.HUD hideAnimated:YES afterDelay:1];
                //                [weakSelf.HUD removeFromSuperview];
                //                weakSelf.HUD = nil;
                
            }
        } failure:^(NSError * _Nullable error) {
            
            weakSelf.HUD.mode = MBProgressHUDModeText;
            weakSelf.HUD.label.text = @"网络异常";
            [weakSelf.HUD hideAnimated:YES afterDelay:1];
        }];
        
    }else{
        SYLog(@"手机注册");
//        NSMutableArray *nameArr = [NSMutableArray new];

        
       
       
        if (self.isPush) {
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            
            
            NSArray *arr = [KeyChainWrapper load:SSUsernameKey];
            
            for (NSString *key in arr) {
                BOOL isTel = [SS_PublicTool isValidateTel:key];
#pragma mark ----------------------------------------------强制进入手机注册
                //            isTel = NO;
                if (isTel) {
                    SS_LoginForPhoneViewController *phoneLoginVC = [[SS_LoginForPhoneViewController alloc] init];
                    phoneLoginVC.block = weakSelf.block;
                    phoneLoginVC.isPush = YES;
                    [self.navigationController pushViewController:phoneLoginVC animated:NO];
                    
                    return;
                }
            }
            SS_RegisterMobilUserViewController *registerMobilVC = [[SS_RegisterMobilUserViewController alloc] init];
            registerMobilVC.MobilRegisterBlock = weakSelf.block;
            [self.navigationController pushViewController:registerMobilVC animated:NO];
  
            
        }
        
    }
        
    
}


/**
 创建验证身份证页面
 
 @param isConstraint 是否强制绑定
 @param completion 完成后回调
 */
- (void)checkIdentityBeforeLoggingIsConstraint:(BOOL)isConstraint completion:(void(^)(AddIdentityInfoViewClickStates addViewClickStates))completion{
    
    [self.HUD hideAnimated:YES];
    self.addIdentityView = [[SS_AddIdentityInfo alloc] initIfNeedMandatoryBindIdInfo:isConstraint viewController:self];
    self.addIdentityView.addIdentityInfoViewBlock = ^(AddIdentityInfoViewClickStates addViewStates) {
        if (completion) {
            completion(addViewStates);
        }
    };
    self.addIdentityView.center = self.view.center;
    self.BGView.hidden = YES;
    [self.view addSubview:self.addIdentityView];
    
}


- (void)verificationFailedStayHere{
    [UIView animateWithDuration:0.3 animations:^{
        self.BGView.hidden = NO;
        self.addIdentityView.y = Screen_Height;
    } completion:^(BOOL finished) {
        self.addIdentityView.hidden = YES;
        self.addIdentityView = nil;
    }];
    [SS_PublicTool showHUDWithViewController:self Text:@"身份信息验证失败"];
}



- (void)alertVerifyDynamicView{
    Weak_Self;
    [self.view addSubview:self.verifyDynamicView];
    self.verifyDynamicView.BtnBlock = ^(BOOL isSuccess, id dic) {
        if (isSuccess) {
            [SS_PublicTool showHUDWithViewController:weakSelf Text:@"登录成功"];
            [weakSelf readTipsForLoginAfterWhitIsTourist:NO];
        }else{
            NSString *string = dic[@"msg"];
            if ([string isEqualToString:@"销毁页面"]) {
                weakSelf.verifyDynamicView.hidden = YES;
                weakSelf.verifyDynamicView = nil;
                string = @"取消登录";
            }
            [SS_PublicTool showHUDWithViewController:weakSelf Text:string];
        }
    };
    
    
}


- (void)readTipsForLoginAfterWhitIsTourist:(BOOL)isTourist{
    
    Weak_Self;
    
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] noticeBeforTheLoginCompletion:^(BOOL isSuccess, id respones) {
        
        if (isSuccess) {
             weakSelf.isLoginAfter = isTourist;
            
            NSDictionary *dictNotice = respones[@"data"];
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].tipsNumber = [dictNotice[@"number"] intValue];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                [weakSelf.view addSubview:self.tipsView];
                weakSelf.tipsView.center = self.view.center;
                if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].tipsNumber > 1) {
                    [self.knowBtn setBackgroundImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"c_01" withType:@"png"] forState:UIControlStateNormal];
                    
                }else if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].tipsNumber <= 1){
                    [self.knowBtn setBackgroundImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"knowBtn" withType:@"png"] forState:UIControlStateNormal];
                    
                }
                [weakSelf layouttipsView];
                weakSelf.requestUrl = [NSString stringWithFormat:@"%@?platform=ios&token=%@", SS_URL_BeforTips, [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdkToken];
                [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
                weakSelf.tipsView.hidden = NO;
                [weakSelf.view insertSubview:self.tipsView atIndex:8];
                
            });
            
        }else{
            [SS_SDKBasicInfo sharedSS_SDKBasicInfo].tipsNumber = 0;
            if (isTourist) {
#pragma mark ------------------------------------------------ 测试保存页面
//                [SS_PublicTool saveFirstOpen:NO];
                [weakSelf saveScreenShotToLocal];
            }else{
                [weakSelf createFloatWindowIntoGame];
            }
            
            
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)saveScreenShotToLocal{
    Weak_Self;
    if (![SS_PublicTool getCurrenFirstOpen]) {
        self.saveTouristInfoView = [[SYSaveTouristInfo alloc] initWithViewController:self];
        [self.view addSubview:self.saveTouristInfoView];
        self.saveTouristInfoView.buttonBlock = ^(ScreenshotState screenshotState) {
            switch (screenshotState) {
                case SaveSuccess:
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [SS_PublicTool showHUDWithViewController:weakSelf Text:@"屏幕截图已保存到相册,请妥善保管"];
                        [SS_PublicTool saveFirstOpen:YES];
                        [weakSelf createFloatWindowIntoGame];
                    });
                    
                    /*
                     [SS_PublicTool showAlertToViewController:weakSelf alertControllerTitle:nil alertControllerMessage:@"屏幕截图已保存到相册,请妥善保管" alertCancelTitle:@"好的" alertReportTitle:nil cancelHandler:^(UIAlertAction * _Nonnull action) {
                     [weakSelf createFloatWindowIntoGame];
                     } reportHandler:nil completion:^{
                     
                     }];
                     */
                }
                    break;
                    
                case SaveCancel:
                {
                    [weakSelf createFloatWindowIntoGame];
                    [SS_PublicTool saveFirstOpen:YES];
                    
                }
                    break;
                    
                case SaveFailure:
                {
                    
                    
                    
                }
                    break;
                    
                case LoadResourceError:
                {
                    /*
                     [UIView animateWithDuration:0.3 animations:^{
                     weakSelf.saveTouristInfoView.size = CGSizeMake(0, 0);
                     } completion:^(BOOL finished) {
                     [weakSelf.saveTouristInfoView removeFromSuperview];
                     weakSelf.saveTouristInfoView = nil;
                     }];
                     */
                    SYLog(@"访问出错");
                }
                    break;
                    
                default:
                    break;
            }
        };
        
    }else{
        [self createFloatWindowIntoGame];
    }
}

- (void)createFloatWindowIntoGame{
    
    
    
    [SS_PublicTool createFloatWindowIntoGameCompletion:^{
        [SS_PublicTool firstOpenApplication:YES];
        
        //*** 回调消除登录的window
        if (self.block)
        {
            self.block();
        }
    }];
    
}


#pragma mark ------------------------------------------------懒加载

//懒加载
- (SS_BGView *)BGView{
    if (!_BGView) {
        _BGView = [[SS_BGView alloc] initWithShowImage:NO showBGView:NO];
        _BGView.height = _BGView.height - 30;
        _BGView.backgroundColor = SYWhiteColor;
        _BGView.layer.cornerRadius = 10;
        _BGView.layer.masksToBounds = YES;
    }
    return _BGView;
}

- (SS_VerifyDynamicView *)verifyDynamicView{
    if (!_verifyDynamicView) {
        _verifyDynamicView = [[SS_VerifyDynamicView alloc] initWithFrame:CGRectMake(0, 0, self.BGView.width, 200)];
        _verifyDynamicView.center = self.BGView.center;
        _verifyDynamicView.backgroundColor = [UIColor whiteColor];
        
    }
    return _verifyDynamicView;
}

- (SS_BGView *)tipsView{
    if (!_tipsView) {
        _tipsView = [[SS_BGView alloc] initWithShowImage:NO showBGView:NO];
        if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 1) {
            _tipsView.height += 100;
            
        }else{
            _tipsView.width += 50;
            
        }
        _tipsView.backgroundColor = [UIColor whiteColor];
        _tipsView.layer.cornerRadius = 10;
        _tipsView.layer.masksToBounds = YES;
    }
    return _tipsView;
}

- (SS_ErrorView *)errorView{
    if (!_errorView) {
        _errorView = [[SS_ErrorView alloc] initWithFrame:CGRectMake(10, 60, self.tipsView.width - 20, self.tipsView.height - 120) tipsText:@"数据获取失败"];
        
    }
    return _errorView;
}

- (UIImageView *)ggLogo{
    if (!_ggLogo) {
        _ggLogo = [[UIImageView alloc] init];
        [_ggLogo setImage:get_SSWL_Logo];
        
    }
    return _ggLogo;
}

- (UIImageView *)logoImgView{
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] init];
        
        
        [_logoImgView setImage:get_SSWL_Logo];
            
        
    }
    return _logoImgView;
}
- (UIImageView *)logoBG{
    if (!_logoBG) {
        _logoBG = [[UIImageView alloc] init];
        [_logoBG setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"bg1" withType:@"png"]];
        
    }
    return _logoBG;
}


- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //         _backBtn.backgroundColor = [UIColor redColor];
        [_backBtn setImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"back" withType:@"png"] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backBtn;
}

- (UIButton *)knowBtn{
    if (!_knowBtn) {
        _knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        //        [_knowBtn setTitle:@"知道了" forState:UIControlStateNormal];
        //        [_knowBtn setTitle:@"知道了" forState:UIControlStateHighlighted];
        [_knowBtn setBackgroundImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"knowBtn" withType:@"png"] forState:UIControlStateNormal];
        //            [_touristBtn setBackgroundImage:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"an2_2_02" withType:@"png"] forState:UIControlStateHighlighted];
        
        //        _knowBtn.backgroundColor = [UIColor redColor];
        
        
        [_knowBtn addTarget:self action:@selector(knowClick:) forControlEvents:UIControlEventTouchUpInside];
        //        _registBtn.tag = 1001;
        
    }
    return _knowBtn;
}

- (NSDictionary *)responesParam{
    if (!_responesParam) {
        _responesParam = [[NSDictionary alloc] init];
        }
    return _responesParam;
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
