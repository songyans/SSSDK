//
//  FloatViewNavController.m
//  AYSDK
//
//  Created by 松炎 on 2017/7/31.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "FloatViewNavController.h"

@interface FloatViewNavController ()



@end

@implementation FloatViewNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

//系统方法,是否允许旋转
- (BOOL)shouldAutorotate{
    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 1) {
        return NO;
    }
    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 0) {
        return YES;
    }
    return YES;
}

//屏幕横竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 1) {
        return UIInterfaceOrientationMaskPortrait;
    }
    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 0) {
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }

    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
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
