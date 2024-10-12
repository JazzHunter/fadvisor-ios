//
//  UIButton+Additions.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/23.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TouchedBlock)(NSInteger tag);

@interface UIButton (Additions)
/**
 添加 addtarget
 */
- (void)addActionHandler:(TouchedBlock _Nonnull)touchHandler;

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)setBackgroundColor:(UIColor *_Nonnull)backgroundColor forState:(UIControlState)state;

/*
 *  @brief
 *
 *  @param frame         frame
 *  @param buttonTitle   标题
 *  @param normalBGColor 未选中的背景色
 *  @param selectBGColor 选中的背景色
 *  @param normalColor   未选中的文字色
 *  @param selectColor   选中的文字色
 *  @param buttonFont    文字字体
 *  @param cornerRadius  圆角值 没有则为0
 *  @param doneBlock     点击事件
 *
 *  @return
 */
- (instancetype _Nonnull)initWithFrame:(CGRect)frame buttonTitle:(NSString *_Nonnull)buttonTitle normalBGColor:(UIColor *_Nonnull)normalBGColor selectBGColor:(UIColor *_Nonnull)selectBGColor
                           normalColor:(UIColor *_Nonnull)normalColor selectColor:(UIColor *_Nonnull)selectColor buttonFont:(UIFont *_Nonnull)buttonFont cornerRadius:(CGFloat)cornerRadius
                             doneBlock:(void (^_Nonnull)(UIButton *_Nonnull))doneBlock;

+ (UIButton *_Nonnull)initWithFrame:(CGRect)frame buttonTitle:(NSString *_Nonnull)buttonTitle normalBGColor:(UIColor *_Nonnull)normalBGColor selectBGColor:(UIColor *_Nonnull)selectBGColor
                        normalColor:(UIColor *_Nonnull)normalColor selectColor:(UIColor *_Nonnull)selectColor buttonFont:(UIFont *_Nonnull)buttonFont cornerRadius:(CGFloat)cornerRadius
                          doneBlock:(void (^_Nonnull)(UIButton *_Nonnull))doneBlock;

@property (copy, nonatomic) void (^ _Nullable handleButtonActionBlock)(UIButton *_Nullable sender);

@end

//
//  Created by Alberto Pasca on 27/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface APRoundedButton : UIButton

@property (nonatomic, assign) IBInspectable NSUInteger style;
@property (nonatomic, assign) IBInspectable CGFloat nj_cornerRaduous;

@end
