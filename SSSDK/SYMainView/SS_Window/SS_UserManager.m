//
//  UserManager.m
//  AYSDK
//
//  Created by songyan on 2017/8/26.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import "SS_UserManager.h"
#import "SS_UserManagerController.h"
#import "SS_UserManagerNavController.h"

@interface SS_UserManager()
@property (nonatomic, strong) SS_UserManagerNavController *userManagerNav;
@end

@implementation SS_UserManager

- (instancetype)init{
    
    self = [super init];
    if (self) {
       
//        self.layer.cornerRadius = 10;
//        self.layer.masksToBounds = YES;
        
          }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = 0.5;
        SS_UserManagerController *umVC = [[SS_UserManagerController alloc] init];
        umVC.block = ^{
            if (_UserBlock) {
                _UserBlock();
            }
        };
        self.userManagerNav = [[SS_UserManagerNavController alloc] initWithRootViewController:umVC];
        [SS_PublicTool stopSystemPopGestureRecognizerForNavigationController:self.userManagerNav];
//        userManagerNav.navigationBar.hidden = YES;
        
        self.rootViewController = self.userManagerNav;

    }
    return self;

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
