//
//  DSXSYShowMasterDetailController.m
//  善信
//
//  Created by LQ on 2017/6/12.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYShowMasterDetailController.h"

#import "DSXSYInputMIModel.h"

#import "DSXSYMasterDataController.h"

@interface DSXSYShowMasterDetailController ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) DSXSYInputMIModel *inputModel;
@property (nonatomic, strong) UIButton *rightB;
@end

@implementation DSXSYShowMasterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    

    [self loadWebView];
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.isMasterSelf == Myself) {
        self.rightB.hidden = NO;
        [self.rightB sizeToFit];
    }else{
        self.rightB.hidden = YES;
        self.rightB.frame = CGRectZero;
    }
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modify{
    SYLog(@"-----------修改");
    MBProgressHUD *progress = [[MBProgressHUD alloc] init];
    progress.detailsLabelText = @"大善师兄，一个月只能修改一次资料如需修改请到下月";
    
    
    NSTimeInterval time = [self.auditTime doubleValue] / 1000;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    SYLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM"];//HH:mm  -dd
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    SYLog(@"====%@====", currentDateStr);
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateForNow = [[NSDateFormatter alloc] init];
    [dateForNow setDateFormat:@"yyyy-MM"];
    NSString *nowDateStr = [dateForNow stringFromDate:nowDate];
    SYLog(@"====%@====", nowDateStr);
    
    NSString *yearCurren = [currentDateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *monthCurren = [currentDateStr substringWithRange:NSMakeRange(5, 2)];
    SYLog(@"---%@----%@", yearCurren, monthCurren);
    
    NSString *yearNow = [nowDateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *monthNow = [nowDateStr substringWithRange:NSMakeRange(5, 2)];
    SYLog(@"---%@----%@", yearNow, monthNow);
    
    if (([yearCurren isEqualToString:yearNow]) || ([yearNow intValue] > [yearCurren intValue])) {
        if ([monthNow intValue] - [monthCurren intValue] > 0) {
            [self loadDataForModify];
        }
       
    }else{
        
    }
}


- (void)loadDataForModify{
    Weak_Self;
    NSString *urlString = @"/api/master/attestation/getMasterDetail.do";
    NSString *url = [NSString stringWithFormat:@"%@%@",@"121212",urlString];
    NSDictionary *param = @{
                            @"uid"  : url,
                            };
    if (param) {
        SYLog(@"++++++++++++++++++++++++++++++%@-----------------%@",param, param[@"message"]);
        if ([param[@"code"] intValue] == 200) {
            weakSelf.inputModel = [[DSXSYInputMIModel alloc] init];
            
            dispatch_async(dispatch_get_main_queue(), ^{
              if (weakSelf.inputModel.uid > 0) {
                        DSXSYMasterDataController *mdVC = [[DSXSYMasterDataController alloc] init];
                        mdVC.inputModel = weakSelf.inputModel;
                        [weakSelf.navigationController pushViewController:mdVC animated:YES];
                    }
   
            });
        }else{
            
        }
        
    }
    
    
}


- (void)loadWebView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 5142, 23 - 64)];
    NSURL *url = [NSURL URLWithString:self.showMasterUrl];
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 4.加载网页
    [self.webView loadRequest:request];
    // 5.最后将webView添加到界面
    [self.view addSubview:self.webView];
    
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
