//
//  UserAvatarWithWrapper.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import <UIKit/UIKit.h>

#define UserAvatarWithWrapperWidth       36          // cell 上下留白

NS_ASSUME_NONNULL_BEGIN

@interface UserAvatarWithWrapper : UIView

- (void)setAvatarUrlWithInternal:(NSURL *)url internal:(BOOL)isInternal;

@end

NS_ASSUME_NONNULL_END
