//
//  SS_BindIdentituInfoModel.m
//  SSSDK
//
//  Created by SDK on 2018/3/10.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import "SS_BindIdentituInfoModel.h"

@implementation SS_BindIdentituInfoModel

+ (SS_BindIdentituInfoModel *)getBindIdentityInfoWithData:(id)data{
    NSDictionary *dict = data;
    SS_BindIdentituInfoModel *model = [[SS_BindIdentituInfoModel alloc] init];
    model.reg_User_Idcard_Check_Need =[dict[@"reg_user_idcard_check_need"] boolValue];
    model.user_Idcard_Check_Need = [dict[@"user_idcard_check_need"] boolValue];
    model.sy_User_Idcard_Check_Need = [dict[@"pay_user_idcard_check_need"] boolValue];
    model.reg_User_Idcard_Check = [dict[@"reg_user_idcard_check"] boolValue];
    model.user_Idcard_Check = [dict[@"user_idcard_check"] boolValue];
    model.sy_User_Idcard_Check = [dict[@"pay_user_idcard_check"] boolValue];
    
    
    
    return model;
}

@end
