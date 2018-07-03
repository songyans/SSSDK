//
//  AYPersonTabBar.h
//  AYSDK
//
//  Created by SDK on 2017/10/18.
//  Copyright © 2017年 SDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYPersonTabBar : UITabBar
@property (nonatomic ,copy) void(^TabBarBlock)();

@property (nonatomic, assign) BOOL isGofy;

@property (nonatomic, strong) NSArray *dfjklj;

@property (nonatomic, copy) NSString *jkksSLKJLJLK;
/**<-编辑师傅资料, 2-善信认证 ,3-失败后再次编辑师傅资料>*/

@property (nonatomic, assign) NSInteger wherePush;

- (id)initWithIndex:(NSInteger)index;


@end
