//
//  TabHomeRcmdAuthorsScrollView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/13.
//

#import <MyLayout/MyLayout.h>
#import "AuthorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabHomeRcmdAuthorsTableViewCell : UITableViewCell

//对于需要动态评估高度的UITableViewCell来说可以把布局视图暴露出来。用于高度评估和边界线处理。以及事件处理的设置。
@property (nonatomic, strong, readonly) MyBaseLayout *rootLayout;

- (void)setAuthorModels:(NSArray<AuthorModel *> *)authorModels;
- (void)showLoading;
- (void)hideLoading;

@end

NS_ASSUME_NONNULL_END
