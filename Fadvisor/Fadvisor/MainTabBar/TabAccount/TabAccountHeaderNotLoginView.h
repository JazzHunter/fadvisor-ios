//
//  TabAccountHeaderNotLogin.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/19.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@class TabAccountHeaderNotLoginView;
@protocol TabAccountHeaderNotLoginView <NSObject>

- (void)mainLoginClick:(TabAccountHeaderNotLoginView *)view;

@end

@interface TabAccountHeaderNotLoginView : MyLinearLayout

@property (nonatomic, weak) id<TabAccountHeaderNotLoginView> delegate;

@end

NS_ASSUME_NONNULL_END
