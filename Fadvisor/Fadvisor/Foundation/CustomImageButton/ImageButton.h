//
//  ImageButton.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/21.
//

#import <UIKit/UIKit.h>

@interface ImageButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color;

@property (nonatomic) CGSize imageSize;

- (void)enableTouchDownAnimation;

@end
