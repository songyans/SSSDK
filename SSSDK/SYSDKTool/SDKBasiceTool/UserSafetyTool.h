//
//  UserSafetyTool.h
//  AYSDK
//
//  Created by songyan on 2018/1/29.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSafetyTool : NSObject



+ (void)saveWithUsername:(NSString *)username password:(NSString *)password token:(NSString *)token;


@end
