//
//  NavigationBar.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2019/11/27.
//  Copyright © 2019 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "NavigationBar.h"

#define kLeftRightViewHorzPadding  8.0

@interface NavigationBar ()

@end

@implementation NavigationBar


#pragma mark - system

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.bgView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.bgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.bgView];
        self.rootLayout = [MyRelativeLayout new];
        self.rootLayout.heightSize.equalTo(self.heightSize);
        self.rootLayout.widthSize.equalTo(self.widthSize);
        self.rootLayout.paddingTop = kStatusBarHeight;
        [self addSubview:self.rootLayout];
        //启用设备旋转
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)orientationChanged:(NSNotification *)noti {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    // 处理屏幕旋转后的操作
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            self.frame = CGRectMake(0, 0, kScreenWidth, kDefaultNavBarHeight);
            self.bgView.frame = self.frame;
            self.rootLayout.paddingTop = kStatusBarHeight;
        break;
        case UIDeviceOrientationLandscapeLeft:
            self.frame = CGRectMake(0, 0, kScreenHeight, kButtonStandardSize);
            self.bgView.frame = self.frame;
            self.rootLayout.paddingTop = 0;
        break;
        case UIDeviceOrientationLandscapeRight:
            self.frame = CGRectMake(0, 0, kScreenHeight, kButtonStandardSize);
            self.bgView.frame = self.frame;
            self.rootLayout.paddingTop = 0;
        break;
        default:
        break;
    }
    
}

- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [super dealloc];
}

#pragma mark - Setter
- (void)setDataSource:(id<NavigationBarDataSource>)dataSource {
    _dataSource = dataSource;
    [self setupDataSourceUI];
}

- (void)setLeftView:(UIView *)leftView {
    [_leftView removeFromSuperview];
    _leftView = leftView;
    _leftView.leftPos.equalTo(@kLeftRightViewHorzPadding);
    _leftView.centerYPos.equalTo(@0);
    CGFloat leftViewPadding = _leftView.width == 0 ? 0 : kLeftRightViewHorzPadding;
    CGFloat rightViewPadding = _rightView.width == 0 ? 0 : kLeftRightViewHorzPadding;
    CGFloat maxTilteViewWidth = MAX(self.width - (2 * kLeftRightViewHorzPadding) - leftViewPadding - rightViewPadding - 2 * MAX(_leftView.width, _rightView.width), 0);
    if (self.titleView.width > maxTilteViewWidth) {
        CGRect frame = self.titleView.frame;
        frame.size.width = maxTilteViewWidth;
        self.titleView.frame = frame;
    }
    [self.rootLayout addSubview:_leftView];
}

- (void)setRightView:(UIView *)rightView {
    [_rightView removeFromSuperview];
    _rightView = rightView;
    _rightView.rightPos.equalTo(@kLeftRightViewHorzPadding);
    _rightView.centerYPos.equalTo(@0);
    CGFloat leftViewPadding = _leftView.width == 0 ? 0 : kLeftRightViewHorzPadding;
    CGFloat rightViewPadding = _rightView.width == 0 ? 0 : kLeftRightViewHorzPadding;
    CGFloat maxTilteViewWidth = MAX(self.width - (2 * kLeftRightViewHorzPadding) - leftViewPadding - rightViewPadding - 2 * MAX(_leftView.width, _rightView.width), 0);
    if (self.titleView.width > maxTilteViewWidth) {
        CGRect frame = self.titleView.frame;
        frame.size.width = maxTilteViewWidth;
        self.titleView.frame = frame;
    }
    [self.rootLayout addSubview:_rightView];
}

- (void)setTitleView:(UIView *)titleView {
    [_titleView removeFromSuperview];
    _titleView = titleView;
    CGFloat leftViewPadding = _leftView.width == 0 ? 0 : kLeftRightViewHorzPadding;
    CGFloat rightViewPadding = _rightView.width == 0 ? 0 : kLeftRightViewHorzPadding;
    CGFloat maxTilteViewWidth = MAX(self.width - (2 * kLeftRightViewHorzPadding) - leftViewPadding - rightViewPadding - 2 * MAX(_leftView.width, _rightView.width), 0);
    if (self.titleView.width > maxTilteViewWidth) {
        CGRect frame = self.titleView.frame;
        frame.size.width = maxTilteViewWidth;
        self.titleView.frame = frame;
    }
    _titleView.centerXPos.equalTo(@0);
    _titleView.centerYPos.equalTo(@0);
    [self.rootLayout addSubview:_titleView];
}

- (void)setTitle:(NSAttributedString *)title {
    UILabel *navTitleLabel = [UILabel new];
    navTitleLabel.numberOfLines = 0;//可能出现多行的标题
    [navTitleLabel setAttributedText:title];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.userInteractionEnabled = YES;
    navTitleLabel.lineBreakMode = NSLineBreakByClipping;
    [navTitleLabel sizeToFit];
    self.titleView = navTitleLabel;
}

- (void)setTitleText:(NSString *)titleText {
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium], NSForegroundColorAttributeName: [UIColor titleTextColor] };
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:titleText attributes:attributes];
    [self setTitle:text];
}

