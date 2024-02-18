//
//  PlayerDetailsMoreView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/20.
//

#import "PlayerDetailsMoreView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PlayerDetailsMoreSlider.h"
#import "Utils.h"

@interface PlayerDetailsMoreView ()

@property (nonatomic, strong) UIScrollView *containsView;

@property (nonatomic, strong) UIView *playLineView;
@property (nonatomic, strong) UILabel *speedLabel;

@property (nonatomic, strong) UISegmentedControl *speedSegmentedControl;

@property (nonatomic, strong) UIView *lineView;
/*
 * 声音滑动
 */
@property (nonatomic, strong) UIImageView *leftVolumeIV;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) UIImageView *rightVolumeIV;

/*
 * 亮度滑动滑动
 */
@property (nonatomic, strong) UIImageView *leftBrightIV;
@property (nonatomic, strong) UISlider *brightSlider;
@property (nonatomic, strong) UIImageView *rightBrightIV;

/*
 * 功能 ： 声音设置
 */
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;

@property (nonatomic, strong) UILabel *tipLabel;        //提示信息
//填充模式
@property (nonatomic, strong) UIView *scalingLineView;
@property (nonatomic, strong) UILabel *scalingLabel;
@property (nonatomic, strong) UISegmentedControl *scalingSegmentedControl;

//循环播放
@property (nonatomic, strong) UIView *loopLineView;
@property (nonatomic, strong) UILabel *loopLabel;
@property (nonatomic, strong) UISegmentedControl *loopSegmentedControl;

@end

@implementation PlayerDetailsMoreView

#pragma mark - Get & Set

- (UIScrollView *)containsView {
    if (!_containsView) {
        _containsView = [[UIScrollView alloc] init];
        _containsView.showsVerticalScrollIndicator = NO;
        _containsView.backgroundColor = [UIColor colorWithRed:28.0 / 255.0 green:31.0 / 255.0 blue:33.0 / 255.0 alpha:0.90];
    }
    return _containsView;
}

- (UIView *)playLineView {
    if (!_playLineView) {
        _playLineView = [[UIView alloc] init];
        _playLineView.backgroundColor = [UIColor grayColor];
    }
    return _playLineView;
}

- (UILabel *)speedLabel {
    if (!_speedLabel) {
        _speedLabel = [[UILabel alloc] init];
        _speedLabel.backgroundColor = [UIColor colorWithRed:28.0 / 255.0 green:31.0 / 255.0 blue:33.0 / 255.0 alpha:0.90];
        _speedLabel.textAlignment = NSTextAlignmentCenter;
        _speedLabel.text = [@"倍速播放" localString];
        _speedLabel.textColor = [UIColor whiteColor];
        _speedLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _speedLabel;
}

- (UISegmentedControl *)speedSegmentedControl {
    if (!_speedSegmentedControl) {
        _speedSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"1.0X", @"0.5X", @"1.5X", @"2.0X"]];
        _speedSegmentedControl.backgroundColor = [UIColor clearColor];
//        [UIColor colorWithRed:28.0/255.0 green:31.0/255.0 blue:33.0/255.0 alpha:0.90];
        _speedSegmentedControl.selectedSegmentIndex = 0;
        _speedSegmentedControl.tintColor = [UIColor clearColor];
        NSDictionary *selectedTextAttributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                                  NSForegroundColorAttributeName: [UIColor colorWithHexString:@"00c1de"] };

        [_speedSegmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性

        NSDictionary *unselectedTextAttributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                                    NSForegroundColorAttributeName: [UIColor whiteColor] };

        [_speedSegmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    }
    return _speedSegmentedControl;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (UIImageView *)leftVolumeIV {
    if (!_leftVolumeIV) {
        _leftVolumeIV = [[UIImageView alloc] init];
        _leftVolumeIV.image = [UIImage imageNamed:@"player_volum_small"];
    }
    return _leftVolumeIV;
}

