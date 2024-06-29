//
//  DocDetailsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/23.
//

#import "BaseViewController.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DocDetailsViewController : BaseViewController<NavigationBarDataSource, NavigationBarDelegate>

- (instancetype)initWithItem:(ItemModel *)itemModel;

- (instancetype)initWithId:(NSString *)itemId;

@end

NS_ASSUME_NONNULL_END
