//
//  ArticleDetailsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import "BaseScrollViewController.h"
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleDetailsViewController : BaseScrollViewController

- (instancetype)initWithItem:(ItemModel *)itemModel;

- (instancetype)initWithId:(NSString *)itemId;

@property (nonatomic, strong) ItemModel *fromCollection;

@end

NS_ASSUME_NONNULL_END
