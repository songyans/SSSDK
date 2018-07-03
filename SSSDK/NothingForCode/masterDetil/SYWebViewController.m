//
//  SYWebViewController.m
//  AYSDK
//
//  Created by 松炎 on 2017/7/29.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "SYWebViewController.h"

@interface SYWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;

@end

@implementation SYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.webView];

}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        // 2.创建URL
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
        // 3.创建Request
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        // 4.加载网页
        [_webView loadRequest:request];
        // 5.设置代理
        _webView.delegate = self;
        
        
    }
    return _webView;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    UIImage *img = [UIImage imageNamed:@""];
    
    UIImageView *sdfsdf = [[UIImageView alloc] init];
    sdfsdf.image = img;
    
    
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSString *string = @"sdflsadlkfjslfjlsdjfkslflsa";
    NSString *dsflskf = string;
    int d = 90;
    int w = 12312;
    int sdf = d + w;
    
    NSString *sdfsdf = [NSString stringWithFormat:@"%d%@",sdf, dsflskf];
    UILabel *lab = [[UILabel alloc] init];
    lab.text = sdfsdf;
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