#pragma mark - custom
- (void)setupDataSourceUI {
    /** 背景色 */
    if ([self.dataSource respondsToSelector:@selector(navigationBarBackgroundColor:)]) {
        self.bgView.backgroundColor = [self.dataSource navigationBarBackgroundColor:self];
    } else {
        self.bgView.backgroundColor = [UIColor backgroundColor];
    }
    /** 背景图 */
    if ([self.dataSource respondsToSelector:@selector(navigationBarBackgroundImage:)] && [self.dataSource navigationBarBackgroundImage:self]) {
        self.bgView.image = [self.dataSource navigationBarBackgroundImage:self];
    }
    /** 是否隐藏底部黑线 */
    if ([self.dataSource respondsToSelector:@selector(navigationBarHideBottomLine:)] && [self.dataSource navigationBarHideBottomLine:self]) {
        self.rootLayout.bottomBorderline = nil;
    } else {
        MyBorderline *bld = [[MyBorderline alloc] initWithColor:[UIColor borderColor]];
        bld.thick = 2;
        self.rootLayout.bottomBorderline = bld;
    }
    /** 导航条的左边的 view */
    /** 导航条左边的按钮 */
    if ([self.dataSource respondsToSelector:@selector(navigationBarHideLeftView:)] && [self.dataSource navigationBarHideLeftView:self]) {
        _leftView = [UIView new];
    } else if ([self.dataSource respondsToSelector:@selector(navigationBarLeftView:)]) {
        _leftView = [self.dataSource navigationBarLeftView:self];
    } else if ([self.dataSource respondsToSelector:@selector(navigationBarLeftButtonImage:navigationBar:)]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonStandardSize, kButtonStandardSize)];
        UIImage *image = [self.dataSource navigationBarLeftButtonImage:btn navigationBar:self];
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
        }
        _leftView = btn;
    } else {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonStandardSize, kButtonStandardSize)];
        [btn setImage:[UIImage imageNamed:@"navgationbar_back_pre"] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"navgationbar_back_nor"] forState:UIControlStateNormal];
        _leftView = btn;
    }
    if ([self.leftView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)self.leftView;
        [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    _leftView.leftPos.equalTo(@kLeftRightViewHorzPadding);
    _leftView.centerYPos.equalTo(@0);
    [self.rootLayout addSubview:_leftView];

    /** 导航条右边的 view */
    /** 导航条右边的按钮 */
    if ([self.dataSource respondsToSelector:@selector(navigationBarHideRightView:)] && [self.dataSource navigationBarHideRightView:self]) {
        _rightView = [UIView new];
    } else if ([self.dataSource respondsToSelector:@selector(navigationBarRightView:)]) {
        _rightView = [self.dataSource navigationBarRightView:self];
    } else if ([self.dataSource respondsToSelector:@selector(navigationBarRightButtonImage:navigationBar:)]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonStandardSize, kButtonStandardSize)];
        UIImage *image = [self.dataSource navigationBarRightButtonImage:btn navigationBar:self];
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
        }
        _rightView = btn;
    } else {
        _rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kButtonStandardSize, kButtonStandardSize)];
    }
    if ([_rightView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)_rightView;
        [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    _rightView.rightPos.equalTo(@kLeftRightViewHorzPadding);
    _rightView.centerYPos.equalTo(@0);
    [self.rootLayout addSubview:_rightView];

    /** 导航条中间的 View */
    if ([self.dataSource respondsToSelector:@selector(navigationBarTitleView:)]) {
        _titleView = [self.dataSource navigationBarTitleView:self];
        _titleView.centerXPos.equalTo(@0);
        _titleView.centerYPos.equalTo(@0);
    } else if ([self.dataSource respondsToSelector:@selector(navigationBarTitle:)]) {
        /**头部标题*/
        NSMutableAttributedString *titleAttrStr = [self.dataSource navigationBarTitle:self];
        UILabel *navTitleLabel = [UILabel new];
        navTitleLabel.numberOfLines = 0;//可能出现多行的标题
        [navTitleLabel setAttributedText:titleAttrStr];
        navTitleLabel.textAlignment = NSTextAlignmentCenter;
        navTitleLabel.userInteractionEnabled = YES;
        navTitleLabel.lineBreakMode = NSLineBreakByClipping;
        [navTitleLabel sizeToFit];
        self.titleView = navTitleLabel;//这里是因为需要设置左右边距
    } else {
        MyBaseLayout *titleView = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        titleView.gravity = MyGravity_Center;
        titleView.mySize = CGSizeMake(kScreenWidth - 2 * (2 * kLeftRightViewHorzPadding + kButtonStandardSize), MyLayoutSize.wrap);
        titleView.subviewHSpace = 12;
        _titleView = titleView;
        _titleView.centerXPos.equalTo(@0);
        _titleView.centerYPos.equalTo(@0);
    }

    __block BOOL isHaveTapGes = NO;
    [self.titleView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            isHaveTapGes = YES;
            *stop = YES;
        }
    }];

    if (!isHaveTapGes) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
        [_titleView addGestureRecognizer:tap];
    }

    [self.rootLayout addSubview:_titleView];
}

#pragma mark - event
- (void)leftBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(leftButtonEvent:navigationBar:)]) {
        [self.delegate leftButtonEvent:btn navigationBar:self];
    }
}

- (void)rightBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(rightButtonEvent:navigationBar:)]) {
        [self.delegate rightButtonEvent:btn navigationBar:self];
    }
}

- (void)titleClick:(UIGestureRecognizer *)Tap {
    UILabel *view = (UILabel *)Tap.view;
    if ([self.delegate respondsToSelector:@selector(titleClickEvent:navigationBar:)]) {
        [self.delegate titleClickEvent:view navigationBar:self];
    }
}

@end
