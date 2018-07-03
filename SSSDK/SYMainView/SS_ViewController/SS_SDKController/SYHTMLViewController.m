//
//  SYHTMLViewController.m
//  AYSDK
//
//  Created by SDK on 2017/12/28.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "SYHTMLViewController.h"
#import "HTMLBackView.h"
@interface SYHTMLViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>


/*支付webview*/
@property (nonatomic, strong)WKWebView *zWebView;


@property (nonatomic, strong) WKWebViewConfiguration *configuration;

@property (strong, nonatomic) UIProgressView *progressView;//进度条



/*get链接参数*/
@property (nonatomic, strong)NSMutableDictionary *params;


@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation SYHTMLViewController

- (void)dealloc{
    [self.zWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.zWebView.configuration.userContentController addScriptMessageHandler:self name:@"backToGame"];
//    [self.zWebView.configuration.userContentController addScriptMessageHandler:self name:@"applePay"];


    
    SYLog(@"页面将要出现");
    
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.zWebView.configuration.userContentController removeScriptMessageHandlerForName:@"backToGame"];
//    [self.zWebView.configuration.userContentController removeScriptMessageHandlerForName:@"applePay"];

    
    SYLog(@"页面将要消失");
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SS_SDKNetworkTool sharedSS_SDKNetworkTool] getManagerBySingleton];
    [self setUpWebView];
    [self loadWebViewData];
    
    [self initProgressView];
    
    [self layoutSubView];
    [self  getNavView];
    [self.zWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)getNavView{
    Weak_Self;
    HTMLBackView *navView = [[HTMLBackView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, SS_StatusBarAndNavigationBarHeight)];
    [self.view addSubview:navView];
    navView.backGameBlock = ^{
        [weakSelf closeClick];
    };
}

- (void)setUpWebView{
    if (!self.zWebView) {
        self.configuration = [[WKWebViewConfiguration alloc] init];
        
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        self.configuration.preferences = preferences;
        
        
        self.zWebView = [[WKWebView alloc] init];
        self.zWebView.UIDelegate = self;
        self.zWebView.navigationDelegate = self;
        self.zWebView.scrollView.bounces = NO;
        [self.view addSubview:self.zWebView];

    }
}

- (void)layoutSubView{
    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 0) {
        
        
    }else if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 1){
        
        
    }
    self.zWebView.frame = CGRectMake(0, SS_StatusBarAndNavigationBarHeight, self.view.width, self.view.height - SS_StatusBarAndNavigationBarHeight);
    
    /*
     [self.closezBtn mas_makeConstraints:^(MASConstraintMaker *make) {
     make.centerY.equalTo(weakSelf.zWebView.mas_top);
     make.centerX.equalTo(weakSelf.zWebView.mas_right);
     make.size.mas_equalTo(CGSizeMake(30, 30));
     }];
     */
}


- (void)loadWebViewData{
    self.dic = [[NSDictionary alloc] init];
    self.dic = @{
                          @"user_id"        :   self.songyorkInfo.uid,
                          @"money"          :   self.songyorkInfo.money,
                          @"money_type"     :   self.songyorkInfo.moneyType,
                          @"server"         :   self.songyorkInfo.serverId,
                          @"cp_trade_sn"    :   self.songyorkInfo.YYY,
                          @"goods_id"       :   self.songyorkInfo.proId,
                          @"goods_name"     :   self.songyorkInfo.productName,
                          @"goods_desc"     :   self.songyorkInfo.desc,
                          @"game_role_id"   :   self.songyorkInfo.roleId,
                          @"game_role_name" :   self.songyorkInfo.roleName,
                          @"game_role_level":   self.songyorkInfo.roleLevel,
                          @"pay_type"       :   @"apple",
                          @"sub_pay_type"   :   @"apple",
                          @"app_channel"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].app_channel,
                          @"device_id"      :   [[SS_SDKBasicInfo sharedSS_SDKBasicInfo] getUUID],
                          @"app_id"         :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].ss_AppId,
                          @"idfv"           :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].idfv,
                          @"sdk_version"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].sdk_Version,
                          @"platform"       :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].platform,
                          @"system_version" :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].system_Version,
                          @"system_name"    :   [SS_SDKBasicInfo sharedSS_SDKBasicInfo].device_Model,
                          @"time"           :   [SS_PublicTool getTimeStamps],
                          };
    NSString *sign = [SS_PublicTool makeSignStringWithParams:self.dic];
    SYLog(@"---sign:%@", sign);
    self.params = [NSMutableDictionary dictionaryWithDictionary:self.dic];
    [self.params setObject:sign forKey:@"sign"];
    
    [self getDataToServer:self.params];
    
    
}


