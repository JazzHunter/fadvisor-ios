//
//  UIView+Additions.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/17.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Additions)

/**
 生成渐变背景色

 @param colors 渐变的颜色
 @param locations 渐变颜色的分割点
 @param startPoint 渐变颜色的方向起点，范围在（0，0）与（1.0，1.0）之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
 @param endPoint  渐变颜色的方向终点
 */
- (void)setGradientBgColorWithColors:(NSArray *)colors locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)setCornerRadius:(CGFloat)cornerRadii;

- (void)setTopLeftRightCornerRadius:(CGFloat)cornerRadii;

- (void)loadShakeAnimation;

- (void)showTips:(NSString *)tips;

+ (CAGradientLayer *)bgGradientLayer;


@end

NS_ASSUME_NONNULL_END
