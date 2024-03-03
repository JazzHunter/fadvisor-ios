//
//  AuthorFollowButton.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/24.
//

#import <UIKit/UIKit.h>

#define AuthorFollowButtonWidth       96          // 默认宽度
#define AuthorFollowButtonHeight       32          // 默认高度

@interface AuthorFollowButton : UIButton

@property (nonatomic, strong) NSString *authorId;

@property (nonatomic, assign, getter = isSubscribed) BOOL subscribed;

@end
