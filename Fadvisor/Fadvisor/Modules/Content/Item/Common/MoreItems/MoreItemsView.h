//
//  MoreItems.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/14.
//

#import <MyLayout/MyLayout.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoreItemsView : MyLinearLayout

@property (atomic, assign) BOOL inited;
@property (atomic, assign) BOOL loading;

- (void)loadMoreItemsWithModel:(ItemModel *)model;
- (void)reset;

@end

NS_ASSUME_NONNULL_END
