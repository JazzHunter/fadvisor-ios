//
//  VoteButton.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/13.
//

#import <MyLayout/MyLayout.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoteHButton : MyLinearLayout

- (void)setModel:(ItemModel *)model;

@property(atomic, assign) BOOL voted;

@end

NS_ASSUME_NONNULL_END
