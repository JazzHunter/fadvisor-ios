//
//  ContentExcepitonView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/30.
//

#import "ContentExcepitonView.h"
#import <objc/runtime.h>
#import <MyLayout/MyLayout.h>

@interface ContentExcepitonView ()

/** 图片 */
@property (retain, nonatomic) YYAnimatedImageView *imageView;

/** 提示 label */
@property (retain, nonatomic) UILabel *titleLabel;

/** 提示 label */
@property (retain, nonatomic) UILabel *descripitonLabel;

/** 加载按钮 */
@property (retain, nonatomic) UIButton *reloadBtn;

/**  */
@property (nonatomic, copy) void (^ reloadBlock)(UIButton *sender);

@end

@implementation ContentExcepitonView

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
    }
    return self;
}

- (void)config:(ContentExcepitonType)contentExcepitonType tips:(nullable NSString *)tips reloadButtonBlock:(void (^)(UIButton *sender))block {
    self.reloadBlock = [block copy];
    switch (contentExcepitonType) {
        case ContentExcepitonTypeNoData: {
            [self setUI:@"没有找到什么内容" descriptionText:@"您可以换一种方式继续试一下" imageName:@"exception_empty" hideReloadBtn:YES reloadBtnLabel:nil];
            break;
        };
        case ContentExcepitonTypeNetworkError: {
            self.imageView.mySize = CGSizeMake(140, 140);
            [self setUI:@"出错了……" descriptionText:tips ? tips : @"网络似乎不太好" imageName:@"exception_error_lamp" hideReloadBtn:block ? NO : YES reloadBtnLabel:@"点击重新加载"];
            break;
        };
        case ContentExcepitonTypeUnknown: {
            [self setUI:@"出现了一些问题" descriptionText:tips ? tips : @"貌似出了点差错……" imageName:@"exception_error_face" hideReloadBtn:block ? NO : YES reloadBtnLabel:@"点击重新加载"];
            break;
        };
    }
}

- (void)config:(ResultMode)resultMode acquisitionAction:(AcquisitionAction)acquisitionAction model:(ItemModel *)model reloadButtonBlock:(void (^)(UIButton *sender))block {
    self.reloadBlock = [block copy];
    switch (resultMode) {
        case ResultModeNotFound: {
            [self setUI:@"没有找到相关内容" descriptionText:@"该内容可能已经下架或删除" imageName:@"excepiton_404_ufo" hideReloadBtn:YES reloadBtnLabel:nil];
            break;
        };
        case ResultModeWaiting: {
            [self setUI:@"相关内容正在处理中" descriptionText:@"您查看的内容当前正在处理中，请您稍后再试" imageName:@"exception_empty_box" hideReloadBtn:YES reloadBtnLabel:nil];
            break;
        };
        case ResultModeHalt: {
            [self setUI:@"相关内容已下架" descriptionText:@"您查看的内容已下架..." imageName:@"exception_empty_box" hideReloadBtn:YES reloadBtnLabel:nil];
            break;
        };
        case ResultModeNotAuthorized: {
            switch (acquisitionAction) {
                case AcquisitionActionLoginRequired: {
                    [self setUI:@"需要登录" descriptionText:@"该内容需要登录后才能查看" imageName:@"exception_login_required" hideReloadBtn:NO reloadBtnLabel:@"进行登录"];
                };
                case AcquisitionActionInternalResource: {
                    [self setUI:@"需要内部认证" descriptionText:@"该内容仅限内部使用" imageName:@"exception_no_content" hideReloadBtn:NO reloadBtnLabel:@"内部认证"];
                };
                case AcquisitionActionRestrictResource: {
                    [self setUI:@"私有内容" descriptionText:@"该内容仅开放给特定用户，请与您的对接人联系获取帮助" imageName:@"excepiton_unauthorized" hideReloadBtn:YES reloadBtnLabel:nil];
                };
                case AcquisitionActionCodeRequired: {
                    [self setUI:@"需要验证码" descriptionText:@"该内容需要输入验证码才能查看" imageName:@"exception_code_required" hideReloadBtn:NO reloadBtnLabel:@"输入验证码"];
                };
                case AcquisitionActionPayRequired: {
                    [self setUI:@"需要付费" descriptionText:@"该内容需要付费后才能查看" imageName:@"exception_pay_required" hideReloadBtn:NO reloadBtnLabel:@"付费"];
                };
                case AcquisitionActionCollRequired: {
                    [self setUI:@"需要取得专栏的权限" descriptionText:@"该内容需要获取合集的权限" imageName:@"excepiton_unauthorized" hideReloadBtn:YES reloadBtnLabel:nil];
                };
                case AcquisitionActionNone: {
                    [self setUI:@"无法查看" descriptionText:@"该内容目前无法查看" imageName:@"exception_error_face" hideReloadBtn:YES reloadBtnLabel:nil];
                };
                default: break;
            }
        };
        default: break;
    }
}

