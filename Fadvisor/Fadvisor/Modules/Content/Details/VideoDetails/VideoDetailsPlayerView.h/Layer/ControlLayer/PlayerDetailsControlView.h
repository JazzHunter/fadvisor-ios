//
//  AliyunControlView.h
//

#import <UIKit/UIKit.h>
#import <AliyunPlayer/AliyunPlayer.h>
#import "PlayerDetailsControlTopView.h"
#import "PlayerDetailsControlBottomView.h"
#import "PlayerDetailsQualityListView.h"

@class PlayerDetailsControlView;

@protocol PlayerDetailsControlViewDelegate <NSObject>

/*
 * 功能 ： 点击下载按钮
 * 参数 ： controlView 对象本身
 */
- (void)onDownloadButtonClickWithControlView:(PlayerDetailsControlView *)controlView;

/*
 * 功能 ： 点击返回按钮
 * 参数 ： controlView 对象本身
 */
- (void)onBackViewClickWithControlView:(PlayerDetailsControlView *)controlView;

/*
 * 功能 ： 展示倍速播放界面
 * 参数 ： controlView 对象本身
 */
- (void)onSpeedViewClickedWithControlView:(PlayerDetailsControlView *)controlView;

/*
 * 功能 ： 播放按钮
 * 参数 ： controlView 对象本身
 */
- (void)onClickedPlayButtonWithControlView:(PlayerDetailsControlView *)controlView;

/*
 * 功能 ： 全屏
 * 参数 ： controlView 对象本身
 */
- (void)onClickedfullScreenButtonWithControlView:(PlayerDetailsControlView *)controlView;

/*
 * 功能 ： 锁屏
 * 参数 ： controlView 对象本身
 */
- (void)onLockButtonClickedWithControlView:(PlayerDetailsControlView *)controlView;

/*
 * 功能 ： 截图
 * 参数 ： controlView 对象本身
 */
- (void)onSnapshopButtonClickedWithControlView:(PlayerDetailsControlView *)controlView;

/*
 * 功能 ： 拖动进度条
 * 参数 ： controlView 对象本身
          progressValue slide滑动长度
          event 手势事件，点击-移动-离开
 */
- (void)controlView:(PlayerDetailsControlView *)controlView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event;

/*
 * 功能 ： 清晰度切换
 * 参数 ： index 选择的清晰度
 */
- (void)controlView:(PlayerDetailsControlView *)controlView qualityListViewOnItemClick:(int)index;

- (void)controlView:(PlayerDetailsControlView *)controlView selectTrackIndex:(NSInteger)trackIndex;

@end

@interface PlayerDetailsControlView : UIView

@property (nonatomic, strong) PlayerDetailsControlTopView *topView; //topView
@property (nonatomic, strong) PlayerDetailsControlBottomView *bottomView;       //bottomView
@property (nonatomic, weak) id<PlayerDetailsControlViewDelegate>delegate;
@property (nonatomic, strong) AVPMediaInfo *videoInfo;      //播放数据
@property (nonatomic, strong) NSArray<AVPTrackInfo *> *info;
@property (nonatomic, assign) AVPStatus state;                      //播放器播放状态
@property (nonatomic, copy) NSString *title;                        //设置标题
@property (nonatomic, assign) float bufferedProgress;               //缓存进度
@property (nonatomic, assign) BOOL isProtrait;                      //竖屏判断
@property (nonatomic, strong) UIButton *lockButton;                 //锁屏按钮
@property (nonatomic, strong) UIButton *snapshopButton;             //截图按钮
@property (nonatomic, strong) PlayerDetailsQualityListView *qualityListView;    //清晰度列表view

@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign) AlvcPlayMethod playMethod; //播放方式

/*
 * 功能 ：更新播放器状态
 */
- (void)updateViewWithPlayerState:(AVPStatus)state isScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;

/*
 * 功能 ：更新进度条
 */
- (void)updateProgressWithCurrentTime:(NSTimeInterval)currentTime durationTime:(NSTimeInterval)durationTime;

/*
 * 功能 ：更新当前时间
 */
- (void)updateCurrentTime:(NSTimeInterval)currentTime durationTime:(NSTimeInterval)durationTime;

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentQuality:(int)quality;

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentDefinition:(NSString *)videoDefinition;

/*
 * 功能 ：是否禁用手势（双击、滑动)
 */
- (void)setEnableGesture:(BOOL)enableGesture;

/*
 * 功能 ：隐藏topView、bottomView
 */
- (void)hiddenView;

/*
 * 功能 ：展示topView、bottomView
 */
- (void)showView;
/*
 * 功能 ：展示topView、bottomView 不会自动隐藏
 */
- (void)showViewWithOutDelayHide;
/*
 * 功能 ：锁屏
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;

/*
 * 功能 ：取消锁屏
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;
/*
 * 功能 ：设置页面上的按钮是否可以点击
 */
- (void)setButtonEnable:(BOOL)enable;

- (void)setQualityButtonTitle:(NSString *)title;

- (void)setBottomViewTrackInfo:(AVPTrackInfo *)trackInfo;

- (void)loopViewPause;
- (void)loopViewStart;
- (void)loopViewStartAnimation;

- (void)isShowLoopView:(BOOL)show;

@end
