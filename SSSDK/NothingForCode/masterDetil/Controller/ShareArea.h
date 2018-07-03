//
//  ShareArea.h
//  AddressDemo
//
//  Created by LQ on 2017/6/1.
//  Copyright © 2017年 worthy.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareArea : NSObject

+ (ShareArea *)shareAre;

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString * district;
@property (nonatomic, copy) NSString *allPlace;
@end
