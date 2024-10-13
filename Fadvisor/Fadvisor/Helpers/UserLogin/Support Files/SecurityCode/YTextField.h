//
//  YTextField.h
//  SecurityCode
//
//  Created by 杨广军 on 2018/10/23.
//  Copyright © 2018年 杨广军. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTextField;

@protocol YTextFieldDelegate <NSObject>

- (void)yTextFieldDeleteBackward:(YTextField *)textField;
@end

@interface YTextField : UITextField

@property (nonatomic, weak) id <YTextFieldDelegate> y_delegate;

@end
