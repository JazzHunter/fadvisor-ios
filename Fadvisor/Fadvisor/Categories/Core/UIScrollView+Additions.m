//
//  UIScrollView+Additions.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/4/15.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "UIScrollView+Additions.h"

@implementation UIScrollView (Additions)

- (void)setSafeBottomInset {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.bottom += rootNavigationController.view.safeAreaInsets.bottom;
    self.contentInset = contentInset;
}

- (void)setSafeBottomInsetWithAdditonalSpace:(CGFloat)space{
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.bottom = space;
    contentInset.bottom += rootNavigationController.view.safeAreaInsets.bottom;
    self.contentInset = contentInset;
}

- (void)setSafeTopInset {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.top += rootNavigationController.view.safeAreaInsets.top;
    self.contentInset = contentInset;
}


@end
