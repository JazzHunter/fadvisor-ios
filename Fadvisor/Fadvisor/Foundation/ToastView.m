//
//  AVToastView.m
//  ApsaraVideo
//
//  Created by Bingo on 2021/3/19.
//

#import "ToastView.h"
#import "Localization.h"

@interface ToastView ()

@property (nonatomic, strong) UILabel *toastLabel;

@end

@implementation ToastView

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)show:(NSString *)toast view:(UIView *)view position:(ToastViewPosition)position {
    if (!view) {
        return;
    }
    
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorFromHexString:@"#1C1D22" alpha:0.8];
    
    self.toastLabel = [[UILabel alloc] init];
    self.toastLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.toastLabel.textColor = [UIColor colorFromHexString:@"#FCFCFD"];
    self.toastLabel.numberOfLines = 0;
    self.toastLabel.text = toast;
    [self addSubview:self.toastLabel];
    
    CGSize best = [self.toastLabel sizeThatFits:CGSizeMake(view.width - 20 * 2 - 14 * 2, 0)];
    self.toastLabel.frame = CGRectMake(14, 12, best.width, best.height);
    self.frame = CGRectMake(0, 0, self.toastLabel.width + 14 * 2, self.toastLabel.height + 12 * 2);
    if (position == ToastViewPositionTop) {
        self.center = CGPointMake(view.width / 2.0, view.height / 4.0);
    }
    else if (position == ToastViewPositionBottom) {
        self.center = CGPointMake(view.width / 2.0, view.height * 3 / 4.0);
    }
    else {
        self.center = CGPointMake(view.width / 2.0, view.height / 2.0);
    }
    [view addSubview:self];
}

+ (ToastView *)show:(NSString *)toast view:(UIView *)view position:(ToastViewPosition)position {
    ToastView *toastView = [[ToastView alloc] init];
    [toastView show:toast view:view position:position];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toastView removeFromSuperview];
    });
    return toastView;
}

@end
