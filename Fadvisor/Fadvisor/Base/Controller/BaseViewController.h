//
//  BaseViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/10.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"

@class BaseViewController;

@protocol BaseViewControllerDataSource <NSObject>

@optional

- (BOOL)baseViewControllerIsNeedNavBar:(BaseViewController *)baseViewController;

@end

@interface BaseViewController : UIViewController<NavigationBarDelegate, NavigationBarDataSource, BaseViewControllerDataSource>

@property (weak, nonatomic) NavigationBar *navigationBar;

@property (copy, nonatomic) NSString *navigationBarTitle;

@end
