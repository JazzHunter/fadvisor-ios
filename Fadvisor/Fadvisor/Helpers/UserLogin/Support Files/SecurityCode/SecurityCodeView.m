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

@property (nonatomic, strong) NSMutableArray *textFieldArray;
@property (nonatomic, strong) NSMutableArray *linesArray;

//显示样式
@property (nonatomic, assign) securityCodeType type;
//验证码数量
@property (nonatomic, assign) NSUInteger count;
//验证码之间的间距
@property (nonatomic, assign) NSUInteger space;

@end

@implementation SecurityCodeView

- (instancetype)initWithFrame:(CGRect)frame count:(NSUInteger)count space:(NSUInteger)space underlineColor:(UIColor *)underlineColor type:(securityCodeType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _count = count > 0 ? count : 6;
        _space = space;
//        _size = CGSizeMake(30, 40);
        _type = type;
        _underlineColor = underlineColor;
        _confirmedColor = [UIColor yellowColor];
        _cursorColor = [UIColor blueColor];
        [self createUI];
    }
    return self;
}

//界面
- (void)createUI {
    self.textFieldArray = [NSMutableArray arrayWithCapacity:self.count];
    self.linesArray = [NSMutableArray arrayWithCapacity:self.count];

    CGFloat textFieldWidth = (self.width - self.space * (self.count - 1)) / self.count;
    CGFloat textFieldHeight = textFieldWidth;

    CGFloat left = 0;
    NSUInteger num = 1;
    while (num <= self.count) {
        CGFloat x = left + (num - 1) * (textFieldWidth + self.space);
        YTextField *textField = [[YTextField alloc]initWithFrame:CGRectMake(x, 0, textFieldWidth, textFieldHeight)];
        if (self.type == securityCodeTypeUnderline) {
            textField.borderStyle = UITextBorderStyleNone;

            UIView *underlineView = [[UIView alloc]initWithFrame:CGRectMake(x, textFieldHeight + 10, textFieldWidth, 2)];
            underlineView.backgroundColor = self.underlineColor;
            [self addSubview:underlineView];
            [self.linesArray addObject:underlineView];
        } else if (self.type == securityCodeTypeBox) {
            textField.borderStyle = UITextBorderStyleLine;
        }
        textField.y_delegate = self;
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:((NSUInteger)(textFieldWidth / 2)) weight:UIFontWeightBold];
        textField.textColor = [UIColor titleTextColor];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.tag = num - 1;
//        [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:textField];

        if (num == 1) {
            [textField becomeFirstResponder];
        }
        [self.textFieldArray addObject:textField];

        num += 1;
    }
}

#pragma mark - Actions

//获取下个输入框
- (UITextField *)getNextTextFieldWithIndex:(NSInteger)index {
    UITextField *nextTextField = [self.textFieldArray objectAtIndex:index];
    if (nextTextField.text.length == 1 && index + 1 < self.count) {
        return [self getNextTextFieldWithIndex:index + 1];
    }
    return nextTextField;
}

//获取上个输入框
- (UITextField *)getLastNextFieldWithIndex:(NSInteger)index {
    if (index >= 0) {
        UITextField *nextTextField = [self.textFieldArray objectAtIndex:index];
        return nextTextField;
    }
    return nil;
}

- (void)setCursorColor:(UIColor *)markColor {
    _cursorColor = markColor;
    for (UITextField *tf in self.textFieldArray) {
        tf.tintColor = markColor;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)handleCallback {
    if (!self.inputFinishBlock) {
        return;
    }
    NSMutableString *value = [NSMutableString string];
    for (int i = 0; i < self.textFieldArray.count; i++) {
        NSString *newChar = ((UITextField *)self.textFieldArray[i]).text;
        if ([newChar isEqualToString:@""]) {
            return;
        }
        [value appendString:newChar];
        NSLog(@"%@", ((UITextField *)self.textFieldArray[i]).text);
    }

    self.inputFinishBlock(value);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) { //输入了退格
        textField.text = @"";
        if (self.type == securityCodeTypeUnderline) {
            UILabel *line = [self.linesArray objectAtIndex:textField.tag];
            line.backgroundColor = self.underlineColor;
        }
        if (textField.tag - 1 >= 0) {
            UITextField *previousTextField = [self.textFieldArray objectAtIndex:textField.tag - 1];
            [previousTextField becomeFirstResponder];
        }
        
        return NO;
    }

    NSInteger textFieldTag = textField.tag;
    for (NSInteger i = 0; i < string.length; i++) {
        if (textFieldTag >= self.count) {
            break;
        }
        UITextField *textField = [self.textFieldArray objectAtIndex:textFieldTag];
        NSString *value = [string substringWithRange:NSMakeRange(i, 1)];
        textField.text = value;

        if (self.type == securityCodeTypeUnderline) {
            UILabel *line = [self.linesArray objectAtIndex:textFieldTag];
            line.backgroundColor = self.confirmedColor;
        }
        textFieldTag++;
    }

    NSInteger lastTag = textField.tag + string.length;
    if (lastTag < self.count) {
        UITextField *lastTextField = [self getNextTextFieldWithIndex:lastTag];
//        if (lastTextField.text.length == 1) {
//            return NO;
//        } else {
        [lastTextField becomeFirstResponder];
//        }
    } else {
        [textField resignFirstResponder];
        [self handleCallback];
        return NO;
    }

    return NO;
}

#pragma mark - YTextFieldDelegate
//删除事件
- (void)yTextFieldDeleteBackward:(YTextField *)textField {
    if (textField.tag != 0 && textField.text.length == 0) {
        UITextField *lastTextField = [self getLastNextFieldWithIndex:textField.tag - 1];
        [lastTextField becomeFirstResponder];
    }
}

@end
