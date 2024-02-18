//
//  AlyunVodTopView.h
//

#import <UIKit/UIKit.h>
#import "AlivcPlayerDefine.h"
#import <MyLayout/MyLayout.h>

@class PlayerDetailsControlTopView;

@protocol PlayerDetailsControlTopViewDelegate <NSObject>

/*
 * 功能 ： 点击返回按钮
 * 参数 ： topView 对象本身
 */
- (void)onTopViewBackButtonClicked:(UIButton *)sender topView:(PlayerDetailsControlTopView *)topView;

/*
 * 功能 ： 点击右上角的More按钮
 * 参数 ： topView 对象本身
 */

- (void)onTopViewMoreButtonClicked:(UIButton *)sender topView:(PlayerDetailsControlTopView *)topView;

@end

@interface PlayerDetailsControlTopView : MyRelativeLayout

@property (nonatomic, weak) id<PlayerDetailsControlTopViewDelegate>delegate;

- (void)setTitle:(NSString *)titleText;

- (void)resetLayout:(BOOL)isPortrait;

@end
