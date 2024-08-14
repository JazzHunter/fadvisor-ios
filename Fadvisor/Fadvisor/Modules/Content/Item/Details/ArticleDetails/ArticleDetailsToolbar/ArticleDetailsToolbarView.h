//
//  ArticleDetailsToolbarView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/14.
//

#import <MyLayout/MyLayout.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleDetailsToolbarView : MyRelativeLayout

- (void)setModel:(ItemModel *)model;

@end

NS_ASSUME_NONNULL_END
