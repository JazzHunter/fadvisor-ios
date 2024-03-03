//
//  AuthorAvatarWithWrapper.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import <MyLayout/MyLayout.h>

#define AuthorAvatarWithWrapperWidth       46          // cell 上下留白

NS_ASSUME_NONNULL_BEGIN

@interface AuthorAvatarWithWrapper : UIView;

- (void)setAvatarUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
