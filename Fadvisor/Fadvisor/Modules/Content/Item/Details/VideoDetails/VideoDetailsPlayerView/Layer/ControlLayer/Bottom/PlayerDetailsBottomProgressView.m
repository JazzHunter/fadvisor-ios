//
//  PlayerDetailsBottomProgressView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/24.
//

#import "PlayerDetailsBottomProgressView.h"

@implementation PlayerDetailsBottomProgressView

- (void)resetLayout:(BOOL)isPortrait {
    self.hidden = !isPortrait;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.progressViewStyle = UIProgressViewStyleDefault;
        self.progress = 0.0;
        self.trackTintColor = [UIColor clearColor];
        self.progressTintColor = [UIColor mainColor];
    }
    return self;
}


@end
