//
//  PlayerDetailsMoreSlider.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/20.
//

#import "PlayerDetailsMoreSlider.h"

#define ThumbWidth 15

@implementation PlayerDetailsMoreSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setThumbImage:[UIImage imageNamed:@"player_dot_white"] forState:UIControlStateNormal];
        [self setThumbImage:[UIImage imageNamed:@"player_dot_white"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    return CGRectMake((self.width - ThumbWidth) * value + 1, (self.height - ThumbWidth) / 2, ThumbWidth, ThumbWidth);
}

@end
