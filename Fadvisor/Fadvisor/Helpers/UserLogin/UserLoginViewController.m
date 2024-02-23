//
//  UserLoginViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/19.
//

#import "UserLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MaskedLoginButton.h"
#import <MyLayout/MyLayout.h>
#import "RSMaskedLabel.h"

@interface UserLoginViewController ()

@property (nonatomic, strong) AVPlayer *player; /**< 媒体播放器 */
@end

@implementation UserLoginViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(becomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initPlayer];

    [self initGesture];

    MyRelativeLayout *rootLayout = [[MyRelativeLayout alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:rootLayout];

    MaskedLoginButton *button = [[MaskedLoginButton alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [button addTarget:self action:@selector(handleLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setText:@"点我登录" ];
    button.centerXPos.equalTo(rootLayout.centerXPos);
    button.bottomPos.equalTo(@(self.view.height * 0.1));
    [rootLayout addSubview:button];

    UILabel *appSlogLabel2 = [[UILabel alloc]init];
    appSlogLabel2.text = [@"AppSlog" localString];
    appSlogLabel2.textColor = [UIColor whiteColor];
    appSlogLabel2.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    [appSlogLabel2 sizeToFit];
    appSlogLabel2.leftPos.equalTo(button.leftPos);
    appSlogLabel2.bottomPos.equalTo(button.topPos).offset(32);
    [rootLayout addSubview:appSlogLabel2];

    UILabel *appSlogLabel = [[UILabel alloc]init];
    appSlogLabel.text = [@"AppSlog2" localString];
    appSlogLabel.textColor = [UIColor whiteColor];
    appSlogLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [appSlogLabel sizeToFit];
    appSlogLabel.leftPos.equalTo(button.leftPos);
    appSlogLabel.bottomPos.equalTo(appSlogLabel2.topPos).offset(8);
    [rootLayout addSubview:appSlogLabel];

    UIImageView *appNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 56)];
    appNameView.image = [UIImage imageNamed:@"app_name"];
    appNameView.contentMode = UIViewContentModeScaleAspectFit;
    appNameView.leftPos.equalTo(button.leftPos);
    appNameView.bottomPos.equalTo(appSlogLabel.topPos).offset(12);
    [rootLayout addSubview:appNameView];

    RSMaskedLabel *aaa = [[RSMaskedLabel alloc] init];
    aaa.frame = CGRectMake(100, 200, 100, 200);
    [aaa setText:@"啊啊啊测试"];
    aaa.backgroundColor = [UIColor redColor];
    [self.view addSubview:aaa];
}

- (void)initPlayer {
    NSString *path = [[NSBundle bundleWithPath:[[[NSBundle resourceBundle] resourcePath] stringByAppendingPathComponent:@"Login"]] pathForAuxiliaryExecutable:@"login_video.mp4"];
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:path];

    // 2、创建AVPlayerItem
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:sourceMovieURL];
    // 3、根据AVPlayerItem创建媒体播放器
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    // 4、创建AVPlayerLayer，用于呈现视频
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    // 5、设置显示大小和位置
    playerLayer.frame = self.view.bounds;

    // 6、设置拉伸模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 7、获取播放持续时间
    [_player play];
    [self.view.layer addSublayer:playerLayer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vidoPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 视频循环播放

- (void)vidoPlayDidEnd:(NSNotification *)notification {
    AVPlayerItem *item = [notification object];

    [item seekToTime:CMTimeMake(0, 1) completionHandler:nil];

    [self.player play];
}

- (void)becomeActive {
    if (self.player.rate == 0) {
        [_player play];
    }
}

- (void)handleLoginButtonClicked:(MaskedLoginButton *)sender {
    [sender recoveryBackgourndColor];
}

- (void)initGesture {
    // 添加一个手势识别器来检测下滑动作
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        return;
    }

    CGPoint translation = [gestureRecognizer translationInView:self.view];
    // 判断滑动的距离是否足够大以触发返回操作
    if (translation.y > 50) {
        // 取消当前的presentedViewController
        [self dismissViewControllerAnimated:YES completion:nil];
        // 用户向上滑动，不做处理
    } else if (translation.y < 0) {
    }

    [gestureRecognizer setTranslation:CGPointZero inView:self.view];
}

@end
