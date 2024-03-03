//
//  PlayerDetailsSpeedTips.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/21.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerDetailsSpeedTips : MyLinearLayout

- (void)showDirection:(BOOL)right speedTips:(NSString *)speedTips;

@end

NS_ASSUME_NONNULL_END
