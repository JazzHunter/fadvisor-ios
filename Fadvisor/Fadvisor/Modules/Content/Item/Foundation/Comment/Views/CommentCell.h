//
//  CommentCell.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import <UIKit/UIKit.h>
#import <MyLayout/MyLayout.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell

//对于需要动态评估高度的UITableViewCell来说可以把布局视图暴露出来。用于高度评估和边界线处理。以及事件处理的设置。
@property (nonatomic, strong, readonly) MyRelativeLayout *rootLayout;

- (void)setModel:(CommentModel *)model;

@end

NS_ASSUME_NONNULL_END
