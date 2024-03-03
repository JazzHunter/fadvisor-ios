//
//  CommentsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/2.
//
#import "JXPagerView.h"
#import "BaseTableViewController.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentsViewController : BaseTableViewController<JXPagerViewListViewDelegate>

- (instancetype)initWithModel:(ItemModel *)model;

@end

NS_ASSUME_NONNULL_END
