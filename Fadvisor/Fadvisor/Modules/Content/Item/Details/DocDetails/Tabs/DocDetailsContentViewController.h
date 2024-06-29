//
//  DcoDetailsContentViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/29.
//

#import "BaseScrollViewController.h"
#import "JXPagerView.h"
#import "ItemModel.h"
#import "DocDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DocDetailsContentViewController : BaseScrollViewController<JXPagerViewListViewDelegate>

- (void)setModel:(ItemModel *)itemModel details:(DocDetailsModel *)detailsModel;

@end

NS_ASSUME_NONNULL_END
