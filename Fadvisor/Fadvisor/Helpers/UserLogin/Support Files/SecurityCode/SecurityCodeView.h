//
//  SecurityCodeView.h
//  SecurityCode
//
//  Created by 杨广军 on 2018/10/22.
//  Copyright © 2018年 杨广军. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, securityCodeType){
    securityCodeTypeUnderline = 0,  //下划线
    securityCodeTypeBox,   //方框
};

@interface SecurityCodeView : UIView

//下划线未填写颜色
@property (nonatomic, strong) UIColor *underlineColor;
//已写过验证码下划线颜色
@property (nonatomic, strong) UIColor *confirmedColor;
//光标颜色
@property (nonatomic, strong) UIColor *cursorColor;

- (instancetype)initWithFrame:(CGRect)frame count:(NSUInteger)count space:(NSUInteger)space underlineColor:(UIColor *)underlineColor type:(securityCodeType)type;

/** 输入完成Block */
@property (nonatomic, copy) void (^ inputFinishBlock)(NSString *);

@end
