//
//  SS_RegexModel.h
//  SSSDK
//
//  Created by SDK on 2018/3/10.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SS_RegexModel : NSObject

@property (nonatomic ,copy) NSString *phone;

@property (nonatomic ,copy) NSString *password;

@property (nonatomic ,copy) NSString *qq;

@property (nonatomic ,copy) NSString *idcard;

@property (nonatomic ,copy) NSString *guest_User_Name;

@property (nonatomic ,copy) NSString *email;

@property (nonatomic ,copy) NSString *userName;

+ (SS_RegexModel *)getRegexWithData:(id)data;


@end
