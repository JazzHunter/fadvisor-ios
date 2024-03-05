//
//  CommentInfoView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import <MyLayout/MyLayout.h>
#import "CommentModel.h"
#import "UserAvatarWithWrapper.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    CommentViewSizeNormal,
    CommentViewSizeSmall
} CommentViewSize;

@interface CommentView : MyRelativeLayout

- (instancetype)initWithSize:(CommentViewSize)size;

- (void)setModel:(CommentModel *)model;

@end

NS_ASSUME_NONNULL_END
