//
//  UIView+Additions.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/17.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "UIView+Additions.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIView (Additions)

-(void)setGradientBgColorWithColors:(NSArray *)colors locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    if (colors == nil || [colors isKindOfClass:[NSNull class]] || colors.count == 0){
        return;
    }
    if (locations == nil || [locations isKindOfClass:[NSNull class]] || locations.count == 0){
        return;
    }
    NSMutableArray *colorsTemp = [NSMutableArray new];
    for (UIColor *color in colors) {
        if ([color isKindOfClass:[UIColor class]]) {
            [colorsTemp addObject:(__bridge id)color.CGColor];
        }
    }
    gradientLayer.colors = colorsTemp;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame =  self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}
-(void)setCornerRadius:(CGFloat)cornerRadii {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadii, cornerRadii)];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    //设置大小
    layer.frame = self.bounds;
    //设置图形样子
    layer.path = path.CGPath;
    self.layer.mask = layer;
}

-(void)setCornerRadius:(CGFloat)cornerRadii borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadii, cornerRadii)];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    //设置大小
    layer.frame = self.bounds;
    //设置图形样子
    layer.path = path.CGPath;
    self.layer.mask = layer;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    borderLayer.path = path.CGPath;
    borderLayer.lineWidth = borderWidth;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    [self.layer addSublayer:borderLayer];
}

-(void)setTopLeftRightCornerRadius:(CGFloat)cornerRadii {
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(cornerRadii, cornerRadii)];
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
    cornerRadiusLayer.frame = self.bounds;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    self.layer.mask = cornerRadiusLayer;
}

- (void)loadShakeAnimation {
    CALayer *lbl = [self layer];
    CGPoint posLbl = [lbl position];
    CGPoint y = CGPointMake(posLbl.x-2, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+2, posLbl.y);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.1];
    [animation setRepeatCount:1];
    [lbl addAnimation:animation forKey:nil];
}

- (void)showTips:(NSString *)tips {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.blurEffectStyle = UIBlurEffectStyleDark;
    hud.contentColor = [UIColor whiteColor];
    hud.userInteractionEnabled = NO;
    hud.label.text = tips;
    [hud hideAnimated:YES afterDelay:3.0f];
}

+ (CAGradientLayer *)bgGradientLayer
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    UIColor *color1 = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    UIColor *color2 = [[UIColor blackColor] colorWithAlphaComponent:0.53];
    UIColor *color3 = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    UIColor *color4 = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    UIColor *color5 = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    
    
    gradientLayer.colors = @[ (__bridge id) color5.CGColor, (__bridge id) color4.CGColor, (__bridge id) color3.CGColor, (__bridge id) color2.CGColor, (__bridge id) color1.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@0,@(2.0/12.0),@(4.0/12.0),@(6.0/12.0),@(12.0/12.0)];
    
    return gradientLayer;
 
}

@end
