//
//  PlayerDetailsLoadingView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/22.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerDetailsLoadingView : MyLinearLayout

/*
 * 功能 ：展示loading
 */
- (void)showLoading;

/*
 * 功能 ：设置下载速率
 */
- (void)setDownloadSpeed:(int64_t)speed;

/*
 * 功能 ：移除loading界面
 */
- (void)stopLoading;

@property (nonatomic, assign) BOOL isLoadingShow;


@end

NS_ASSUME_NONNULL_END
