//
//  AliyunVodSlider.h
//

#import <UIKit/UIKit.h>

@class PlayerControlSlider;

@protocol PlayerControlSliderDelegate <NSObject>

- (void)slider:(PlayerControlSlider *)slider event:(UIControlEvents)event value:(float)value;

@end

@interface PlayerControlSlider : UISlider

@property (nonatomic, weak) id<PlayerControlSliderDelegate>delegate;

@property (nonatomic, assign, readonly) CGFloat beginPressValue;// 手势刚开始的value


@end
