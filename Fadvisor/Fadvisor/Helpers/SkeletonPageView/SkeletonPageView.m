//
//  SkeletonPageView.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/4/10.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "SkeletonPageView.h"
#import "TABAnimated.h"
#import "MyLayout.h"
@interface SkeletonPageView()

@property (nonatomic, strong) MyBaseLayout *rootLayout;

@end

@implementation SkeletonPageView
- (instancetype)initWithFrame:(CGRect)frame isNavbarPadding:(BOOL)isNavbarPadding{
    self = [super initWithFrame:frame];
    if (self) {
        _rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        _rootLayout.myMargin = 0;
        _rootLayout.padding = UIEdgeInsetsMake(ItemMarginVertical + (isNavbarPadding ? kDefaultNavBarHeight : 0), ItemMarginHorizon, ItemMarginVertical, ItemMarginHorizon);
        [self addSubview:_rootLayout];
        self.tabAnimated = TABViewAnimated.new;
        self.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
        self.backgroundColor = [UIColor backgroundColorGray];
    }
    return self;
}

- (void)show:(SkeletonPageViewType)skeletonPageType {
    switch (skeletonPageType) {
        case SkeletonPageViewTypeNormal: {
            [self createNormalSkeletonUI];
            break;
        };
        case SkeletonPageViewTypeTab: {
            [self createNormalSkeletonUI];
            break;
        };
        case SkeletonPageViewTypeArticlDetail: {
            [self createNormalSkeletonUI];
            break;
        };
    }
    [self.rootLayout layoutSubviews];
}

- (void)createNormalSkeletonUI {
    self.rootLayout.gravity = MyGravity_Horz_Center;
    UILabel *label1 = [UILabel new];
    label1.numberOfLines = 6;
    label1.widthSize.equalTo(self.widthSize).add(-3 * ItemMarginHorizon);
    label1.myHeight = 160;
    label1.myTop = 20;

    [self.rootLayout addSubview:label1];

    UILabel *label2 = [UILabel new];
    label2.numberOfLines = 4;
    label2.widthSize.equalTo(self.widthSize).add(-3 * ItemMarginHorizon);
    label2.heightSize.equalTo(self.heightSize).multiply(0.3).add(-ItemMarginVertical);
    [self.rootLayout addSubview:label2];

    self.tabAnimated.adjustBlock = ^(TABComponentManager *_Nonnull manager) {
        manager.animation(0).dropStayTime(0.6).height(16);
        manager.animation(1).height(16);
    };
}

@end

#pragma mark - category部分

static void *SkeletonPageViewKey = &SkeletonPageViewKey;

@implementation UIView (SkeletonPageView)
- (void)setSkeletonPageView:(SkeletonPageView *)skeletonPageView {
    objc_setAssociatedObject(self, SkeletonPageViewKey,
                             skeletonPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SkeletonPageView *)skeletonPageView {
    return objc_getAssociatedObject(self, SkeletonPageViewKey);
}

- (void)showSkeletonPage {
    [self showSkeletonPage:SkeletonPageViewTypeNormal isNavbarPadding:NO];
}

- (void)showSkeletonPageWithNavbarPadding {
    [self showSkeletonPage:SkeletonPageViewTypeNormal isNavbarPadding:YES];
}

- (void)showSkeletonPage:(SkeletonPageViewType)skeletonPageType {
    [self showSkeletonPage:skeletonPageType isNavbarPadding:NO];
}

- (void)showSkeletonPage:(SkeletonPageViewType)skeletonPageType isNavbarPadding:(BOOL)isNavbarPadding{
    if (!self.skeletonPageView) {
        self.skeletonPageView = [[SkeletonPageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) isNavbarPadding:isNavbarPadding];
    }
    [self.skeletonPageView show:skeletonPageType];
    [self.skeletonPageView tab_startAnimation];
    [self addSubview:self.skeletonPageView];
}

- (void)hideSkeletonPage {
    if (self.skeletonPageView) {
        [self.skeletonPageView tab_endAnimationEaseOut];
        [self.skeletonPageView removeFromSuperview];
    }
}

@end
