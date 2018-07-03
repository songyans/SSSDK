//
//  ShareArea.m
//  AddressDemo
//
//  Created by LQ on 2017/6/1.
//  Copyright © 2017年 worthy.zhang. All rights reserved.
//

#import "ShareArea.h"


static ShareArea *shareArea = nil;
@implementation ShareArea

+ (ShareArea *)shareAre{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareArea == nil) {
            shareArea = [[ShareArea alloc] init];
        }
    });
    
    return shareArea;
}



@end

