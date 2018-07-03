//
//  AYPersonCenterWindow.m
//  AYSDK
//
//  Created by 松炎 on 2017/8/2.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "SS_PersonCenterWindow.h"
#import "SS_PersonTabBarController.h"
#import "ComViewController.h"
#import "AccountController.h"
#import "GiftController.h"
#import "CustomServerController.h"

@interface SS_PersonCenterWindow ()<UITabBarDelegate>

@property (nonatomic, strong) SS_PersonTabBarController *tabBarC;




@end


@implementation SS_PersonCenterWindow


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;

}


- (id)initWithFrame:(CGRect)frame rootViewControllerIndex:(NSInteger)index isChangeBindPhone:(BOOL)isChange{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = 0.5;
        [SS_SDKBasicInfo sharedSS_SDKBasicInfo].selectedIndex = index;

        self.tabBarC = [[SS_PersonTabBarController alloc] init];
      
        Weak_Self;
        self.tabBarC.TabBarBlock = ^{
            if (weakSelf.TabBarBlock) {
                weakSelf.TabBarBlock();
            }
        };
        self.tabBarC.changeBind = isChange;
//        self.tabBarC.index = index;
        self.rootViewController = self.tabBarC;
    
       
    }
    
    return self;
}
/*
-(BOOL)shouldAutorotate
{
    //    if([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 1){
    //        return NO;
    //    }
    //    if([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 0){
    //        return YES;
    //    }
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 1)    //竖屏有游戏
    //    {
    //        return UIInterfaceOrientationMaskPortrait;
    //    }
    //    if ([SS_SDKBasicInfo sharedSS_SDKBasicInfo].directionNumber == 0)    //横屏游戏
    //    {
    //        return UIInterfaceOrientationMaskLandscape;
    //    }
    //    return UIInterfaceOrientationMaskAllButUpsideDown;
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
*/


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
