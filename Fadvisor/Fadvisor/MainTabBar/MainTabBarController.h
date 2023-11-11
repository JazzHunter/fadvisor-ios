//
//  MainTabBarController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainTabBarController : UITabBarController<UITabBarControllerDelegate>

- (UINavigationController *)currentNavigationController;

@end

NS_ASSUME_NONNULL_END
