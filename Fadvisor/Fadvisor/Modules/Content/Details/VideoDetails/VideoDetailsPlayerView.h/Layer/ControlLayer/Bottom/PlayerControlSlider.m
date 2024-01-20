//
//  AliyunVodSlider.m
//

#import "PlayerControlSlider.h"

@interface PlayerControlSlider ()

@property (nonatomic, assign) CGFloat changedValue;

@end

@implementation PlayerControlSlider

- (void)press:(UITapGestureRecognizer *)press {
    CGPoint touchPoint = [press locationInView:self];
    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.x / self.width);
    if (value < 0) {
        value = 0;
    } else if (value > 1) {
        value = 1;
    }

    switch (press.state) {
        case UIGestureRecognizerStateBegan:
            _beginPressValue = self.value;
            if ([self.delegate respondsToSelector:@selector(slider:event:value:)]) {
                [self.delegate slider:self event:UIControlEventTouchDown value:value];
            }
            break;
        case UIGestureRecognizerStateChanged:
            _changedValue = value;
            if ([self.delegate respondsToSelector:@selector(slider:event:value:)]) {
                [self.delegate slider:self event:UIControlEventValueChanged value:value];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if ([self.delegate respondsToSelector:@selector(slider:event:value:)]) {
                [self.delegate slider:self event:UIControlEventTouchUpInside value:value];
            }
            break;
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStateCancelled:
            if ([self.delegate respondsToSelector:@selector(slider:event:value:)]) {
                [self.delegate slider:self event:UIControlEventTouchUpInside value:_changedValue];
            }
            break;

        default:
            break;
    }
}

@end
