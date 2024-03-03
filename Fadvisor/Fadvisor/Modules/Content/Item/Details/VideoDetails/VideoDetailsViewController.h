//
//  VideoDetailsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/9.
//

#import "BaseViewController.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoDetailsViewController : BaseViewController<NavigationBarDataSource, NavigationBarDelegate>

- (instancetype)initWithItem:(ItemModel *)itemModel;

- (instancetype)initWithId:(NSString *)itemId;

@end

NS_ASSUME_NONNULL_END
