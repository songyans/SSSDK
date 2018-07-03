//
//  HTMLBackView.m
//  AYSDK
//
//  Created by SDK on 2018/1/11.
//  Copyright © 2018年 SDK. All rights reserved.
//

#import "HTMLBackView.h"

@interface HTMLBackView()

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation HTMLBackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        self.frame = CGRectMake(0, 0, Screen_Width, 64);
        [self setUpView];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SYColor(26,173,25);

        [self setUpView];
    }
    return self;
}


- (void)setUpView{
    self.leftBtn = [SS_PublicTool createBtnWithButton:self.leftBtn buttonType:UIButtonTypeCustom frame:CGRectMake(10, 32, 15, 30) backgroundColor:nil image:[SS_PublicTool getImageFromBundle:[SS_PublicTool getResourceBundle] withName:@"icon_back" withType:@"png"] normalTitle:nil selectedTitle:nil highlightTitle:nil textAlignment:1 selected:NO titleNormalColor:@"回到游戏" titleSelectedColor:nil  titleHighlightedColor:nil];
    
    self.rightBtn = [SS_PublicTool createBtnWithButton:self.rightBtn buttonType:UIButtonTypeSystem frame:CGRectZero backgroundColor:SYNOColor image:nil normalTitle:@"回到游戏" selectedTitle:nil highlightTitle:nil textAlignment:1 selected:NO titleNormalColor:nil titleSelectedColor:nil titleHighlightedColor:nil];
    
    [self.leftBtn addTarget:self action:@selector(backGame) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(backGame) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
}

- (void)backGame{
    if (self.backGameBlock) {
        self.backGameBlock();
    }
}



@end
