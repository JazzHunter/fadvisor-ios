//
//  PopReplies.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/5.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopRepliesNavViewController : UINavigationController

- (instancetype)initWithMasterComment:(CommentModel *)model;

@end

NS_ASSUME_NONNULL_END
