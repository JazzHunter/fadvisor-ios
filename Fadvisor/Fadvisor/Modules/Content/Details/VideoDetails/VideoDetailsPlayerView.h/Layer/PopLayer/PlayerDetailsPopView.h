//
//  AliyunPVPopLayer.h
//

#import <UIKit/UIKit.h>
#import "PlayerDetailsErrorView.h"

typedef NS_ENUM(int, PlayerPopCode) {
    // 未知错误
    PlayerPopCodeUnknown              = 0,

    // 当用户播放完成后提示用户可以重新播放。    再次观看，请点击重新播放
    PlayerPopCodePlayFinish           = 1,

    // 用户主动取消播放
    PlayerPopCodeStop                 = 2,

    // 服务器返回错误情况
    PlayerPopCodeServerError          = 3,

    // 播放中的情况
    // 当网络超时进行提醒（文案统一可以定义），用户点击可以进行重播。      当前网络不佳，请稍后点击重新播放
    PlayerPopCodeNetworkTimeOutError  = 4,

    // 断网时进行断网提醒，点击可以重播（按记录已经请求成功的url进行请求播放） 无网络连接，检查网络后点击重新播放
    PlayerPopCodeUnreachableNetwork   = 5,

    // 当视频加载出错时进行提醒，点击可重新加载。   视频加载出错，请点击重新播放
    PlayerPopCodeLoadDataError        = 6,

    // 当用户使用移动网络播放时，首次不进行自动播放，给予提醒当前的网络状态，用户可手动使用移动网络进行播放。顶部提示条仅显示4秒自动消失。当用户从wifi切到移动网络时，暂定当前播放给予用户提示当前的网络，用户可以点击播放后继续当前播放。
    PlayerPopCodeUseMobileNetwork     = 7,

    // ststoken过期，需要重新请求
    PlayerPopCodeSecurityTokenExpired = 8,

    PlayerPopCodePreview              = 9,
};

@class PlayerDetailsPopView;
@protocol PlayerDetailsPopViewDelegate <NSObject>

/*
 * 功能：点击返回时操作
 * 参数：popLayer 对象本身
 */
- (void)onBackClickedWithPopView:(PlayerDetailsPopView *)popView;

/*
 * 功能：提示错误信息时，当前按钮状态
 * 参数：type 错误类型
 */
- (void)showPopViewWithType:(PlayerErrorType)type;

@end

@interface PlayerDetailsPopView : UIView

@property (nonatomic, weak) id<PlayerDetailsPopViewDelegate>delegate;

/*
 * 功能：根据不同code，展示弹起的消息界面
 * 参数： code ： 事件
         popMsg ：自定义消息
 */
- (void)showPopViewWithCode:(PlayerPopCode)code popMsg:(NSString *)popMsg;

@end
