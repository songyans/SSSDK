//
//  DSXSYInputMIModel.h
//  善信
//
//  Created by LQ on 2017/6/5.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSXSYInputMIModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeHolderStr;


/**客堂电话*/
@property (nonatomic, copy) NSString *companyPhone;
/**详细地址*/
@property (nonatomic, copy) NSString *detailAddress;
/**毕业佛学院*/
@property (nonatomic, copy) NSString *graduatedCollege;
/**师父详细ID*/
@property (nonatomic, copy) NSString *detailDataId;
/**师父id*/
@property (nonatomic, copy) NSString *masterId;
/**最高学历*/
@property (nonatomic, copy) NSString *maxDiploma;
/**法号*/
@property (nonatomic, copy) NSString *methodNumber;
/**个人经历*/
@property (nonatomic, copy) NSString *personalExperience;
/**个人介绍*/
@property (nonatomic, copy) NSString *personalIntroduce;
/**宗派ID*/
@property (nonatomic, assign) NSInteger sectarianId;
/**宗派名*/
@property (nonatomic, copy) NSString *sectarianName;
/**寺院/精舍地址*/
@property (nonatomic, copy) NSString *templeAddress;
/**寺院职务*/
@property (nonatomic, copy) NSString *templeDuty;
/**现常住寺院/精舍名称*/
@property (nonatomic, copy) NSString *templeName;
/**用户UID*/
@property (nonatomic, copy) NSString *uid;


@end


/*
 
 companyPhone (string, optional): 客堂电话 ,
 detailAddress (string, optional): 详细地址 ,
 graduatedCollege (string, optional): 毕业佛学院 ,
 id (string, optional): 师父详细id ,
 masterId (string, optional): 师父id ,
 maxDiploma (string, optional): 最高学历 ,
 methodNumber (string, optional): 法号 ,
 personalExperience (string, optional): 个人经历 ,
 personalIntroduce (string, optional): 个人介绍 ,
 sectarianId (integer, optional): 宗派id ,
 sectarianName (string, optional): 宗派名 ,
 templeAddress (string, optional): 寺院/精舍地址 ,
 templeDuty (string, optional): 寺院职务 ,
 templeName (string, optional): 现常住寺院/精舍名称 ,
 uid (string, optional): 用户uid
 */
