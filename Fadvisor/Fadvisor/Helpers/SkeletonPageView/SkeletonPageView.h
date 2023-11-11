//
//  SkeletonPageView.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/4/10.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SkeletonPageViewTypeTab,
    SkeletonPageViewTypeNormal,
    SkeletonPageViewTypeArticlDetail,
} SkeletonPageViewType;

@interface SkeletonPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame isNavbarPadding:(BOOL)isNavbarPadding;
- (void)show:(SkeletonPageViewType)skeletonPageType;

@end

@interface UIView (SkeletonPageView)

- (void)showSkeletonPage;
- (void)showSkeletonPageWithNavbarPadding;
- (void)showSkeletonPage:(SkeletonPageViewType)skeletonPageType;
- (void)showSkeletonPage:(SkeletonPageViewType)skeletonPageType isNavbarPadding:(BOOL)isNavbarPadding;
- (void)hideSkeletonPage;

@end

