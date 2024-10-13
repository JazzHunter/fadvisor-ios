//
//  YTextField.m
//  SecurityCode
//
//  Created by 杨广军 on 2018/10/23.
//  Copyright © 2018年 杨广军. All rights reserved.
//

#import "YTextField.h"

@implementation YTextField

- (void)deleteBackward {
    // ！！！这里要调用super方法，要不然删不了东西
    if ([self.y_delegate respondsToSelector:@selector(yTextFieldDeleteBackward:)]) {
        [self.y_delegate yTextFieldDeleteBackward:self];
    }
    [super deleteBackward];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
