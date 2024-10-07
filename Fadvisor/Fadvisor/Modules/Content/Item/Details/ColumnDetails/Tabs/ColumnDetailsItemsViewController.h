//
//  ColumnDetailsItemsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/29.
//

#import "JXPagerView.h"
#import "BaseTableViewController.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColumnDetailsItemsViewController : BaseTableViewController<JXPagerViewListViewDelegate>

- (instancetype)initWithCollection:(ItemModel *)collectionModel;

@property (atomic, assign) BOOL inited;

@end

NS_ASSUME_NONNULL_END
