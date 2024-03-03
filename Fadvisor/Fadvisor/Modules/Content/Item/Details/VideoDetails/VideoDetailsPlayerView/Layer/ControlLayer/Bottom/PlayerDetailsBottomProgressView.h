//
//  PlayerDetailsBottomProgressView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerDetailsBottomProgressView : UIProgressView

/*
 * 设置垂直 / 水平布局
 */

- (void)resetLayout:(BOOL)isPortrait;

/*
    自定义高度
 */
//- (void)setCustomHeight:(CGFloat)customHeight;

@end

NS_ASSUME_NONNULL_END
