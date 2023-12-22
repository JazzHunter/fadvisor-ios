//
//  SharePanel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/8.
//

#import "ItemModel.h"
#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharePanel : MyLinearLayout

/** 显示Item */
- (void)showPanelWithItem:(ItemModel *)model;

+ (instancetype)manager;

@end

NS_ASSUME_NONNULL_END
