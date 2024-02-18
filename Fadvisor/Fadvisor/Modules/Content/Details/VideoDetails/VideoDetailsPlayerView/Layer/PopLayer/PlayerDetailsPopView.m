//
//  AliyunPVPopLayer.m
//

#import "PlayerDetailsPopView.h"
#import "Utils.h"

static const CGFloat PopBackButtonWidth = 24;   //返回按钮宽度
//static const CGFloat PopBackButtonHeight = 96;  //返回按钮高度

@interface PlayerDetailsPopView () <PlayerDetailsErrorViewDelegate>

@property (nonatomic, strong) UIButton *backBtn;            //返回按钮
@property (nonatomic, strong) PlayerDetailsErrorView *errorView; //错误view

@end
@implementation PlayerDetailsPopView

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"player_back"];
        [_backBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_backBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    return _backBtn;
}

- (PlayerDetailsErrorView *)errorView {
    if (!_errorView) {
        _errorView = [[PlayerDetailsErrorView alloc] init];
    }
    return _errorView;
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.backBtn];
        self.errorView.delegate = self;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backBtn.frame = CGRectMake(8, (44 - PopBackButtonWidth) / 2.0, PopBackButtonWidth, PopBackButtonWidth);
    self.errorView.center = CGPointMake(self.width / 2, self.height / 2);
}

#pragma makr - 重写setter方法

#pragma mark - onClick
- (void)onClick:(UIButton *)btn {
    if (![Utils isInterfaceOrientationPortrait]) {
        [Utils setFullOrHalfScreen];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onBackClickedWithPopView:)]) {
            [self.delegate onBackClickedWithPopView:self];
        }
    }
}

#pragma mark - public method
/*
 #define ALIYUNVODVIEW_UNKNOWN              @"未知错误"
 #define ALIYUNVODVIEW_PLAYFINISH           @"再次观看，请点击重新播放"
 #define ALIYUNVODVIEW_NETWORKTIMEOUT       @"当前网络不佳，请稍后点击重新播放"
 #define ALIYUNVODVIEW_NETWORKUNREACHABLE   @"无网络连接，检查网络后点击重新播放"
 #define ALIYUNVODVIEW_LOADINGDATAERROR     @"视频加载出错，请点击重新播放"
 #define ALIYUNVODVIEW_USEMOBILENETWORK     @"当前为移动网络，请点击播放"
 */
- (void)showPopViewWithCode:(PlayerPopCode)code popMsg:(NSString *)popMsg {
    if ([_errorView isShowing]) {
        [_errorView dismiss];
    }
    NSString *tempString = @"unknown";
    PlayerErrorType errorType = PlayerErrorTypeRetry;
    switch (code) {
        case PlayerPopCodePlayFinish:
            tempString = [@"Watch again, please click replay" localString];
            errorType = PlayerErrorTypeReplay;
            break;
        case PlayerPopCodeNetworkTimeOutError:
            tempString = [@"The current network is not good. Please click replay later" localString];
            errorType = PlayerErrorTypeReplay;
            break;
        case PlayerPopCodeUnreachableNetwork:
            tempString = [@"No network connection, check the network, click replay" localString];
            errorType = PlayerErrorTypeReplay;
            break;
        case PlayerPopCodeLoadDataError:
            tempString = [@"Video loading error, please click replay" localString];
            errorType = PlayerErrorTypeRetry;
            break;
        case PlayerPopCodeServerError:
            tempString = popMsg;
            errorType = PlayerErrorTypeRetry;
            break;
        case PlayerPopCodeUseMobileNetwork:
            tempString = [@"For mobile networks, click play" localString];
            errorType = PlayerErrorTypePause;
            break;
        case PlayerPopCodeSecurityTokenExpired:
            tempString = popMsg;
            errorType = PlayerErrorTypeStsExpired;
            break;
        default:
            break;
    }
    if (popMsg) {
        tempString = popMsg;
    }
    self.errorView.message = tempString;
    self.errorView.errorType = errorType;
    [_errorView showWithParentView:self];
}

#pragma mark - PlayerDetailsErrorViewDelegate
- (void)onErrorViewClickedWithType:(PlayerErrorType)errorType {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPopViewWithType:)]) {
        [self.delegate showPopViewWithType:errorType];
    }
}

@end
