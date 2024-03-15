//
//  TabAccountInternalBanner.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/12.
//

#import "TabAccountInternalBanner.h"

@implementation TabAccountInternalBanner

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myHeight = MyLayoutSize.wrap;
        self.padding = UIEdgeInsetsMake(12, 16, 12, 16);
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    self.backgroundColor = [UIColor lightMainColor];
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
//    [self setCornerRadius:6];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"认证为内部会员";
    titleLabel.textColor = [UIColor mainColor];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [titleLabel sizeToFit];
    
    titleLabel.leftPos.equalTo(self.leftPos);
    titleLabel.topPos.equalTo(self.topPos);
    
    [self addSubview:titleLabel];
    
    UILabel *descLabel = [UILabel new];
    descLabel.text = @"查看更多内部资料";
    descLabel.textColor = [UIColor mainColor];
    descLabel.font = [UIFont systemFontOfSize:13];
    [descLabel sizeToFit];
    
    descLabel.leftPos.equalTo(self.leftPos);
    descLabel.topPos.equalTo(titleLabel.bottomPos).offset(8);
    [self addSubview:descLabel];
    
}

@end