- (void)setUI:(NSString *)titleText descriptionText:(NSString *)descriptionText imageName:(NSString *)imageName hideReloadBtn:(BOOL)hideReloadBtn reloadBtnLabel:(nullable NSString *)reloadBtnLabel {
    self.titleLabel.text = titleText;
    [self.titleLabel sizeToFit];
    self.descripitonLabel.text = descriptionText;
    [self.descripitonLabel sizeToFit];
    [self.imageView setImage:[UIImage imageNamed:imageName]];
    self.reloadBtn.hidden = hideReloadBtn;
    if (!hideReloadBtn) {
        [self.reloadBtn setTitle:reloadBtnLabel forState:UIControlStateNormal];
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
        titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
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

static void *ContentExcepitonViewKey = &ContentExcepitonViewKey;

@implementation UIView (ContentExcepitonView)
- (void)setExceptionView:(ContentExcepitonView *)exceptionView {
    objc_setAssociatedObject(self, ContentExcepitonViewKey,
                             exceptionView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ContentExcepitonView *)exceptionView {
    return objc_getAssociatedObject(self, ContentExcepitonViewKey);
}

- (void)showEmptyList {
    if (!self.exceptionView) {
        self.exceptionView = [[ContentExcepitonView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    [self.exceptionView config:ContentExcepitonTypeNoData tips:nil reloadButtonBlock:nil];
    self.exceptionView.alpha = 0;
    [self addSubview:self.exceptionView];
//    [UIView animateWithDuration:0.3 animations:^{
    self.exceptionView.alpha = 1;
//    } completion:nil];
}

- (void)showNetworkError:(nullable NSString *)tips reloadButtonBlock:(void (^)(id))block {
    if (!self.exceptionView) {
        self.exceptionView = [[ContentExcepitonView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    [self.exceptionView config:ContentExcepitonTypeNetworkError tips:tips reloadButtonBlock:block];
    self.exceptionView.alpha = 0;
    [self addSubview:self.exceptionView];
//    [UIView animateWithDuration:0.3 animations:^{
    self.exceptionView.alpha = 1;
//    } completion:nil];
}

- (void)showPermissionError:(ResultMode)resultMode acquisitionAction:(AcquisitionAction)acquisitionAction model:(ItemModel *)model reloadButtonBlock:(void (^)(UIButton *sender))block {
    if (!self.exceptionView) {
        self.exceptionView = [[ContentExcepitonView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    [self.exceptionView config:resultMode acquisitionAction:acquisitionAction model:model reloadButtonBlock:block];
    self.exceptionView.alpha = 0;
    [self addSubview:self.exceptionView];
//    [UIView animateWithDuration:0.3 animations:^{
    self.exceptionView.alpha = 1;
//    } completion:nil];
}

- (void)hideBlankPage {
    if (self.exceptionView) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.blankPageView.alpha = 0;
//        } completion:^(BOOL finished) {
        [self.exceptionView removeFromSuperview];
//        }];
    }
}

@end
