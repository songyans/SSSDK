//
//  SYHTMLViewController.h
//  AYSDK
//
//  Created by SDK on 2017/12/28.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^GQBlock)();


@interface SYHTMLViewController : UIViewController

@property (nonatomic ,strong) SongyorkInfo *songyorkInfo;

@property (nonatomic ,copy) NSString *zfUrlString;

@property (nonatomic ,copy) GQBlock syBlock;

@end
