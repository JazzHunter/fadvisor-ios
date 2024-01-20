//
//  AlyunVodTopView.h
//

#import <UIKit/UIKit.h>
#import "AlivcPlayerDefine.h"

@class PlayerDetailsControlTopView;

@protocol PlayerDetailsControlTopViewDelegate <NSObject>

/*
 * 功能 ： 点击返回按钮
 * 参数 ： topView 对象本身
 */
- (void)onBackViewClickWithTopView:(PlayerDetailsControlTopView*)topView;

/*
 * 功能 ： 点击下载按钮
 * 参数 ： topView 对象本身
 */
- (void)onDownloadButtonClickWithTopView:(PlayerDetailsControlTopView*)topView;

/*
 * 功能 ： 点击展示倍速播放界面按钮
 * 参数 ： 对象本身
 */
- (void)onSpeedViewClickedWithTopView:(PlayerDetailsControlTopView*)topView;

/*
 * 功能 ： 跑马灯按钮
 * 参数 ： 对象本身
 */
- (void)loopViewClickedWithTopView:(PlayerDetailsControlTopView*)topView;

@end

@interface PlayerDetailsControlTopView : UIView

@property (nonatomic, weak  ) id<PlayerDetailsControlTopViewDelegate>delegate;
@property (nonatomic, copy  ) NSString *topTitle;                   //标题
@property (nonatomic, strong) UIButton *speedButton;        //倍速播放界面展示按钮，更多按钮
@property (nonatomic ,assign) AlvcPlayMethod playMethod; //播放方式

@end
