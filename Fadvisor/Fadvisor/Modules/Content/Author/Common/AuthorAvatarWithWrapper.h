//
//  AuthorAvatarWithWrapper.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import <MyLayout/MyLayout.h>

#define AuthorAvatarWithWrapperWidth       46          // 默认的带边框头像的宽度

NS_ASSUME_NONNULL_BEGIN

@interface AuthorAvatarWithWrapper : UIView;

- (void)setAvatarUrl:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
