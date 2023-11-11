//
//  UIColor+Additions.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2019/11/29.
//  Copyright © 2019 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Additions)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIColor *)getColorWithLightColor:(UIColor *)lightColor
                          darkColor:(UIColor *_Nullable)darkColor;

+ (UIColor *)mainColor;

+ (UIColor *)lightMainColor;

+ (UIColor *)backgroundMainColor;

+ (UIColor *)backgroundColor;

+ (UIColor *)backgroundColorGray;

+ (UIColor *)RandomColor;

+ (UIColor *)titleTextColor;

+ (UIColor *)descriptionTextColor;

+ (UIColor *)metaTextColor;

+ (UIColor *)contentTextColor;

+ (UIColor *)borderColor;

+ (UIColor *)lightBorderColor;

+ (UIColor *)lightBackgroundColor;

+ (UIColor *)pwcRedColor;

+ (UIColor *)pwcOrangeColor;

+ (UIColor *)pwcPinkColor;

//根据图片获取主色值
+ (UIColor*)mostColor:(UIImage*)image;
@end

NS_ASSUME_NONNULL_END
