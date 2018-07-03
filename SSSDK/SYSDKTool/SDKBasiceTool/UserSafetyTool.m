//
//  UserSafetyTool.m
//  SSSDK
//
//  Created by songyan on 2018/1/29.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import "UserSafetyTool.h"

@implementation UserSafetyTool


+ (void)saveWithUsername:(NSString *)username password:(NSString *)password token:(NSString *)token{
    
    if ([KeyChainWrapper load:SSUsernameKey] == nil) {
        NSMutableArray *userNameArray = [NSMutableArray array];
        [userNameArray insertObject:username atIndex:0];
        [KeyChainWrapper save:SSUsernameKey data:userNameArray];
    }else{
        NSMutableArray *userNameArr = [KeyChainWrapper load:SSUsernameKey];
        if ([userNameArr containsObject:username]) {
            //            NSMutableDictionary *haveUserDict = [KeyChainWrapper load:SSPasswordKey];
            //            [haveUserDict removeObjectForKey:username];
            //            [KeyChainWrapper save:SSPasswordKey data:haveUserDict];
            
            [userNameArr removeObject:username];
            [userNameArr insertObject:username atIndex:0];
            [KeyChainWrapper save:SSUsernameKey data:userNameArr];
            
        }else{
            if (userNameArr.count == 5) {
                NSMutableDictionary *userDict = [KeyChainWrapper load:SSPasswordKey];
                [userDict removeObjectForKey:userNameArr[4]];
                [KeyChainWrapper save:SSPasswordKey data:userDict];
                
                [userNameArr removeObjectAtIndex:4];
                [userNameArr insertObject:username atIndex:0];
                [KeyChainWrapper save:SSUsernameKey data:userNameArr];
            }else{
                [userNameArr insertObject:username atIndex:0];
                [KeyChainWrapper save:SSUsernameKey data:userNameArr];
            }
        }
    }
    //*** 、字典保存账号、密码，最多5个
    if ([KeyChainWrapper load:SSPasswordKey] == nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (password.length < 1) {
            password = @"";
        }
        [dict setObject:password forKey:username];
        [KeyChainWrapper save:SSPasswordKey data:dict];
    }else{
        NSMutableDictionary *userDict = [KeyChainWrapper load:SSPasswordKey];
        if ([userDict objectForKey:username]) {
            if (![password isEqualToString:[userDict objectForKey:username]]) {
                [userDict setObject:password forKey:username];
                [KeyChainWrapper save:SSPasswordKey data:userDict];
            }
            
        }else{
            if (password.length < 1) {
                password = @"";
            }
            [userDict setObject:password forKey:username];
            [KeyChainWrapper save:SSPasswordKey data:userDict];
        }
    }
    
    if ([KeyChainWrapper load:SYMobilTokenKey] == nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:token forKey:username];
        [KeyChainWrapper save:SYMobilTokenKey data:dict];
    }else{
        NSMutableDictionary *userDict = [KeyChainWrapper load:SYMobilTokenKey];
        if ([userDict objectForKey:username]) {
            if (![token isEqualToString:[userDict objectForKey:username]]) {
                [userDict setObject:token forKey:username];
                [KeyChainWrapper save:SYMobilTokenKey data:userDict];
            }
            
        }else{
            [userDict setObject:token forKey:username];
            [KeyChainWrapper save:SYMobilTokenKey data:userDict];
        }
    }
    
}




@end
