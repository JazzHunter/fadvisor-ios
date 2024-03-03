//
//  CommentSet.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import "BaseCommentModel.h"
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentSetModel : BaseCommentModel

/** 回复列表 */
@property (nonatomic, strong) NSMutableArray<CommentModel *> *replies;

@end

NS_ASSUME_NONNULL_END
