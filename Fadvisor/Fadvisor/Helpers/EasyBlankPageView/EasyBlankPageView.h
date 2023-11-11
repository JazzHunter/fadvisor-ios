//
//  EasyBlankPageView.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/23.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

typedef enum : NSUInteger {
    EasyBlankPageViewTypeUnknown,
    EasyBlankPageViewTypeNoData,
    EasyBlankPageViewTypeNetworkError,
} EasyBlankPageViewType;

@interface EasyBlankPageView : UIView

- (void)config:(EasyBlankPageViewType)blankPageType reloadButtonBlock:(void (^)(UIButton *sender))block;
@end

@interface UIView (EasyBlankPageView)

- (void)showBlankPage:(EasyBlankPageViewType)blankPageType reloadButtonBlock:(void (^)(id))block;
- (void)showBlankPage:(CGRect)frame blankPageType:(EasyBlankPageViewType)blankPageType reloadButtonBlock:(void (^)(id))block;
- (void)hideBlankPage;

@end
