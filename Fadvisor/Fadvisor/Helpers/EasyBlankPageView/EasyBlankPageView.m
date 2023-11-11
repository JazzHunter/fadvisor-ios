//
//  EasyBlankPageView.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/23.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "EasyBlankPageView.h"
#import <objc/runtime.h>
#import <MyLayout/MyLayout.h>

@interface EasyBlankPageView ()
/** 加载按钮 */
@property (retain, nonatomic) UIButton *reloadBtn;
/** 图片 */
@property (retain, nonatomic) YYAnimatedImageView *imageView;
/** 提示 label */
@property (retain, nonatomic) UILabel *titleLabel;
/** 按钮点击 */
/** 提示 label */
@property (retain, nonatomic) UILabel *descripitonLabel;

@property (nonatomic, copy) void (^ reloadBlock)(UIButton *sender);
@end

@implementation EasyBlankPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        rootLayout.widthSize.equalTo(self.widthSize);
        rootLayout.heightSize.equalTo(self.heightSize);
        rootLayout.gravity = MyGravity_Center;
        [rootLayout addSubview:self.titleLabel];
        self.imageView.myTop = 20;
        [rootLayout addSubview:self.imageView];
        self.descripitonLabel.myTop = 16;
        [rootLayout addSubview:self.descripitonLabel];
        self.reloadBtn.myTop = 20;
        [rootLayout addSubview:self.reloadBtn];
        [self addSubview:rootLayout];
        self.backgroundColor = [UIColor backgroundColor];
    }
    return self;
}

- (void)config:(EasyBlankPageViewType)blankPageType reloadButtonBlock:(void (^)(UIButton *sender))block {
    self.reloadBlock = [block copy];
    switch (blankPageType) {
        case EasyBlankPageViewTypeUnknown: {
            self.titleLabel.text = @"出现了一些问题";
            [self.titleLabel sizeToFit];
            self.descripitonLabel.text = @"貌似出了点差错……";
            [self.descripitonLabel sizeToFit];
            [self.imageView setImage:[UIImage imageNamed:@"exception_image_error"]];
            if (!block) {
                self.reloadBtn.hidden = block ? NO : YES;
            }
            break;
        };
        case EasyBlankPageViewTypeNetworkError: {
            self.titleLabel.text = @"网络出现了一些问题";
            [self.titleLabel sizeToFit];
            self.descripitonLabel.text = @"网络不是很顺畅";
            [self.descripitonLabel sizeToFit];
            [self.imageView setImage:[UIImage imageNamed:@"exception_network_error"]];
            self.reloadBtn.hidden = block ? NO : YES;
            break;
        };
        case EasyBlankPageViewTypeNoData: {
            self.titleLabel.text = @"没有数据";
            [self.titleLabel sizeToFit];
            self.descripitonLabel.text = @"您可以换个条件继续查看";
            [self.descripitonLabel sizeToFit];
            [self.imageView setImage:[UIImage imageNamed:@"exception_no_data"]];
            if (!block) {
                self.reloadBtn.hidden = block ? NO : YES;
            }
            break;
        }
    }
}

- (void)reloadClick:(UIButton *)btn {
    !self.reloadBlock ? : self.reloadBlock(btn);
}

#pragma mark - Lazy load
- (UIButton *)reloadBtn {
    if (!_reloadBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 140, 36);
        [btn setCornerRadius:6];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor mainColor] forState:UIControlStateNormal];
        [btn setTitle:@"点击重新加载" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleEdgeInsets = UIEdgeInsetsMake(12, 16, 12, 16);
        _reloadBtn = btn;
    }
    return _reloadBtn;
}

- (YYAnimatedImageView *)imageView {
    if (!_imageView) {
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
        imageView.autoPlayAnimatedImage = YES;
        imageView.mySize = CGSizeMake(160, 120);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 1;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor titleTextColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)descripitonLabel {
    if (!_descripitonLabel) {
        UILabel *descripitonLabel = [[UILabel alloc] init];
        descripitonLabel.numberOfLines = 1;
        descripitonLabel.textAlignment = NSTextAlignmentCenter;
        descripitonLabel.textColor = [UIColor descriptionTextColor];
        descripitonLabel.font = [UIFont systemFontOfSize:14];
        descripitonLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descripitonLabel = descripitonLabel;
    }
    return _descripitonLabel;
}

@end

#pragma mark - category部分

static void *BlankPageViewKey = &BlankPageViewKey;

@implementation UIView (EasyBlankPageView)
- (void)setBlankPageView:(EasyBlankPageView *)blankPageView {
    objc_setAssociatedObject(self, BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EasyBlankPageView *)blankPageView {
    return objc_getAssociatedObject(self, BlankPageViewKey);
}

- (void)showBlankPage:(void (^)(id))block {
    [self showBlankPage:CGRectZero blankPageType:EasyBlankPageViewTypeUnknown reloadButtonBlock:block];
}

- (void)showBlankPage:(EasyBlankPageViewType)blankPageType reloadButtonBlock:(void (^)(id))block {
    [self showBlankPage:CGRectZero blankPageType:blankPageType reloadButtonBlock:block];
}

- (void)showBlankPage:(CGRect)frame blankPageType:(EasyBlankPageViewType)blankPageType reloadButtonBlock:(void (^)(id))block {
    if (!self.blankPageView) {
        if (CGRectEqualToRect(frame, CGRectZero)) {
            self.blankPageView = [[EasyBlankPageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        } else {
            self.blankPageView = [[EasyBlankPageView alloc] initWithFrame:frame];
        }
    }
    [self.blankPageView config:blankPageType reloadButtonBlock:block];
    self.blankPageView.alpha = 0;
    [self addSubview:self.blankPageView];
//    [UIView animateWithDuration:0.3 animations:^{
    self.blankPageView.alpha = 1;
//    } completion:nil];
}

- (void)hideBlankPage {
    if (self.blankPageView) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.blankPageView.alpha = 0;
//        } completion:^(BOOL finished) {
            [self.blankPageView removeFromSuperview];
//        }];
    }
}

@end
