//
//  VideoDetailsContentViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/22.
//

#import "BaseScrollViewController.h"
#import "JXPagerView.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoDetailsContentViewController : BaseScrollViewController<JXPagerViewListViewDelegate>

@property (nonatomic, strong) ItemModel *itemModel;

@end

NS_ASSUME_NONNULL_END
