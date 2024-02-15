//
//  AUIPlayerSpeedSwipeView.h
//  AUIVideoFlow
//
//  Created by ISS013602000846 on 2022/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerSpeedSwipeView : UIView

- (void)updateDirection:(BOOL)right speed:(NSString *)speed;

@end

NS_ASSUME_NONNULL_END
