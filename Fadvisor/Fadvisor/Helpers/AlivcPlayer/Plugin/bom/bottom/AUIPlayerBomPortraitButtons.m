//
//  AUIPlayerBomPortraitButtons.m
//  ApsaraVideo
//
//  Created by mengyehao on 2021/7/21.
//

#import "AUIPlayerBomPortraitButtons.h"
#import "AlivcPlayerAsset.h"
#import "CustomImageButton.h"

@interface AUIPlayerBomPortraitButtons()
@property (nonatomic, strong) CustomImageButton *fullScreenButton;
@end

@implementation AUIPlayerBomPortraitButtons

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.fullScreenButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.fullScreenButton.frame = CGRectMake(0, 0, self.width, self.height);

}

- (CustomImageButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [[CustomImageButton alloc] initWithFrame:CGRectMake(12, 0, self.height, self.height)];
//        _fullScreenButton.accessibilityIdentifier = AUIVideoFlowAccessibilityStr(@"bomProtraitButton_fullScreenButton");
        _fullScreenButton.imageSize = CGSizeMake(14, 14);

        [_fullScreenButton setImage:[UIImage imageNamed:@"player_fullscreen"] forState:UIControlStateNormal];
        
        [_fullScreenButton addTarget:self action:@selector(onFullscreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _fullScreenButton;
}

- (void)onFullscreenButtonClick:(id)sender
{
    if (self.onFullScreenBlock) {
        self.onFullScreenBlock();
    }
}

@end