- (UISlider *)volumeSlider {
    if (!_volumeSlider) {
        _volumeSlider = [[PlayerDetailsMoreSlider alloc] init];
        [_volumeSlider setValue:self.musicPlayer.volume];
        [_volumeSlider setMinimumTrackTintColor:[UIColor colorWithHexString:@"00c1de"]];
    }
    return _volumeSlider;
}

- (UIImageView *)rightVolumeIV {
    if (!_rightVolumeIV) {
        _rightVolumeIV = [[UIImageView alloc] init];
        _rightVolumeIV.image = [UIImage imageNamed:@"player_volum"];
    }
    return _rightVolumeIV;
}

- (UIImageView *)leftBrightIV {
    if (!_leftBrightIV) {
        _leftBrightIV = [[UIImageView alloc] init];
        _leftBrightIV.image = [UIImage imageNamed:@"player_brightness_small"];
    }
    return _leftBrightIV;
}

- (UISlider *)brightSlider {
    if (!_brightSlider) {
        _brightSlider = [[PlayerDetailsMoreSlider alloc] init];
        [_brightSlider setValue:[UIScreen mainScreen].brightness];
        [_brightSlider setMinimumTrackTintColor:[UIColor colorWithHexString:@"00c1de"]];
    }
    return _brightSlider;
}

- (UIImageView *)rightBrightIV {
    if (!_rightBrightIV) {
        _rightBrightIV = [[UIImageView alloc] init];
        _rightBrightIV.image = [UIImage imageNamed:@"player_brightness"];
    }
    return _rightBrightIV;
}

- (MPMusicPlayerController *)musicPlayer {
    if (!_musicPlayer) {
        _musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    }
    return _musicPlayer;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14.0f];
        _tipLabel.backgroundColor = [UIColor blackColor];
        _tipLabel.textColor = [UIColor whiteColor];
    }
    return _tipLabel;
}

- (UIView *)scalingLineView {
    if (!_scalingLineView) {
        _scalingLineView = [[UIView alloc] init];
        _scalingLineView.backgroundColor = [UIColor grayColor];
    }
    return _scalingLineView;
}

- (UILabel *)scalingLabel {
    if (!_scalingLabel) {
        _scalingLabel = [[UILabel alloc] init];
        _scalingLabel.backgroundColor = [UIColor colorWithRed:28.0 / 255.0 green:31.0 / 255.0 blue:33.0 / 255.0 alpha:0.90];
        _scalingLabel.textAlignment = NSTextAlignmentCenter;
        _scalingLabel.text = [@"画面比例" localString];
        _scalingLabel.textColor = [UIColor whiteColor];
        _scalingLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _scalingLabel;
}

- (UISegmentedControl *)scalingSegmentedControl {
    if (!_scalingSegmentedControl) {
        _scalingSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[[@"默认" localString], [@"平铺" localString], [@"拉伸" localString]]];
        _scalingSegmentedControl.backgroundColor = [UIColor clearColor];
        _scalingSegmentedControl.selectedSegmentIndex = 0;
        _scalingSegmentedControl.tintColor = [UIColor clearColor];
        NSDictionary *selectedTextAttributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"00c1de"] };
        [_scalingSegmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary *unselectedTextAttributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName: [UIColor whiteColor] };
        [_scalingSegmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    }
    return _scalingSegmentedControl;
}

- (UIView *)loopLineView {
    if (!_loopLineView) {
        _loopLineView = [[UIView alloc] init];
        _loopLineView.backgroundColor = [UIColor grayColor];
    }
    return _loopLineView;
}

