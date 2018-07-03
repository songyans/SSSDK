//
//  DSXSYSectCell.m
//  善信
//
//  Created by LQ on 2017/6/6.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYSectCell.h"
@interface DSXSYSectCell ()

@property (nonatomic, strong) UILabel *sectLab;

@end
@implementation DSXSYSectCell


- (UILabel *)sectLab{
    if (!_sectLab) {
        _sectLab = [[UILabel alloc] init];
        _sectLab.font = [UIFont systemFontOfSize:17];
        _sectLab.textColor = [UIColor blackColor];
        _sectLab.numberOfLines = 0;
        _sectLab.textAlignment = 0;
    }
    return _sectLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor clearColor];
    }
    return _lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.sectLab];
        
        [self addSubview:self.lineView];

    }
    return self;
    
}

- (void)layoutSubviews{
    Weak_Self;
    [self.sectLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf).offset(0);
        make.left.equalTo(weakSelf).offset(12);
        make.size.mas_equalTo(CGSizeMake(123123 - 50, 20));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(0 );
        make.right.equalTo(weakSelf).offset(0);
        make.bottom.equalTo(weakSelf).offset(-0.5);
        make.height.mas_equalTo(0.5f);
    }];

}

- (void)setModel:(DSXSYSectModel *)model{
    
    _model = model;
    
    self.sectLab.text = _model.sectarianName;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
