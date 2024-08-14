//
//  VoteButton.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/13.
//
#define IconWidth 16

#import <MyLayout/MyLayout.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavVButton : MyLinearLayout

- (void)setModel:(ItemModel *)model;

@property(atomic, assign) BOOL faved;

@end

NS_ASSUME_NONNULL_END