- (UILabel *)loopLabel {
    if (!_loopLabel) {
        _loopLabel = [[UILabel alloc] init];
        _loopLabel.backgroundColor = [UIColor colorWithRed:28.0 / 255.0 green:31.0 / 255.0 blue:33.0 / 255.0 alpha:0.90];
        _loopLabel.textAlignment = NSTextAlignmentCenter;
        _loopLabel.text = [@"循环播放" localString];
        _loopLabel.textColor = [UIColor whiteColor];
        _loopLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _loopLabel;
}

- (UISegmentedControl *)loopSegmentedControl {
    if (!_loopSegmentedControl) {
        _loopSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[[@"开启" localString], [@"关闭" localString]]];
        _loopSegmentedControl.backgroundColor = [UIColor clearColor];
        _loopSegmentedControl.selectedSegmentIndex = 1;
        _loopSegmentedControl.tintColor = [UIColor clearColor];
        NSDictionary *selectedTextAttributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"00c1de"] };
        [_loopSegmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
        NSDictionary *unselectedTextAttributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName: [UIColor whiteColor] };
        [_loopSegmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    }
    return _loopSegmentedControl;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self addSubview:self.tipLabel];
        [self addSubview:self.containsView];
        [self.containsView addSubview:self.playLineView];
        [self.containsView addSubview:self.speedLabel];
        [self.containsView addSubview:self.speedSegmentedControl];
        [self.containsView addSubview:self.lineView];
        [self.containsView addSubview:self.leftVolumeIV];
        [self.containsView addSubview:self.volumeSlider];
        [self.containsView addSubview:self.rightVolumeIV];
        [self.containsView addSubview:self.leftBrightIV];
        [self.containsView addSubview:self.brightSlider];
        [self.containsView addSubview:self.rightBrightIV];
        [self.containsView addSubview:self.scalingLineView];
        [self.containsView addSubview:self.scalingLabel];
        [self.containsView addSubview:self.scalingSegmentedControl];
        [self.containsView addSubview:self.loopLineView];
        [self.containsView addSubview:self.loopLabel];
        [self.containsView addSubview:self.loopSegmentedControl];
    }
    return self;
}

- (void)layoutSubviews {
//    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
//    CGFloat containsViewWidth = 300;
//    if ([Utils isInterfaceOrientationPortrait]) {
//        self.hidden = YES;
//    }
//
//    if (_containsView.frame.origin.x == width) {
//        return;
//    }
//    _containsView.frame = CGRectMake(width - containsViewWidth, 0, containsViewWidth, height);
//
//    _playLineView.frame = CGRectMake(0, CGRectGetMaxY(_downLoadBtn.frame) + 20, containsViewWidth, 1);
//    _speedLabel.frame = CGRectMake(0, 0, 70, 15);
//    _speedLabel.center = _playLineView.center;
//    _speedSegmentedControl.frame = CGRectMake(30, CGRectGetMaxY(_speedLabel.frame) + 20, containsViewWidth - 60, 30);
//    [_speedSegmentedControl addTarget:self action:@selector(speedSegmentedControlClicked:) forControlEvents:UIControlEventValueChanged];
//
//    _lineView.frame = CGRectMake(0, CGRectGetMaxY(_speedSegmentedControl.frame) + 20, containsViewWidth, 1);
//
//    _leftVolumeIV.frame = CGRectMake(30, CGRectGetMaxY(_lineView.frame) + 20, 30, 30);
//    _volumeSlider.frame = CGRectMake(CGRectGetMaxX(_leftVolumeIV.frame) + 10, CGRectGetMaxY(_lineView.frame) + 20, containsViewWidth - 2 * 30 - 2 * 10 - 2 * 30, 30);
//
//    [_volumeSlider addTarget:self action:@selector(volumeSliderChangeValue:) forControlEvents:UIControlEventValueChanged];
//    _rightVolumeIV.frame = CGRectMake(containsViewWidth - 30 - 30, CGRectGetMaxY(_lineView.frame) + 20, 30, 30);
//
//    _leftBrightIV.frame = CGRectMake(30, CGRectGetMaxY(_rightVolumeIV.frame) + 20, 30, 30);
//    _brightSlider.frame = CGRectMake(CGRectGetMaxX(_leftBrightIV.frame) + 10, CGRectGetMaxY(_rightVolumeIV.frame) + 20, containsViewWidth - 2 * 30 - 2 * 10 - 2 * 30, 30);
//
//    [_brightSlider addTarget:self action:@selector(brightSliderChangeValue:) forControlEvents:UIControlEventValueChanged];
//
//    _rightBrightIV.frame = CGRectMake(containsViewWidth - 30 - 30, CGRectGetMaxY(_rightVolumeIV.frame) + 20, 30, 30);
//
//    //画面比例
//    _scalingLineView.frame = CGRectMake(0, CGRectGetMaxY(_rightBrightIV.frame) + 20, containsViewWidth, 1);
//    _scalingLabel.frame = CGRectMake(0, 0, 70, 15);
//    _scalingLabel.center = _scalingLineView.center;
//    _scalingSegmentedControl.frame = CGRectMake(30, CGRectGetMaxY(_scalingLabel.frame) + 20, containsViewWidth - 60, 30);
//    [_scalingSegmentedControl addTarget:self action:@selector(scalingSegmentedControlClicked:) forControlEvents:UIControlEventValueChanged];
//
//    //循环播放
//    _loopLineView.frame = CGRectMake(0, CGRectGetMaxY(_scalingSegmentedControl.frame) + 20, containsViewWidth, 1);
//    _loopLabel.frame = CGRectMake(0, 0, 70, 15);
//    _loopLabel.center = _loopLineView.center;
//    _loopSegmentedControl.frame = CGRectMake(30, CGRectGetMaxY(_loopLabel.frame) + 20, containsViewWidth - 60, 30);
//    [_loopSegmentedControl addTarget:self action:@selector(loopSegmentedControlClicked:) forControlEvents:UIControlEventValueChanged];
//
//    self.containsView.contentSize = CGSizeMake(self.containsView.frame.size.width, CGRectGetMaxY(_loopSegmentedControl.frame) + 20);
}

