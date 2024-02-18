//
//  PlayerDetailsGestureView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/15.
//

#import "PlayerDetailsGestureView.h"
#import "PlayerZFVolumeBrightnessView.h"
#import "AlivcPlayerManager.h"
#import "PlayerSpeedSwipeView.h"

@interface PlayerDetailsGestureView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *singleTapGesture;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) BOOL isVerticalGesture;
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, strong) PlayerZFVolumeBrightnessView *volumeBrightnessView;
@property (nonatomic, strong) PlayerSpeedSwipeView *speedSwiper;
@property (nonatomic, assign) CGFloat currentSpeed;

@end

@implementation PlayerDetailsGestureView

#pragma mark - set And get
- (UITapGestureRecognizer *)singleTapGesture
{
    if (!_singleTapGesture) {
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingeleTap:)];
        [_doubleTapGesture setNumberOfTapsRequired:1];
    }
    return _singleTapGesture;
}

- (UITapGestureRecognizer *)doubleTapGesture
{
    if (!_doubleTapGesture) {
        _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        [_doubleTapGesture setNumberOfTapsRequired:2];
    }
    return _doubleTapGesture;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    }
    return _panGesture;
}

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    }
    return _longPressGesture;
}

- (PlayerZFVolumeBrightnessView *)volumeBrightnessView {
    if (!_volumeBrightnessView) {
        _volumeBrightnessView = [[PlayerZFVolumeBrightnessView alloc] init];
        _volumeBrightnessView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _volumeBrightnessView.hidden = YES;
    }
    return _volumeBrightnessView;
}

- (PlayerSpeedSwipeView *)speedSwiper {
    if (!_speedSwiper) {
        _speedSwiper = [[PlayerSpeedSwipeView alloc] initWithFrame:CGRectMake(0, 0, 130, 36)];
        _speedSwiper.backgroundColor = [UIColor colorFromHexString:@"FF00FF"];
    }
    return _speedSwiper;
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addGestureRecognizer:self.singleTapGesture];
        [self addGestureRecognizer:self.doubleTapGesture];
        [self addGestureRecognizer:self.panGesture];
        [self addGestureRecognizer:self.longPressGesture];

        self.panGesture.delegate = self;
        [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
        [self.singleTapGesture requireGestureRecognizerToFail:self.panGesture];
        [self.singleTapGesture requireGestureRecognizerToFail:self.longPressGesture];
    }
    return self;
}

- (void)onSingeleTap:(UITapGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSingleTapWithGestureView:)]) {
        [self.delegate onSingleTapWithGestureView:self];
    }
}

- (void)onDoubleTap:(UITapGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDoubleTapWithGestureView:)]) {
        [self.delegate onDoubleTapWithGestureView:self];
    }
}

- (void)onPan:(UIPanGestureRecognizer *)sender
{
    CGPoint velocity = [sender velocityInView:self];
    CGPoint tranPoint = [sender translationInView:self];//播放进度,左右
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);

            self.isLeft = [sender locationInView:self].x < self.width / 2;
            self.isVerticalGesture = isVerticalGesture;

            if (isVerticalGesture) {
                [self addSubview:self.volumeBrightnessView];
                self.volumeBrightnessView.frame = CGRectMake((self.bounds.size.width - 160) / 2, 88, 160, 24);
                self.volumeBrightnessView.hidden = NO;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint velocity = [sender velocityInView:self];
            if (self.isVerticalGesture) {
                if (self.isLeft) {
                    CGFloat brightness = [UIScreen mainScreen].brightness;
                    brightness += (-velocity.y / 10000);
                    [self.volumeBrightnessView updateProgress:brightness withVolumeBrightnessType:ZFVolumeBrightnessTypeumeBrightness];
                    [UIScreen mainScreen].brightness = brightness;
                } else {
                    [self.volumeBrightnessView addSystemVolumeView];
                    CGFloat volume = [AlivcPlayerManager manager].volume / 2.0;
                    volume += (-velocity.y / 10000);
                    [self.volumeBrightnessView updateProgress:volume withVolumeBrightnessType:ZFVolumeBrightnessTypeVolume];
                    [AlivcPlayerManager manager].volume = volume * 2;
                }
                break;
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(onHorizontalMovingWithGestureView:offset:)]) {
                [self.delegate onHorizontalMovingWithGestureView:self offset:velocity.x];
            }
            
        } break;
        case UIGestureRecognizerStateEnded:
            if (self.delegate && [self.delegate respondsToSelector:@selector(onHorizontalMoveEndWithGestureView:offset:)]) {
                [self.delegate onHorizontalMoveEndWithGestureView:self offset:velocity.x];
            }
            break;
        default:
            break;
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.currentSpeed = [AlivcPlayerManager manager].rate;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        [AlivcPlayerManager manager].rate = 2.0;
        [self showSpeedSwiperAtDirection:YES isChange:YES];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self hideSpeedSwiper];
        [AlivcPlayerManager manager].rate = self.currentSpeed;
    }
}

- (void)showSpeedSwiperAtDirection:(BOOL)right isChange:(BOOL)isChange {
    [self hideSpeedSwiper];
    self.speedSwiper.frame = CGRectMake((self.width - 130) / 2.0, 36, 130, 36);
    [self addSubview:self.speedSwiper];
    [self.speedSwiper updateDirection:YES speed:@"2X"];
}

- (void)hideSpeedSwiper {
    if (_speedSwiper) {
        [self.speedSwiper removeFromSuperview];
        _speedSwiper = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGesture) {
        CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
        //保留右边返回手势
        if (point.x <= 36) {
            return NO;
        }
        return YES;
    }

    return YES;
}

@end
