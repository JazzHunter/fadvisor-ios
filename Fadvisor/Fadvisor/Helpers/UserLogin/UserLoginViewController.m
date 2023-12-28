//
//  UserLoginViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/19.
//

#import "UserLoginViewController.h"
#import <AVFoundation/AVFoundation.h>

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self initPlayer];
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
    playerLayer.frame =self.view.bounds;

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

@end
