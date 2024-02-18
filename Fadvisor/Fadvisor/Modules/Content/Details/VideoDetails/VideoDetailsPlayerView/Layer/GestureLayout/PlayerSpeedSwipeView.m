//
//  AUIPlayerSpeedSwipeView.m
//  AUIVideoFlow
//
//  Created by ISS013602000846 on 2022/6/12.
//

#import "PlayerSpeedSwipeView.h"

@interface PlayerSpeedSwipeView ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation PlayerSpeedSwipeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        [self addSubview:self.icon];
        [self addSubview:self.tipLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIImage *iconImg = [UIImage imageNamed:@"player_p_speed"];
    CGFloat iconHeight = iconImg.size.width * iconImg.size.height / 22;
    self.icon.frame = CGRectMake(20, (self.height - iconHeight) / 2.0, 22, iconHeight);
    self.tipLabel.frame = CGRectMake(self.icon.right + 8, (self.height - 20) / 2.0, self.width - self.icon.right - 8, 20);
}

- (void)updateDirection:(BOOL)right speed:(NSString *)speed {
    if (right) {
        [self.icon setImage:[UIImage imageNamed:@"player_p_speed"]];
    } else {
        [self.icon setImage:[UIImage imageNamed:@"player_p_speed"]];
    }
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:speed attributes:@{
                                               NSForegroundColorAttributeName: [UIColor colorFromHexString:@"FF00FF"]
    }];
    [attriStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"快进中" attributes:@{
                                          NSForegroundColorAttributeName: [UIColor colorFromHexString:@"FF00FF"]
    }]];
    self.tipLabel.attributedText = attriStr;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage new];
    }
    return _icon;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor colorFromHexString:@"FF00FF"];
        _tipLabel.font = [UIFont systemFontOfSize:14];
    }
    return _tipLabel;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view = self ? nil : view;
}

@end
