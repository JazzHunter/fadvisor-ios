//
//  PlayerDetailsPopErrorView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/22.
//

#import <MyLayout/MyLayout.h>

@class PlayerDetailsPopErrorView;

@protocol PlayerDetailsPopErrorViewDelegate <NSObject>

/*
 * 功能 ：点击按钮时操作
 * 参数 ：errorView 对象本身
 */
- (void)onButtonClickedWithPopErrorView:(UIButton *)sender errorView:(PlayerDetailsPopErrorView *)errorView;

@end

@interface PlayerDetailsPopErrorView : MyRelativeLayout

@property (nonatomic, weak) id<PlayerDetailsPopErrorViewDelegate>delegate;

/*
 * 功能 ：提示错误信息时，当前按钮状态
 * 参数 ：type 错误类型
 */
- (void)showWithMessage:(NSString *)errorMessage;

/*
 * 功能 ：隐藏
 */
- (void)hide;
/*
 * 功能 ：移除loading界面
 */
@property (nonatomic, assign) BOOL isShow;

- (void)resetLayout:(BOOL)isPortrait;

@end
