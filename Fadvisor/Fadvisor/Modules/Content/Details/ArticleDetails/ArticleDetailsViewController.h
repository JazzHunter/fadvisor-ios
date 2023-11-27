//
//  ArticleDetailsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import "BaseTableViewController.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleDetailsViewController : BaseTableViewController<NavigationBarDataSource, NavigationBarDelegate>

@property (nonatomic, copy) NSString *articleId;

@property (nonatomic, strong) ItemModel *item;

@end

NS_ASSUME_NONNULL_END
