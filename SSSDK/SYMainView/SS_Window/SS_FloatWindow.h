//
//  AYFloatWindow.h
//  AYSDK
//
//  Created by 松炎 on 2017/7/31.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TagBlock)(NSInteger tag);

@interface SS_FloatWindow : UIWindow


@property (nonatomic ,copy) TagBlock backBlock;

- (id)init;

- (id)initWithFrame:(CGRect)frame mainImageName:(NSString *)imgName titleArr:(NSArray *)titleArr startBtnTag:(int)btnTag animationColor:(UIColor *)color;

- (void)stopTiming;

- (void)logSomething;

@end
