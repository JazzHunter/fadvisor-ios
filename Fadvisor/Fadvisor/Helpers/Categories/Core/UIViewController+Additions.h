//
//  UIViewController+AVHelper.h
//  ApsaraVideo
//
//  Created by Bingo on 2021/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UIViewControllerAPContainerProtocol<NSObject>
@optional
- (BOOL)controlStatusBarAppearance;
@end

@interface UIViewController (Additions)

- (void)presentFullScreenViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion;

- (void)insertChildViewController:(UIViewController *)childViewController onView:(UIView *)parentView index:(NSInteger)index;
- (void)displayChildViewController:(UIViewController *)childViewController onView:(UIView *)parentView;
- (void)displayChildViewController:(UIViewController *)childViewController;
- (void)hideChildViewController:(UIViewController *)childViewController;
- (void)hideFromParentViewController;

+ (UIViewController *)topViewController;


@end

NS_ASSUME_NONNULL_END
