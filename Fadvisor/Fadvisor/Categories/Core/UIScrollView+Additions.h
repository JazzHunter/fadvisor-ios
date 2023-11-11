//
//  UIScrollView+Additions.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/4/15.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Additions)

- (void)setSafeBottomInset;

- (void)setSafeBottomInsetWithAdditonalSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
