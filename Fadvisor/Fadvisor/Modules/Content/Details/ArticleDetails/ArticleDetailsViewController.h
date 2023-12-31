//
//  ArticleDetailsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import "BaseScrollViewController.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleDetailsViewController : BaseScrollViewController<NavigationBarDataSource, NavigationBarDelegate>

- (instancetype)initWithItem:(ItemModel *)model;

- (instancetype)initWithId:(NSString *)articleId;

@end

NS_ASSUME_NONNULL_END
