//
//  SYHtmlWindow.h
//  AYSDK
//
//  Created by 松炎 on 2017/7/31.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYHtmlWindow : UIWindow


@property(nonatomic,strong)NSArray *provinces ;
@property(nonatomic,strong)NSDictionary *cities ;


@property(nonatomic,copy)NSString *currentProvince;
@property(nonatomic,copy)NSString *currentCity;
@property(nonatomic,copy)NSString *currentString;
@property (nonatomic, copy) NSString *addressStr;


@end
