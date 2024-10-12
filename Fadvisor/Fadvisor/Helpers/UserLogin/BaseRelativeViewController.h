//
//  BaseRelativeViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/10.
//

#import <UIKit/UIKit.h>
#import <MyLayout/MyLayout.h>
#import "NavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseRelativeViewController : UIViewController<NavigationBarDelegate, NavigationBarDataSource>

@property(nonatomic, strong, readonly) MyRelativeLayout *rootLayout;

@property (strong, nonatomic) NavigationBar *navigationBar;

@end

NS_ASSUME_NONNULL_END
