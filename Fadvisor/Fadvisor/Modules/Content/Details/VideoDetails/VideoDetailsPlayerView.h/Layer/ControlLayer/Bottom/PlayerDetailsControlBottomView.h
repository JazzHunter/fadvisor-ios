//
//  AlyunVodBottomView.h
//

#import <UIKit/UIKit.h>
#import "PlayerDetailsControlProgressView.h"
#import <AliyunPlayer/AliyunPlayer.h>

static const CGFloat BottomViewMargin = 8;                                             //间隙
static const CGFloat BottomViewFullScreenButtonWidth = 48;                             //全屏按钮宽度
static const CGFloat BottomViewQualityButtonWidth = 48 + BottomViewMargin * 2;    // 清晰度按钮宽度

@class PlayerDetailsControlBottomView;

@protocol PlayerDetailsControlBottomViewDelegate <NSObject>
/*
 * 功能 ：进度条滑动 偏移量
 * 参数 ：bottomView 对象本身
         progressValue 偏移量
         event 手势事件，点击-移动-离开
 */
- (void)bottomView:(PlayerDetailsControlBottomView *)bottomView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event;

/*
 * 功能 ：点击播放，返回代理
 * 参数 ：bottomView 对象本身
 */
- (void)onClickedPlayButtonWithBottomView:(PlayerDetailsControlBottomView *)bottomView;

/*
 * 功能 ：点击全屏按钮
 * 参数 ：bottomView 对象本身
 */
- (void)onClickedfullScreenButtonWithBottomView:(PlayerDetailsControlBottomView *)bottomView;

/*
 * 功能 ：点击清晰度按钮
 * 参数 ：bottomView 对象本身
         qulityButton 清晰度按钮
 */
- (void)bottomView:(PlayerDetailsControlBottomView *)bottomView qulityButton:(UIButton *)qulityButton;

- (void)onClickedVideoButtonWithBottomView:(PlayerDetailsControlBottomView *)bottomView;

- (void)onClickedAudioButtonWithBottomView:(PlayerDetailsControlBottomView *)bottomView;

@end

@interface PlayerDetailsControlBottomView : UIView

@property (nonatomic, weak) id<PlayerDetailsControlBottomViewDelegate>delegate;
@property (nonatomic, strong) AVPMediaInfo *videoInfo;      //播放器媒体数据
@property (nonatomic, strong) UIButton *qualityButton;              //清晰度按钮
@property (nonatomic, assign) float progress;                       //滑动progressValue值
@property (nonatomic, assign) float bufferedProgress;               //缓存progressValue
@property (nonatomic, assign) BOOL isPortrait;                      //竖屏判断

//码率 音轨
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *audioButton;

- (CGFloat)getSliderValue;

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
 * 功能 ：更新当前显示时间
 * 参数 ：currentTime 当前播放时间
 durationTime 播放总时长
 */
- (void)updateCurrentTime:(float)currentTime durationTime:(float)durationTime;

/*
 * 功能 ：根据播放器状态，改变状态
 * 参数 ：state 播放器状态
 */
- (void)updateViewWithPlayerState:(AVPStatus)state;

/*
 * 功能 ：锁屏状态
 * 参数 ：isScreenLocked 是否是锁屏状态
 fixedPortrait 是否是绝对竖屏状态
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;

/*
 * 功能 ：取消锁屏
 * 参数 ：isScreenLocked 是否是锁屏状态
         fixedPortrait 是否是绝对竖屏状态
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;

// 初s信息
- (void)setCurrentTrackInfo:(AVPTrackInfo *)trackInfo;

@end
