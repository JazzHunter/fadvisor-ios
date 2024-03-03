//
//  CommentModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import <Foundation/Foundation.h>
#import "BaseCommentModel.h"
#import "ItemModel.h"

@interface CommentModel : BaseCommentModel

/** 被评论人*/
@property (nonatomic, strong) UserModel *userTo;

/** 被回复的Comment */
@property (nonatomic, strong) CommentModel *repliedComment;

/** 被回复的Comment */
@property (nonatomic, strong) ItemModel *item;

@end
