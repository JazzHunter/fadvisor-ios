//
//  ALPVErrorMessageView.h
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (int, PlayerErrorType) {
    PlayerErrorTypeUnknown = 0,
    PlayerErrorTypeRetry,
    PlayerErrorTypeReplay,
    PlayerErrorTypePause,
    PlayerErrorTypeStsExpired
};

@protocol PlayerDetailsErrorViewDelegate <NSObject>

/*
 * 功能 ：错误状态提示
 * 参数 ： type 错误类型
 */
- (void)onErrorViewClickedWithType:(PlayerErrorType)errorType;

@end

@interface PlayerDetailsErrorView : UIView

@property (nonatomic, weak) id<PlayerDetailsErrorViewDelegate> delegate;
@property (nonatomic, copy) NSString *message;             //错误信息内容
@property (nonatomic, assign) PlayerErrorType errorType;   //错误类型

/*
 * 功能 ：展示错误页面偏移量
 * 参数 ：parent 插入的界面
 */
- (void)showWithParentView:(UIView *)parent;

/*
 * 功能 ：是否展示界面
 */
- (BOOL)isShowing;

/*
 * 功能 ：是否删除界面
 */
- (void)dismiss;

@end
