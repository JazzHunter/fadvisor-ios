//
//  AlyunVodProgressView.m
//

#import "PlayerDetailsControlProgressView.h"

static const CGFloat PlayerDetailsControlProgressViewLoadtimeViewLeft = 3;    //loadtimeView 左侧距离父视图距离
static const CGFloat PlayerDetailsControlProgressViewLoadtimeViewTop = 23;    //loadtimeView 顶部距离父视图距离
static const CGFloat PlayerDetailsControlProgressViewLoadtimeViewHeight = 2;      //loadtimeView 高度
static const CGFloat PlayerDetailsControlProgressViewSliderTop = 12;          //slider 顶部距离父视图距离
static const CGFloat PlayerDetailsControlProgressViewSliderHeight = 24;       //slider 高度

@interface PlayerDetailsControlProgressView ()<PlayerControlSliderDelegate>

@property (nonatomic, strong) UIProgressView *bufferedView; //缓冲条，bufferedView
@property (nonatomic, strong) NSMutableArray *dotsViewArray;
@property (nonatomic, strong) NSArray *dotsTimeArray;

@end

@implementation PlayerDetailsControlProgressView

- (UIProgressView *)bufferedView {
    if (!_bufferedView) {
        _bufferedView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _bufferedView.progress = 0.0;
        _bufferedView.trackTintColor = [UIColor clearColor];
        //设置轨道的颜色
        _bufferedView.progressTintColor = [UIColor whiteColor];
    }
    return _bufferedView;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[PlayerControlSlider alloc] init];
        _slider.value = 0.0;
        //thumb左侧条的颜色
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:@"00c1de"];
        _slider.maximumTrackTintColor = [UIColor colorWithWhite:0.5 alpha:0.2];
        //thumb图片
        [_slider setThumbImage:[UIImage imageNamed:@"player_radio_normal"] forState:UIControlStateNormal];
        //手指落下
        [_slider addTarget:self action:@selector(sliderDownAction:) forControlEvents:UIControlEventTouchDown];
        //手指抬起
        [_slider addTarget:self action:@selector(progressSliderUpAction:) forControlEvents:UIControlEventTouchUpInside];
        //value发生变化
        [_slider addTarget:self action:@selector(updateProgressSliderAction:) forControlEvents:UIControlEventValueChanged];

        [_slider addTarget:self action:@selector(cancelProgressSliderAction:) forControlEvents:UIControlEventTouchCancel];
        _slider.userInteractionEnabled = YES;
        //手指在外面抬起
        [_slider addTarget:self action:@selector(updateProgressUpOutsideSliderAction:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _slider;
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bufferedView];
        self.slider.delegate = self;
        [self addSubview:self.slider];
    }
    return self;
}

- (void)setDotWithTimeArray:(NSArray *)timeArray {
    self.dotsTimeArray = [[NSArray alloc]init];
    self.dotsTimeArray = timeArray;
    self.dotsViewArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < timeArray.count; ++i) {
        UIView *dotView = [[UIView alloc]init];
        dotView.hidden = YES;
        [self.dotsViewArray addObject:dotView];
        [self addSubview:dotView];
        dotView.backgroundColor = [UIColor redColor];
    }
}

- (void)setDotsHidden:(BOOL)hidden {
    for (UIView *view in self.dotsViewArray) {
        view.hidden = hidden;
    }
}

- (void)removeDots {
    for (UIView *view in self.dotsViewArray) {
        [view removeFromSuperview];
    }
    self.dotsViewArray = [[NSMutableArray alloc]init];
}

- (void)layoutSubviews {
    self.bufferedView.frame = CGRectMake(PlayerDetailsControlProgressViewLoadtimeViewLeft, PlayerDetailsControlProgressViewLoadtimeViewTop, self.bounds.size.width - 2 * PlayerDetailsControlProgressViewLoadtimeViewLeft, PlayerDetailsControlProgressViewLoadtimeViewHeight);
    self.slider.frame = CGRectMake(0, PlayerDetailsControlProgressViewSliderTop, self.bounds.size.width, PlayerDetailsControlProgressViewSliderHeight);
    self.slider.center = self.bufferedView.center;

    if (self.dotsViewArray.count > 0) {
        for (int i = 0; i < self.dotsTimeArray.count; ++i) {
            UIView *dotView = [self.dotsViewArray objectAtIndex:i];
            NSInteger time = [[self.dotsTimeArray objectAtIndex:i]integerValue];
            CGFloat second = self.duration / 1000;
            CGFloat x = time / second * (self.bounds.size.width - 2 * PlayerDetailsControlProgressViewLoadtimeViewLeft);
            x = x + PlayerDetailsControlProgressViewLoadtimeViewLeft;
            // dotView.frame = CGRectMake(x, PlayerDetailsControlProgressViewLoadtimeViewTop, 1, 2);
            dotView.frame = CGRectMake(x, PlayerDetailsControlProgressViewLoadtimeViewTop, 3, 2);
        }
    }
}

#pragma mark - 重写setter方法
- (void)setProgress:(float)progress {
    [self.slider setValue:progress animated:YES];
}

- (float)progress {
    return self.slider.value;
}

- (float)getSliderValue {
    return _slider.beginPressValue;
}

- (void)setBufferedProgress:(float)bufferedProgress {
    _bufferedProgress = bufferedProgress;
    [self.bufferedView setProgress:bufferedProgress];
}

#pragma mark - public method
/*
 * 功能 ：更新进度条
 * 参数 ：currentTime 当前播放时间
         durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime {
    if (durationTime == 0) {
        [self.slider setValue:0 animated:NO];
        self.slider.userInteractionEnabled = NO;
    } else {
        [self.slider setValue:currentTime / durationTime animated:YES];
        self.slider.userInteractionEnabled = YES;
    }
}

#pragma mark - slider action
- (void)sliderDownAction:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressView:dragProgressSliderValue:event:)]) {
        [self.delegate progressView:self dragProgressSliderValue:sender.value event:UIControlEventTouchDown];
    }
}

- (void)updateProgressSliderAction:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressView:dragProgressSliderValue:event:)]) {
        [self.delegate progressView:self dragProgressSliderValue:sender.value event:UIControlEventValueChanged];
    }
}

- (void)progressSliderUpAction:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressView:dragProgressSliderValue:event:)]) {
        [self.delegate progressView:self dragProgressSliderValue:sender.value event:UIControlEventTouchUpInside];
    }
}

- (void)updateProgressUpOutsideSliderAction:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressView:dragProgressSliderValue:event:)]) {
        [self.delegate progressView:self dragProgressSliderValue:sender.value event:UIControlEventTouchUpOutside];
    }
}

- (void)cancelProgressSliderAction:(UISlider *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressView:dragProgressSliderValue:event:)]) {
        [self.delegate progressView:self dragProgressSliderValue:sender.value event:UIControlEventTouchCancel];
    }
}

#pragma mark - slider delegate
- (void)slider:(PlayerControlSlider *)slider event:(UIControlEvents)event value:(float)value {
    if (self.delegate && [self.delegate respondsToSelector:@selector(progressView:dragProgressSliderValue:event:)]) {
        if (event ==  UIControlEventValueChanged) {
            [self.slider setValue:value animated:YES];
        }

        if (event == UIControlEventTouchDown) {
            [self.slider setValue:value animated:YES];
        }

        [self.delegate progressView:self dragProgressSliderValue:value event:event]; //实际是点击事件
    }
}

@end
