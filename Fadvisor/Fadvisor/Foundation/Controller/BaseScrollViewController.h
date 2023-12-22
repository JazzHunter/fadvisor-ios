//
//  BaseScrollViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/4.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseScrollViewController : BaseViewController

@property(nonatomic, strong) MyFrameLayout *frameLayout;

@property(nonatomic, strong) MyLinearLayout *contentLayout;

@property(nonatomic, strong) UIScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END