- (void)getDataToServer:(NSMutableDictionary *)dic{
    NSMutableArray *urlArr = [NSMutableArray new];
    NSMutableArray *paramArr = [NSMutableArray new];
    
    
    //排序
    NSArray *keyArray = [dic allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    for (NSString *keys in sortArray) {
        NSString * encodingString = [SS_PublicTool encodeString:[NSString stringWithFormat:@"%@", dic[keys]]];
        
        NSString *str = [NSString stringWithFormat:@"%@=%@",keys, encodingString];
        [paramArr addObject:str];
    }
    
    
    for (NSString *str in paramArr) {
        NSString *paramStr = [NSString stringWithFormat:@"&%@", str];
        [urlArr addObject:paramStr];
    }
    
    //    self.zUrlString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",self.zUrl, urlArr[0], urlArr[1], urlArr[2], urlArr[3], urlArr[4], urlArr[5], urlArr[6], urlArr[7], urlArr[8], urlArr[9], urlArr[10], urlArr[11], urlArr[12], urlArr[13], urlArr[14], urlArr[15], urlArr[16], urlArr[17], urlArr[18]];
    
    for (int i = 0; i < urlArr.count; i++) {
        self.zfUrlString = [NSString stringWithFormat:@"%@%@", self.zfUrlString, urlArr[i]];
    }
    SYLog(@"%@", self.zfUrlString);
    
    
    
    
    
    NSURL *url = [NSURL URLWithString: self.zfUrlString];
    
    
//     if ([[UIApplication sharedApplication] canOpenURL:url]) {
//         [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
//             if (success) {
//                 SYLog(@"-----yes------");
//
//             }
//         }];
//     }
    
    
    
    // 3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 4.加载网页
    [self.zWebView loadRequest:request];
    
    
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    SYLog(@"%@", message.body);
    if ([message.name isEqualToString:@"backToGame"]) {
        
        [self closeClick];
    }
    
//    if ([message.name isEqualToString:@"applePay"]) {
//        [self giveMForApple];
//    }
    
}


//- (void)giveMForApple{
//    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].canClick) {
//        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].canClick = NO;
//        [[SS_ZFForHtml sharedSS_ZFForHtml] justApplePayForGameWithViewController:self songyorkInfo:self.songyorkInfo completion:^(NSString *message, id params) {
//
//        }];
//    }
//
//}


- (void)closeClick{
    
    
    if (self.syBlock) {
        
      
        self.syBlock();
    }
    
}

//自己看.h文件
- (void)initProgressView
{
    //    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 2)];
    progressView.tintColor = [UIColor colorWithRed:0 green:0.58 blue:1 alpha:1];
    progressView.trackTintColor = [UIColor whiteColor];
    self.progressView = progressView;
    [self.view addSubview:self.progressView];
    [self.progressView setHidden:NO];
}

- (NSMutableDictionary *)params{
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}




#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.zWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
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




#pragma mark - WKUIDelegate And WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    SYLog(@"%s",__FUNCTION__);
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    SYLog(@"%s",__FUNCTION__);
    
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    SYLog(@"%s",__FUNCTION__);
    
}




#pragma mark WKWebView终止
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    SYLog(@"%s",__FUNCTION__);
    
}






- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    //    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    if([self isJumpToExternalAppWithURL:navigationAction.request.URL]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
//    if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
//        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:^(BOOL success) {
//            if (success) {
//                SYLog(@"-----yes------");
//
//            }
//        }];
//        decisionHandler(WKNavigationActionPolicyAllow);
//        return;
//    }
//
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

- (BOOL)isJumpToExternalAppWithURL:(NSURL *)URL{
    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https"]];
    return ![validSchemes containsObject:URL.scheme];
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
