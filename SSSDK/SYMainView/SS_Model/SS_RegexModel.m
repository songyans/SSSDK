//
//  SS_RegexModel.m
//  SSSDK
//
//  Created by SDK on 2018/3/10.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import "SS_RegexModel.h"

@implementation SS_RegexModel


+ (SS_RegexModel *)getRegexWithData:(id)data{
    NSDictionary *dict = data;
    SS_RegexModel *model = [[SS_RegexModel alloc] init];
    model.phone = [NSString stringWithFormat:@"%@", dict[@"phone"]];
    model.password = [NSString stringWithFormat:@"%@", dict[@"password"]];
    model.qq = [NSString stringWithFormat:@"%@", dict[@"qq"]];
    model.idcard = [NSString stringWithFormat:@"%@", dict[@"idcard"]];
    model.guest_User_Name = [NSString stringWithFormat:@"%@", dict[@"guest_user_name"]];
    model.email = [NSString stringWithFormat:@"%@", dict[@"email"]];
    model.userName = [NSString stringWithFormat:@"%@", dict[@"user_name"]];
    
    
    return model;
}


@end
