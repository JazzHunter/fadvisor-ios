//
//  AlyunVodProgressView.h
//

#import <UIKit/UIKit.h>
#import "PlayerControlSlider.h"

@class PlayerDetailsControlProgressView;
@protocol PlayerDetailsControlProgressViewDelegate <NSObject>

/*
 * 功能 ： 移动距离
   参数 ： dragProgressSliderValue slide滑动长度
          event 手势事件，点击-移动-离开
 */
- (void)progressView:(PlayerDetailsControlProgressView *)progressView dragProgressSliderValue:(float)value event:(UIControlEvents)event;

@end

@interface PlayerDetailsControlProgressView : UIView

@property (nonatomic, strong) PlayerControlSlider *slider;  //进度条，currentTime
@property (nonatomic, weak) id<PlayerDetailsControlProgressViewDelegate>delegate;
@property (nonatomic, assign) float progress;                  //设置sliderValue
@property (nonatomic, assign) float bufferedProgress;          //设置缓冲progress

@property (nonatomic, assign) long milliSeconds;
@property (nonatomic, strong) NSArray *insertTimeArray;
@property (nonatomic, assign) CGFloat duration;

- (float)getSliderValue;
/*
 * 功能 ：更新进度条
 * 参数 ：currentTime 当前播放时间
 durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime;

- (void)setDotWithTimeArray:(NSArray *)timeArray; // 添加打点
- (void)setDotsHidden:(BOOL)hidden;
- (void)removeDots;  // 移除打点

@end
