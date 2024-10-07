//
//  FavHButton.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/29.
//

#import <MyLayout/MyLayout.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavHButton : MyLinearLayout

- (void)setModel:(ItemModel *)model;

@property(atomic, assign) BOOL faved;

@end

NS_ASSUME_NONNULL_END
