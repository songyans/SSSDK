//
//  DSXSYTitleModel.h
//  善信
//
//  Created by LQ on 2017/6/2.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSXSYTitleModel : NSObject
/**标题*/
@property (nonatomic, copy) NSString *title;

/**占位文字*/
@property (nonatomic, copy) NSString *placeholder;

/**选择标题*/
@property (nonatomic, copy) NSString *selectTitle;

/**选择内容*/
@property (nonatomic, copy) NSString *selectDetail;
@end
