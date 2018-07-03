//
//  AYBGView.h
//  AYSDK
//
//  Created by songyan on 2017/8/28.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SS_BGView : UIView

@property (nonatomic ,strong) UIImageView *bgImg;

@property (nonatomic, strong) UIViewController *vc;

@property (nonatomic, copy) void(^CleanDeviceBlock)(BOOL isCleanSuccess);

/**
 初始化 AYBGView

 @param isShow : 是否显示上士令牌图片
 @return AYBGView : 实例化对象
 */
- (id)initWithShowImage:(BOOL)isShow showBGView:(BOOL)isShowBG;

/**
 初始化 BGView
 
 @param isShow 是否显示上士令牌图片
 @param isShowBG 是否显示背景图片
 @param isShowCleanView 是否开启清除设备号按钮
 @return bgview
 */
- (id)initWithShowImage:(BOOL)isShow showBGView:(BOOL)isShowBG showCleanView:(BOOL)isShowCleanView;


@end
