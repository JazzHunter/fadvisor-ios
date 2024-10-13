//
//  SecurityCodeView.m
//  SecurityCode
//
//  Created by 杨广军 on 2018/10/22.
//  Copyright © 2018年 杨广军. All rights reserved.
//

#import "SecurityCodeView.h"
#import "YTextField.h"

#define ScreenSize [[UIScreen mainScreen] bounds].size

@interface SecurityCodeView ()<YTextFieldDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *codeArray;
@property (nonatomic, strong) NSMutableArray *linesArray;

//显示样式
@property (nonatomic, assign) securityCodeType type;
//验证码数量
@property (nonatomic, assign) NSUInteger count;
//验证码之间的间距
@property (nonatomic, assign) NSUInteger space;

@end

@implementation SecurityCodeView

- (instancetype)initWithFrame:(CGRect)frame count:(NSUInteger)count space:(NSUInteger)space type:(securityCodeType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _count = count > 0 ? count : 6;
        _space = space;
//        _size = CGSizeMake(30, 40);
        _type = type;
        _defaultColor = [UIColor grayColor];
        _selectedColor = [UIColor yellowColor];
        _markColor = [UIColor blueColor];
        [self createUI];
    }
    return self;
}

//界面
- (void)createUI {
    self.codeArray = [NSMutableArray arrayWithCapacity:self.count];
    self.linesArray = [NSMutableArray arrayWithCapacity:self.count];

    CGFloat codeWidth = (self.width - self.space * (self.count - 1)) / self.count;
    CGFloat codeHeight = codeWidth;

    CGFloat left = 0;
    NSUInteger num = 1;
    while (num <= self.count) {
        CGFloat x = left + (num - 1) * (codeWidth + self.space);
        YTextField *textField = [[YTextField alloc]initWithFrame:CGRectMake(x, 0, codeWidth, codeHeight)];
        if (self.type == securityCodeTypeDownLine) {
            textField.borderStyle = UITextBorderStyleNone;

            UILabel *downLine = [[UILabel alloc]initWithFrame:CGRectMake(x, codeHeight + 10, codeWidth, 2)];
            downLine.backgroundColor = self.defaultColor;
            [self addSubview:downLine];
            [self.linesArray addObject:downLine];
        } else if (self.type == securityCodeTypeBox) {
            textField.borderStyle = UITextBorderStyleLine;
        }
        textField.y_delegate = self;
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:((NSUInteger)(codeWidth / 2)) weight:UIFontWeightBold];
        textField.textColor = [UIColor titleTextColor];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.tag = num - 1;
        [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:textField];

        if (num == 1) {
            [textField becomeFirstResponder];
        }
        [self.codeArray addObject:textField];

        num += 1;
    }
}

//输入内容，当内容长度为1，切换下个输入框
- (void)textFieldValueChanged:(UITextField *)textField {
    if (textField.text.length >= 1) {
        if (self.type == securityCodeTypeDownLine) {
            UILabel *line = [self.linesArray objectAtIndex:textField.tag];
            line.backgroundColor = self.selectedColor;
        }
        if (textField.tag + 1 < self.count) {
            //最好验证码输入完毕，键盘消失
            UITextField *nextTextField = [self getNextTextFieldWithIndex:textField.tag + 1];
            if (nextTextField.text.length == 1) {
                [textField resignFirstResponder];
            } else {
                [nextTextField becomeFirstResponder];
            }
        } else {
            [textField resignFirstResponder];
        }
    } else {
        if (self.type == securityCodeTypeDownLine) {
            UILabel *line = [self.linesArray objectAtIndex:textField.tag];
            line.backgroundColor = self.defaultColor;
        }
        if (textField.tag - 1 >= 0) {
            UITextField *lastTextField = [self.codeArray objectAtIndex:textField.tag - 1];
            [lastTextField becomeFirstResponder];
        }
    }
}

//获取下个输入框
- (UITextField *)getNextTextFieldWithIndex:(NSInteger)index {
    UITextField *nextTextField = [self.codeArray objectAtIndex:index];
    if (nextTextField.text.length == 1 && index + 1 < self.count) {
        return [self getNextTextFieldWithIndex:index + 1];
    }
    return nextTextField;
}

//获取上个输入框
- (UITextField *)getLastNextFieldWithIndex:(NSInteger)index {
    if (index >= 0) {
        UITextField *nextTextField = [self.codeArray objectAtIndex:index];
        return nextTextField;
    }
    return nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string isEqualToString:@""]) {
        //输入内容，如果当前输入框已有内容，切换到下一个
        if (textField.text.length == 1 && textField.tag + 1 < self.count) {
            UITextField *nextTextField = [self getNextTextFieldWithIndex:textField.tag + 1];
            if (nextTextField.text.length == 1) {
                return NO;
            } else {
                [nextTextField becomeFirstResponder];
            }
        } else if (textField.text.length == 1 && textField.tag + 1 == self.count) {
            return NO;
        }
    }
    return YES;
}

//删除事件
- (void)yTextFieldDeleteBackward:(YTextField *)textField {
    if (textField.tag != 0 && textField.text.length == 0) {
        UITextField *lastTextField = [self getLastNextFieldWithIndex:textField.tag - 1];
        [lastTextField becomeFirstResponder];
    }
}

- (void)setMarkColor:(UIColor *)markColor {
    _markColor = markColor;
    for (UITextField *tf in self.codeArray) {
        tf.tintColor = markColor;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
