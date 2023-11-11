//
//  UIButton+Additions.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/23.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "UIButton+Additions.h"
#import "UIView+GestureCallback.h"
#import <objc/runtime.h>

static const void *UIButtonBlockKey = &UIButtonBlockKey;

@implementation UIButton (Additions)

- (void)addActionHandler:(TouchedBlock)touchHandler {
    objc_setAssociatedObject(self, UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionTouched:(UIButton *)btn {
    TouchedBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        block(btn.tag);
    }
}

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
static NSString * key_ActionBlock = @"key_ActionBlock";
- (void)setHandleButtonActionBlock:(void (^)(UIButton * _Nullable))handleButtonActionBlock{
    objc_setAssociatedObject(self, (__bridge const void *)key_ActionBlock, handleButtonActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (handleButtonActionBlock) {
        [self addTarget:self action:@selector(actionHandler) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)actionHandler{
    if (self.handleButtonActionBlock) {
        self.handleButtonActionBlock(self);
    }
}

-  (void (^)(UIButton * _Nullable))handleButtonActionBlock{
    return objc_getAssociatedObject(self, (__bridge const void *)key_ActionBlock);
}


- (instancetype)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle normalBGColor:(UIColor *)normalBGColor selectBGColor:(UIColor *)selectBGColor
                  normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor buttonFont:(UIFont *)buttonFont cornerRadius:(CGFloat)cornerRadius
                    doneBlock:(void (^)(UIButton *))doneBlock
{
    self = [self initWithFrame:frame];

    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;

    self.titleLabel.font = buttonFont;
    [self setTitle:buttonTitle forState:UIControlStateNormal];
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:selectColor forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:normalBGColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:selectBGColor] forState:UIControlStateHighlighted];

    Weak(self);
    [self addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
        !doneBlock ? : doneBlock(weakself);
    }];

    return self;
}

+ (UIButton *)initWithFrame:(CGRect)frame buttonTitle:(NSString *)buttonTitle normalBGColor:(UIColor *)normalBGColor selectBGColor:(UIColor *)selectBGColor
                normalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor buttonFont:(UIFont *)buttonFont cornerRadius:(CGFloat)cornerRadius
                  doneBlock:(void (^)(UIButton *))doneBlock
{
    UIButton *solidColorButton = [[UIButton alloc]initWithFrame:frame buttonTitle:buttonTitle normalBGColor:normalBGColor selectBGColor:selectBGColor normalColor:normalColor selectColor:selectColor buttonFont:buttonFont cornerRadius:cornerRadius doneBlock:doneBlock];

    return solidColorButton;
}

@end

@implementation APRoundedButton

- (void)makeCorner {
    UIRectCorner corners;

    switch (self.style) {
        case 0:
            corners = UIRectCornerBottomLeft;
            break;
        case 1:
            corners = UIRectCornerBottomRight;
            break;
        case 2:
            corners = UIRectCornerTopLeft;
            break;
        case 3:
            corners = UIRectCornerTopRight;
            break;
        case 4:
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case 5:
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case 6:
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
            break;
        case 7:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
            break;
        case 8:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
            break;
        case 9:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
            break;
        default:
            corners = UIRectCornerAllCorners;
            break;
    }

    _nj_cornerRaduous = _nj_cornerRaduous ? : 10.0;

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(_nj_cornerRaduous, _nj_cornerRaduous)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUIOnce];
    }
    return self;
}

- (void)setupUIOnce {
    [self makeCorner];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeCorner];
}

@end
