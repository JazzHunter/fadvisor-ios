//
//  PlayerDetailsGestureView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PlayerDetailsGestureView;

@protocol PlayerDetailsGestureViewDelegate <NSObject>

//单击屏幕
- (void)onSingleTapWithGestureView:(PlayerDetailsGestureView *)gestureView;

//双击屏幕
- (void)onDoubleTapWithGestureView:(PlayerDetailsGestureView *)gestureView;

//手势水平移动中
- (void)onHorizontalMovingWithGestureView:(PlayerDetailsGestureView *)gestureView offset:(float)moveOffset;

//手势水平结束
- (void)onHorizontalMoveEndWithGestureView:(PlayerDetailsGestureView *)gestureView offset:(float)moveOffset;

@end

@interface PlayerDetailsGestureView : UIView

@property (nonatomic, weak) id<PlayerDetailsGestureViewDelegate>delegate;

- (void)resetLayout:(BOOL)isPortrait;

@end

NS_ASSUME_NONNULL_END
