//
//  ColmunDetailsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/27.
//

#import "BaseViewController.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColumnDetailsViewController : BaseViewController<NavigationBarDataSource, NavigationBarDelegate>

- (instancetype)initWithItem:(ItemModel *)itemModel;

- (instancetype)initWithId:(NSString *)itemId;

@property (nonatomic, strong) ItemModel *fromCollection;

@end

NS_ASSUME_NONNULL_END