- (void)speedSegmentedControlClicked:(UISegmentedControl *)sender {
    CGFloat speed = 1;
    switch (sender.selectedSegmentIndex) {
        case 0:
            speed = 1;
            break;
        case 1:
            speed = 0.5;
            break;
        case 2:
            speed = 1.5;
            break;
        case 3:
            speed = 2;
            break;
        default:
            break;
    }
    [self showSpeedViewSelectedPushInAnimateWithPlaySpeed:speed];
    if ([self.delegate respondsToSelector:@selector(moreView:speedChanged:)]) {
        [self.delegate moreView:self speedChanged:speed];
    }
}

- (void)scalingSegmentedControlClicked:(UISegmentedControl *)sender {
    [self showScalingViewSelectedPushInAnimateWithIndex:sender.selectedSegmentIndex];
    if ([self.delegate respondsToSelector:@selector(moreView:scalingIndexChanged:)]) {
        [self.delegate moreView:self scalingIndexChanged:sender.selectedSegmentIndex];
    }
}

- (void)loopSegmentedControlClicked:(UISegmentedControl *)sender {
    [self showLoopViewSelectedPushInAnimateWithIndex:sender.selectedSegmentIndex];
    if ([self.delegate respondsToSelector:@selector(moreView:loopIndexChanged:)]) {
        [self.delegate moreView:self loopIndexChanged:sender.selectedSegmentIndex];
    }
}

- (void)volumeSliderChangeValue:(UISlider *)sender {
    self.musicPlayer.volume = sender.value;
}

- (void)brightSliderChangeValue:(UISlider *)sender {
    [UIScreen mainScreen].brightness = sender.value;
}

//倍速播放界面入场、退场动画
//倍速播放界面 入场动画
- (void)showSpeedViewMoveInAnimate {
    [UIView animateWithDuration:0.3 animations:^{
        if ([Utils isInterfaceOrientationPortrait]) {//竖屏
            self.hidden = YES;
        } else {//横屏
            self.hidden = NO;
            CGRect frame = self.containsView.frame;
            frame.origin.x = self.width - 300;
            self.containsView.frame = frame;
        }
    } completion:^(BOOL finished) {
    }];
}

