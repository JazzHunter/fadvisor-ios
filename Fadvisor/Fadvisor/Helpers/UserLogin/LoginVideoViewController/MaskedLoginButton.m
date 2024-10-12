//
//  MaskedLoginButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/20.
//

#import "MaskedLoginButton.h"
#import "RSMaskedLabel.h"

@interface MaskedLoginButton ()

@property (nonatomic, strong) RSMaskedLabel *maskedLabel;           //镂空标签

@end

@implementation MaskedLoginButton

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _maskedLabel = [[RSMaskedLabel alloc] initWithFrame:self.bounds];
        _maskedLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
        _maskedLabel.textAlignment = NSTextAlignmentCenter;
        _maskedLabel.backgroundColor = [UIColor whiteColor];
        _maskedLabel.layer.cornerRadius = self.height / 2;
        _maskedLabel.layer.masksToBounds = YES;

        [self addSubview:_maskedLabel];
        self.backgroundColor = [UIColor clearColor];

        [self addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(recoveryBackgourndColor) forControlEvents:UIControlEventTouchUpOutside];
    }
    return self;
}

- (void)setText:(NSString *)text {
    self.maskedLabel.text = text;
}

- (void)buttonTouchDown:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskedLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    }];
}

- (void)recoveryBackgourndColor {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskedLabel.backgroundColor = [UIColor whiteColor];
    }];
}

@end
