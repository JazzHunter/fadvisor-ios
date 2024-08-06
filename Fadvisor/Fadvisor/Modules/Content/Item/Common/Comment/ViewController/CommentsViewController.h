//
//  CommentsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/2.
//
#import "BaseTableViewController.h"
#import "ItemModel.h"
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentsViewController : BaseTableViewController

- (instancetype)initWithItem:(ItemModel *)itemModel;

@end

NS_ASSUME_NONNULL_END
