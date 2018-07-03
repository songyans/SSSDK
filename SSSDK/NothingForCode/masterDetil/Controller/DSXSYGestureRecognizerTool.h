//
//  DSXSYGestureRecognizerTool.h
//  善信
//
//  Created by LQ on 2017/6/23.
//  Copyright © 2017年 LM. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DSXSYGestureRecognizerTool : UIGestureRecognizer


@property(nonatomic,copy)void (^TapGestureBlock)(UITapGestureRecognizer *);



+ (id)addGestureRecognizerToView:(id)view Tag:(int)tag Type:(NSInteger)type Completion:(void (^)(UITapGestureRecognizer *))completion;

- (void)addTapBlock:(void (^)(UITapGestureRecognizer *tap))block;

//+ (void)Completion:(void (^)(UITapGestureRecognizer *))completion;




@end
