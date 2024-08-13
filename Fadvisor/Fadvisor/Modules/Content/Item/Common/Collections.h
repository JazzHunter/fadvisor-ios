//
//  Collections.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/11.
//

#import <MyLayout/MyLayout.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Collections : MyLinearLayout

- (void)setModels:(NSArray<ItemModel *> *)models;

@end

NS_ASSUME_NONNULL_END
