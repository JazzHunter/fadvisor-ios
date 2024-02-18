//
//  PlayerDetailsMoreView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class PlayerDetailsMoreView;
@protocol PlayerDetailsMoreViewDelegate <NSObject>

- (void)moreView:(PlayerDetailsMoreView *)moreView speedChanged:(float)speedValue;

- (void)moreView:(PlayerDetailsMoreView *)moreView scalingIndexChanged:(NSInteger)index;

- (void)moreView:(PlayerDetailsMoreView *)moreView loopIndexChanged:(NSInteger)index;

@end

@interface PlayerDetailsMoreView : UIView
@property (nonatomic, weak) id<PlayerDetailsMoreViewDelegate>delegate;

- (void)showWithAnimate:(BOOL)isAnimate;
- (void)hideWithAnimate:(BOOL)isAnimate;

@end

NS_ASSUME_NONNULL_END
