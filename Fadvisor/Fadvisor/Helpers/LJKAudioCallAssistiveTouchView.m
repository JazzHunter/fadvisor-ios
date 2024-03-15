//
//  LJKAudioCallAssistiveTouchView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/10.
//

#import "LJKAudioCallAssistiveTouchView.h"
#define WIDTH             self.frame.size.width
#define HEIGHT            self.frame.size.height
#define defaultHeight     80
#define leftAndRightSpace 12

@interface LJKAudioCallAssistiveTouchView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSDate *begainDate;
@property (nonatomic) dispatch_source_t dispatchTimer;

@end

@implementation LJKAudioCallAssistiveTouchView

- (void)removeFromSuperview {
    [super removeFromSuperview];

    dispatch_source_cancel(self.dispatchTimer);
    self.dispatchTimer = nil;
}

- (instancetype)initDefaultTypeWithBegainDate:(NSDate *)date {
    if (self = [super init]) {
        self.begainDate = date;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(kScreenWidth - leftAndRightSpace - defaultHeight, [LJKAudioCallAssistiveTouchView iPhoneTopMargin] + 56, defaultHeight, defaultHeight);
        self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.06].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 5;

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, defaultHeight, defaultHeight)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = 8;
        [self addSubview:backView];

        _imageView = [[UIImageView alloc]initWithFrame:(CGRect) { 25, 16, 32, 32 }];
//        _imageView.image = [UIImage imageNamed:@"audioCall_voice_fold"];
        _imageView.image = [UIImage imageNamed:@"default_user_bg"];
        [backView addSubview:_imageView];

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, self.frame.size.width, 20)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setTextColor:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1]];
        _timeLabel.text = @"正在接通";
        [backView addSubview:_timeLabel];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tap];

        //开始计时的时机可以自行调节
        self.dispatchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());

        dispatch_source_set_timer(self.dispatchTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);

        dispatch_source_set_event_handler(self.dispatchTimer, ^{
            [self getCurrentTimeLength];
        });

        dispatch_resume(self.dispatchTimer);
    }
    return self;
}

- (void)getCurrentTimeLength {
    NSTimeInterval lateTime = [self.begainDate timeIntervalSince1970];

    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentTime = [currentDate timeIntervalSince1970];

    NSTimeInterval cha = currentTime - lateTime;

    int sec = (int)cha % 60;
    int min = (int)cha / 60 % 60;

    NSString *differTime = [NSString stringWithFormat:@"%02d:%02d", min, sec];

    self.timeLabel.text = differTime;
}

//改变位置
- (void)locationChange:(UIPanGestureRecognizer *)p
{
    CGPoint panPoint = [p locationInView:[LJKAudioCallAssistiveTouchView getCurrentWindow]];

    if (p.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    } else if (p.state == UIGestureRecognizerStateEnded) {
        CGFloat iPhoneTopMargin = [LJKAudioCallAssistiveTouchView iPhoneTopMargin];

        CGFloat iPhoneBottomMargin = [LJKAudioCallAssistiveTouchView iPhoneBottomMargin];

        if (panPoint.x <= kScreenWidth / 2) {
            if (panPoint.y < iPhoneTopMargin + HEIGHT / 2) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(WIDTH / 2 + leftAndRightSpace, iPhoneTopMargin + HEIGHT / 2);
                }];
            } else if (panPoint.y >= kScreenHeight - HEIGHT / 2 - iPhoneBottomMargin) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(WIDTH / 2 + leftAndRightSpace, kScreenHeight - HEIGHT / 2 - iPhoneBottomMargin);
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(WIDTH / 2 + leftAndRightSpace, panPoint.y);
                }];
            }
        } else if (panPoint.x > kScreenWidth / 2) {
            if (panPoint.y <= iPhoneTopMargin + HEIGHT / 2) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(kScreenWidth - WIDTH / 2 - leftAndRightSpace, iPhoneTopMargin + HEIGHT / 2);
                }];
            } else if (panPoint.y > kScreenHeight - HEIGHT / 2 - iPhoneBottomMargin) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(kScreenWidth - WIDTH / 2 - leftAndRightSpace, kScreenHeight - HEIGHT / 2 - iPhoneBottomMargin);
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.center = CGPointMake(kScreenWidth - WIDTH / 2 - leftAndRightSpace, panPoint.y);
                }];
            }
        }
    }
}

//点击事件
- (void)click:(UITapGestureRecognizer *)t
{
    if ([self.delegate respondsToSelector:@selector(assistiveTouchViewClicked)]) {
        [self.delegate assistiveTouchViewClicked];
    }
}

+ (CGFloat)iPhoneTopMargin {
    if (@available(iOS 11.0, *)) {
        return [self getCurrentWindow].safeAreaInsets.top;
    } else {
        return 20;
    }
}

+ (CGFloat)iPhoneBottomMargin {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}

+ (UIWindow *)getCurrentWindow {
    __block UIWindow *window;

    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication].connectedScenes enumerateObjectsUsingBlock:^(UIScene *_Nonnull obj, BOOL *_Nonnull stop) {
            if (obj.activationState == UISceneActivationStateForegroundActive &&
                [obj isKindOfClass:UIWindowScene.self]) {
                UIWindowScene *windowScene = (UIWindowScene *)obj;
                NSArray<UIWindow *> *windows = windowScene.windows;
                for (UIWindow *win in windows) {
                    if ([win isKeyWindow]) {
                        window = win;
                        *stop = true;
                        break;
                    }
                }
            }
        }];

        if (window == nil) {
            NSArray<UIWindow *> *windows = [[UIApplication sharedApplication]windows];
            for (UIWindow *win in windows) {
                if ([win isKeyWindow]) {
                    window = win;
                    break;
                }
            }
        }
    } else {
        window = [[UIApplication sharedApplication]keyWindow];
    }

    return window;
}

@end
