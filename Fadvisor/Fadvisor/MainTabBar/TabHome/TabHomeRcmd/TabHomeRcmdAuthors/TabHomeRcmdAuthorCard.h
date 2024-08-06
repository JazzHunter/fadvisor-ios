//
//  TabHomeRcmdAuthorCard.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/6.
//

#define AuthorCardViewHeight 220
#define AuthorCardViewWidth  140

#import <MyLayout/MyLayout.h>
#import "AuthorModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TabHomeRcmdAuthorCardDelegate <NSObject>

/*
 * 功能 ： 点击返回按钮
 * 参数 ： topView 对象本身
 */
- (void)onTabHomeRcmdAuthorCardTapped:(MyBaseLayout *)sender withModel:(AuthorModel *)model;

@end

@interface TabHomeRcmdAuthorCard : MyRelativeLayout

@property (nonatomic, weak) id<TabHomeRcmdAuthorCardDelegate>delegate;

- (void)setModel:(AuthorModel *)model;
- (instancetype)initWithModel:(AuthorModel *)model;

@end

NS_ASSUME_NONNULL_END
