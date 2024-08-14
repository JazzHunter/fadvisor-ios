//
//  ShareVButton.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/14.
//

#define IconWidth 16

#import <MyLayout/MyLayout.h>
#import "ItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareVButton : MyLinearLayout

- (void)setModel:(ItemModel *)model;

@end

NS_ASSUME_NONNULL_END
