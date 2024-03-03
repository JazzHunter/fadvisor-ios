//
//  AlyunVodBottomView.h
//

#import <UIKit/UIKit.h>
#import <MyLayout/MyLayout.h>
#import "AliyunPlayer/AliyunPlayer.h"

@class PlayerDetailsControlBottomView;

@protocol PlayerDetailsControlBottomViewDelegate <NSObject>
/*
 * 功能 ：进度条滑动 偏移量
 * 参数 ：progressValue 偏移量
         event 手势事件，点击-移动-离开
 */
- (void)onBottomViewSliderDrag:(UISlider *)sender progress:(float)progress event:(UIControlEvents)event;

/*
 * 功能 ：点击全屏按钮
 * 参数 ：bottomView 对象本身
 */
- (void)onBottomViewFullScreenButtonClicked:(UIButton *)sender bottomView:(PlayerDetailsControlBottomView *)bottomView;

/*
 * 功能 ：点击播放按钮
 * 参数 ：bottomView 对象本身
 */
- (void)onBottomViewPlayButtonClicked:(UIButton *)sender bottomView:(PlayerDetailsControlBottomView *)bottomView;

@end

@interface PlayerDetailsControlBottomView : MyRelativeLayout;

@property (nonatomic, weak) id<PlayerDetailsControlBottomViewDelegate>delegate;

/*
 * 设置垂直 / 水平布局
 */

- (void)resetLayout:(BOOL)isPortrait;

/*
 * 功能 ：播放器按钮action
 */
- (void)playButtonClicked:(UIButton *)sender;

/*
 * 功能 ：更新进度条与时间
 * 参数 ：currentTime 当前播放时间
         durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime;

/*
 * 功能 ：根据播放器状态，改变状态
 * 参数 ：state 播放器状态
 */
- (void)updatePlayerStatus:(AVPStatus)status;


- (void)setProgress:(float)progress;

- (float)progress;

- (void)setBufferedProgress:(float)bufferedProgress;

@end
