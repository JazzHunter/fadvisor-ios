//
//  ArticleDetailsCollItemsSection.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/12.
//

#import <MyLayout/MyLayout.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleDetailsCollItemsSectionView : MyRelativeLayout

- (void)setModel:(ItemModel *)model withCollection:(ItemModel *)collection;

@end

NS_ASSUME_NONNULL_END
