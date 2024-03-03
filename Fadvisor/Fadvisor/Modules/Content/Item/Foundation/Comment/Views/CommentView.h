//
//  CommentInfoView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import <MyLayout/MyLayout.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CommentViewDelegate <NSObject>

@optional

- (void)expendButtonTappted:(UIButton *)sender;

@end

@interface CommentView : MyRelativeLayout

@property (nonatomic, weak) id<CommentViewDelegate>delegate;

- (void)setModel:(CommentModel *)model;

@end

NS_ASSUME_NONNULL_END
