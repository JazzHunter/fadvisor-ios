//
//  DemoAudioCallViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/10.
//

#import "DemoAudioCallViewController.h"
#import "LJKAudioCallAssistiveTouchView.h"
@interface DemoAudioCallViewController ()<CAAnimationDelegate, LJKAudioCallAssistiveTouchViewDelegate>

@property (strong, nonatomic) LJKAudioCallAssistiveTouchView *touchView;
@property (strong, nonatomic) UIView *voiceView;

@end

@implementation DemoAudioCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor pwcPinkColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:[@"点击我" localString] forState:UIControlStateNormal];
    [btn setTarget:self action:@selector(showToast:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 200, 120);
    
    [self.view addSubview:btn];
}

- (void)showToast:(id)sender {
    [self showVoiceView];

    if (self.touchView) {
        [self animateTransitionShowVoiceView];
    }
}

- (void)showVoiceView {
    UIWindow *window = [LJKAudioCallAssistiveTouchView getCurrentWindow];

    self.voiceView = [[UIView alloc] initWithFrame:window.bounds];
    self.voiceView.backgroundColor = [UIColor blueColor];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [btn setTitle:@"最小化" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(showAssistiveTouchView) forControlEvents:UIControlEventTouchUpInside];

    [self.voiceView addSubview:btn];
    btn.center = self.voiceView.center;

    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y + 150, 100, 100)];
    [btn1 setTitle:@"结束对话" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [btn1 addTarget:self action:@selector(closeChat) forControlEvents:UIControlEventTouchUpInside];

    [self.voiceView addSubview:btn1];

    [window addSubview:self.voiceView];
}

- (void)closeChat {
    [UIView animateWithDuration:0.4 animations:^{
        self.voiceView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.voiceView removeFromSuperview];
        [self.touchView removeFromSuperview];
        self.voiceView = nil;
        self.touchView = nil;
    }];
}

- (void)showAssistiveTouchView {
    if (!self.touchView) {
        self.touchView = [[LJKAudioCallAssistiveTouchView alloc] initDefaultTypeWithBegainDate:[[NSDate alloc] init]];
        self.touchView.delegate = self;
        [[LJKAudioCallAssistiveTouchView getCurrentWindow] addSubview:self.touchView];
    } else {
        [self.touchView setHidden:NO];
    }

    [self animateTransitionShowAssistiveTouchView];
}

- (void)assistiveTouchViewClicked {
    [self showVoiceView];

    [self animateTransitionShowVoiceView];
}

- (void)animateTransitionShowAssistiveTouchView {
    //浮窗的 frame push时这个是起始 frame ,pop时是结束时的 frame
    self.touchView.alpha = 0;
    CGRect floatBallRect = self.touchView.frame;
    //开始/结束时的曲线
    UIBezierPath *maskFinalBP =  [UIBezierPath bezierPathWithRoundedRect:CGRectMake(floatBallRect.origin.x, floatBallRect.origin.y, floatBallRect.size.width, floatBallRect.size.height) cornerRadius:floatBallRect.size.height / 2];
    UIBezierPath *maskStartBP = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.voiceView.bounds.size.width, self.voiceView.bounds.size.height) cornerRadius:floatBallRect.size.width / 2];
    //.layer.mask 是部分显示的原因
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath;
    self.voiceView.layer.mask = maskLayer;
    //动画类
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = 0.5;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    //隐藏浮窗
    [UIView animateWithDuration:0.4 animations:^{
        self.voiceView.alpha = 0;
        self.touchView.alpha = 1;
    }];
}

- (void)animateTransitionShowVoiceView {
    self.voiceView.alpha = 0;

    //浮窗的 frame push时这个是起始 frame ,pop时是结束时的 frame
    CGRect floatBallRect = self.touchView.frame;
    //开始/结束时的曲线
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithRoundedRect:CGRectMake(floatBallRect.origin.x, floatBallRect.origin.y, floatBallRect.size.width, floatBallRect.size.height) cornerRadius:floatBallRect.size.height / 2];
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.voiceView.bounds.size.width, self.voiceView.bounds.size.height) cornerRadius:floatBallRect.size.width / 2];
    //.layer.mask 是部分显示的原因
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath;
    self.voiceView.layer.mask = maskLayer;
    //动画类
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = 0.5;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    //隐藏浮窗
    [UIView animateWithDuration:0.4 animations:^{
        self.voiceView.alpha = 1;
        self.touchView.alpha = 0;
    }];
}

#pragma mark - CABasicAnimation的Delegate
//动画完成后代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.voiceView.alpha == 0) {
        [self.voiceView removeFromSuperview];
    }

    if (self.touchView.alpha == 0) {
        [self.touchView setHidden:YES];
    }
}

@end
