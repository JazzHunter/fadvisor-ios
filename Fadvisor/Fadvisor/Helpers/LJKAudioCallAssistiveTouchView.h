//
//  LJKAudioCallAssistiveTouchView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LJKAudioCallAssistiveTouchViewDelegate <NSObject>

@optional

- (void)assistiveTouchViewClicked;

@end

@interface LJKAudioCallAssistiveTouchView : UIView
- (instancetype)initDefaultTypeWithBegainDate:(NSDate *)date;

+ (UIWindow *)getCurrentWindow;

@property (weak, nonatomic) id<LJKAudioCallAssistiveTouchViewDelegate> delegate;

@end
NS_ASSUME_NONNULL_END
