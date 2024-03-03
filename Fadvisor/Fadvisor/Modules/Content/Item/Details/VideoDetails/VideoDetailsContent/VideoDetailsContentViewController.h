//
//  VideoDetailsContentViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/22.
//

#import "BaseScrollViewController.h"
#import "JXPagerView.h"
#import "ItemModel.h"
#import "VideoDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoDetailsContentViewController : BaseScrollViewController<JXPagerViewListViewDelegate>

- (void)setModel:(ItemModel *)itemModel details:(VideoDetailsModel *)detailsModel;


@end

NS_ASSUME_NONNULL_END
