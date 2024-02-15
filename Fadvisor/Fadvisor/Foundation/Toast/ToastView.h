//
//  AVToastView.h
//  ApsaraVideo
//
//  Created by Bingo on 2021/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ToastViewPosition) {
    ToastViewPositionTop,
    ToastViewPositionMid,
    ToastViewPositionBottom,
};

@interface ToastView : UIView

@property (nonatomic, strong, readonly) UILabel *toastLabel;


+ (ToastView *)show:(NSString *)toast view:(UIView *)view position:(ToastViewPosition)position;

@end

NS_ASSUME_NONNULL_END
