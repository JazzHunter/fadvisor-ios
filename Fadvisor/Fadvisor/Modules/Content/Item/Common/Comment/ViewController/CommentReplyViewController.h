//
//  CommentReplyViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/4.
//

#import "BaseTableViewController.h"
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentReplyViewController : BaseTableViewController

- (instancetype)initWithMasterComment:(CommentModel *)model;

@end

NS_ASSUME_NONNULL_END
