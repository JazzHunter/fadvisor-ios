//
//  HWPanModalNavView.m
//  HWPanModalDemo
//
//  Created by heath wang on 2019/12/16.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import "PopNavView.h"

@interface PopNavView ()

@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation PopNavView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor backgroundColor];
        
        self.backButton.heightSize.equalTo(self.heightSize);
        self.backButton.centerYPos.equalTo(@0);
        self.backButton.leftPos.equalTo(self.leftPos).offset(10);
        [self addSubview:self.backButton];
        
        self.rightButton.heightSize.equalTo(self.heightSize);
        self.rightButton.rightPos.equalTo(self.rightPos).offset(10);
        self.rightButton.centerYPos.equalTo(@0);
        [self addSubview:self.rightButton];
        
        self.navTitleLabel.heightSize.equalTo(self.heightSize);
        self.navTitleLabel.leftPos.equalTo(self.backButton.rightPos).offset(10);
        self.navTitleLabel.rightPos.equalTo(self.rightButton.leftPos).offset(10);
        self.navTitleLabel.centerYPos.equalTo(@0);
        [self addSubview:self.navTitleLabel];
        
    }

    return self;
}

#pragma mark - touch action

- (void)onTappedBackButton {
    id <PopNavViewDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(didTapBackButton)]) {
        [o didTapBackButton];
    }
}

- (void)onTappedRightButton {
    id <PopNavViewDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(didTapRightButton)]) {
        [o didTapRightButton];
    }
}

#pragma mark - Getter
- (UILabel *)navTitleLabel {
    if (!_navTitleLabel) {
        _navTitleLabel = [UILabel new];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.textColor = [UIColor titleTextColor];
        _navTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    }

    return _navTitleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"Back" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_backButton addTarget:self action:@selector(onTappedBackButton) forControlEvents:UIControlEventTouchUpInside];
        _backButton.myWidth = 66;
    }
    return _backButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"Done" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightButton addTarget:self action:@selector(onTappedRightButton) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.myWidth = 66;
    }
    return _rightButton;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    _title = [title mutableCopy];
    self.navTitleLabel.text = title;
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle {
    _rightButtonTitle = [rightButtonTitle mutableCopy];

    [self.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
}

- (void)setBackButtonTitle:(NSString *)backButtonTitle {
    _backButtonTitle = [backButtonTitle mutableCopy];

    [self.backButton setTitle:backButtonTitle forState:UIControlStateNormal];
    self.backButton.hidden = backButtonTitle.length <= 0;
}

@end
