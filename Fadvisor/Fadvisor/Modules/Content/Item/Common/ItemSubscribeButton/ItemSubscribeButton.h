//
//  ItemSubscribeButton.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/9/28.
//

#import <UIKit/UIKit.h>

#define ItemSubscribeButtonWidth       96          // 默认宽度
#define ItemSubscribeButtonHeight       32          // 默认高度

NS_ASSUME_NONNULL_BEGIN

@interface ItemSubscribeButton : UIButton

@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, assign, getter = isSubscribed) BOOL subscribed;

@end

NS_ASSUME_NONNULL_END
