//
//  OtherLoginPanel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/13.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtherLoginPanel : MyRelativeLayout

/** 显示 */
- (void)showPanel;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
