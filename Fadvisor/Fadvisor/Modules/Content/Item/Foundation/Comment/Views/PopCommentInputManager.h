//
//  PopCommentInputFullScreen.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/10.
//

#import <MyLayout/MyLayout.h>
#

NS_ASSUME_NONNULL_BEGIN

@interface PopCommentInputManager : MyRelativeLayout

+ (instancetype)manager;

- (void)pop;

@property (nonatomic, copy) NSString *placeholder; /**< 占位文字 */
@property (nonatomic, strong) UIColor *placeholderColor; /**< 占位文字颜色 */
@property (nonatomic, strong) UIFont *placeholderFont; /**< 占位文字字体大小 */
@property (nonatomic, assign) NSInteger numberOfLines; /**< 行数 0-无限行 */

@end

NS_ASSUME_NONNULL_END
