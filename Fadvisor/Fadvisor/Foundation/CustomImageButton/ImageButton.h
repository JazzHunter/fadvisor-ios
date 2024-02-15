//
//  ImageButton.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName;

@property (nonatomic) CGSize imageSize;

- (void)enableTouchDownAnimation;

@end

NS_ASSUME_NONNULL_END
