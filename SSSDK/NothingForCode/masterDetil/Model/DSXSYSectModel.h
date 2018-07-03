//
//  DSXSYSectModel.h
//  善信
//
//  Created by LQ on 2017/6/6.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSXSYSectModel : NSObject

/**宗派id*/
@property (nonatomic, assign) NSInteger sectarianId;
/**备注*/
@property (nonatomic, copy) NSString *remark;

/**宗派名称*/
@property (nonatomic, copy) NSString *sectarianName;

/*
 
 id (string, optional): 宗派id ,
 remark (string, optional): 备注 ,
 sectarianName (string, optional): 宗派名称
 */
@end
