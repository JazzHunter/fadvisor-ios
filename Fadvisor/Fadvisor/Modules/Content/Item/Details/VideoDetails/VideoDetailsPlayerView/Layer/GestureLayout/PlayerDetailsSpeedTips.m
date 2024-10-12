//
//  PlayerDetailsSpeedTips.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/21.
//

#import "PlayerDetailsSpeedTips.h"

@interface PlayerDetailsSpeedTips()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation PlayerDetailsSpeedTips

- (instancetype)init{
    self = [super init];
    if (self) {
        self.orientation = MyOrientation_Horz;
        self.paddingLeft = self.paddingRight = 12;
        self.heightSize.equalTo(@36);
        self.backgroundColor = [UIColor maskBgColor];
        self.gravity = MyGravity_Vert_Center;
        self.myWidth = MyLayoutSize.wrap;
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
        
        [self addSubview:self.icon];
        
        self.tipLabel.myLeading = 8;
        [self addSubview:self.tipLabel];
        
    }
    return self;
}

- (void)showDirection:(BOOL)right speedTips:(NSString *)speedTips {
    if (right) {
        [self.icon setImage:[UIImage imageNamed:@"player_p_speed"]];
    } else {
        [self.icon setImage:[UIImage imageNamed:@"player_p_speed"]];
    }
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:speedTips attributes:@{
                                               NSForegroundColorAttributeName: [UIColor mainColor]
    }];
    [attriStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"倍速快进中" attributes:@{
                                          NSForegroundColorAttributeName: [UIColor whiteColor]
    }]];
    self.tipLabel.attributedText = attriStr;
    
    [self.tipLabel sizeToFit];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _icon.image = [UIImage new];
    }
    return _icon;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _tipLabel;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view = self ? nil : view;
}


@end
