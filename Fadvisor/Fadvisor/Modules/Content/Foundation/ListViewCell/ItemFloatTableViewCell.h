//
//  ItemFloatTableViewCell.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/21.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"
#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface ItemFloatTableViewCell : UITableViewCell

//对于需要动态评估高度的UITableViewCell来说可以把布局视图暴露出来。用于高度评估和边界线处理。以及事件处理的设置。
@property(nonatomic, strong, readonly) MyBaseLayout *rootLayout;

- (void)setModel:(ItemModel *)model;

@end

NS_ASSUME_NONNULL_END
