//
//  DSXSYGestureRecognizerTool.m
//  善信
//
//  Created by LQ on 2017/6/23.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYGestureRecognizerTool.h"

@interface DSXSYGestureRecognizerTool  ()


//@property (nonatomic, assign) NSInteger numberOfTapsRequired;

//@property (nonatomic, assign) NSInteger numberOfTouchesRequired;


@end

@implementation DSXSYGestureRecognizerTool



- (void)addTapBlock:(void (^)(UITapGestureRecognizer *tap))block
{
    self.TapGestureBlock = block;

    [self addTarget:self action:@selector(tap:)];
}



- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (self.TapGestureBlock) {
        self.TapGestureBlock(gesture);
    }
}


- (void)setNumberOfTapsRequired:(NSInteger)numberOfTapsRequired{
    UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc]init];
//    self.numberOfTapsRequired  = numberOfTapsRequired;
    tapGestureRecognizer.numberOfTapsRequired = numberOfTapsRequired;
}




+ (id)addGestureRecognizerToView:(id)view Tag:(int)tag Type:(NSInteger)type Completion:(void (^)(UITapGestureRecognizer *))completion{
    
    
    //WithTarget:self  action:@selector(tap:)
    UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc]init];
    
    //    配置属性
    //    轻拍次数
    tapGestureRecognizer.numberOfTapsRequired =1;
    //    轻拍手指个数
    tapGestureRecognizer.numberOfTouchesRequired =1;
    //    讲手势添加到指定的视图上
    
    if (type == 1) {
        UILabel *lab = (UILabel *)view;
        lab.userInteractionEnabled = YES;
        lab.tag = tag;
        
        [lab addGestureRecognizer:tapGestureRecognizer];
        
        return lab;
    }else if (type == 2){
        UIImageView *imgV = (UIImageView *)view;
        imgV.userInteractionEnabled = YES;
        imgV.tag = tag;
        [imgV addGestureRecognizer:tapGestureRecognizer];
        
        return imgV;
    }else if (type == 3){
        UITextView *textV = (UITextView *)view;
        textV.userInteractionEnabled = YES;
        textV.tag = tag;
        [textV addGestureRecognizer:tapGestureRecognizer];
        return textV;
    }
    
    
    return nil;
    
}


@end