//倍速播放界面  退场动画
- (void)showSpeedViewPushInAnimate {
    if (!self.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            if ([Utils isInterfaceOrientationPortrait]) {
            } else {
                CGRect frame = self.containsView.frame;
                frame.origin.x = ScreenWidth;
                self.containsView.frame = frame;
            }
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

//倍速播放界面  退场动画
- (void)showSpeedViewPushInAnimateWithShowText:(NSString *)text {
    [UIView animateWithDuration:0.3 animations:^{
        if ([Utils isInterfaceOrientationPortrait]) {
            self.hidden = YES;
        } else {
            self.containsView.alpha = 0;
            CGRect frame = self.containsView.frame;
            frame.origin.x = ScreenWidth;
            self.containsView.frame = frame;
        }
    } completion:^(BOOL finished) {
        self.tipLabel.hidden = NO;
        NSString *title = text;
        self.tipLabel.text = title;
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:14], };
        CGSize textSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        self.tipLabel.frame = CGRectMake((self.width - textSize.width - 10) / 2, self.height - 75, textSize.width + 10, 40);
        [UIView animateWithDuration:2 animations:^{
            self.tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            self.tipLabel.hidden = YES;
            self.tipLabel.alpha = 1.0;
            self.hidden = YES;
            self.containsView.alpha = 1;
        }];
    }];
}

//倍速播放界面 选中选择倍速值后退出
- (void)showSpeedViewSelectedPushInAnimateWithPlaySpeed:(float)playSpeed {
    [self showSpeedViewPushInAnimateWithShowText:[self tipMessageWithSpeed:playSpeed]];
}

//画面比例播放界面 选中值后退出
- (void)showScalingViewSelectedPushInAnimateWithIndex:(NSInteger)index {
    [self showSpeedViewPushInAnimateWithShowText:[self tipMessageWithScalingIndex:index]];
}

//循环播放界面 选中值后退出
- (void)showLoopViewSelectedPushInAnimateWithIndex:(NSInteger)index {
    [self showSpeedViewPushInAnimateWithShowText:[self tipMessageWithloopIndex:index]];
}

- (NSString *)tipMessageWithSpeed:(float)speed {
    NSString *speedStr = @"";
    if (speed == 1) {
        speedStr = @"Nomal";
    } else if (speed == 0.5) {
        speedStr = @"0.5X";
    } else if (speed == 1.5) {
        speedStr = @"1.5X";
    } else if (speed == 2) {
        speedStr = @"2X";
    }
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@",
                       [@"the current video has swiched to" localString],
                       [speedStr localString],
                       [@"speed rate" localString]];
    return title;
}

- (NSString *)tipMessageWithScalingIndex:(NSInteger)index {
    NSString *scalingStr = @"";
    switch (index) {
        case 0:
            scalingStr = [@"默认" localString];
            break;
        case 1:
            scalingStr = [@"平铺" localString];
            break;
        case 2:
            scalingStr = [@"拉伸" localString];
            break;
        default:
            break;
    }
    NSString *title = [NSString stringWithFormat:@"%@ %@",
                       [@"画面比例切换至" localString], scalingStr];
    return title;
}

- (NSString *)tipMessageWithloopIndex:(NSInteger)index {
    NSString *scalingStr = @"";
    switch (index) {
        case 0:
            scalingStr = [@"开启" localString];
            break;
        case 1:
            scalingStr = [@"关闭" localString];
            break;
        default:
            break;
    }
    NSString *title = [NSString stringWithFormat:@"%@ %@", [@"循环播放" localString], scalingStr];
    return title;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if ([touch.view isKindOfClass:[PlayerDetailsMoreView class]]) {
        self.hidden = YES;
    }
}

@end
