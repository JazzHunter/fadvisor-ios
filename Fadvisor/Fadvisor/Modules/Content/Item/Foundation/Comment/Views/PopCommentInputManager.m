//
//  PopCommentInputFullScreen.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/10.
//

#import "PopCommentInputManager.h"
#import "UITextView+WZB.h"
#import "ImageButton.h"

#define DefaultTextViewHeight   34.f
#define TextViewMaxHeightHalfscreen 204.f

@interface PopCommentInputManager ()

@property (nonatomic, strong) MyRelativeLayout *contentLayout;
@property (nonatomic, strong) UITextView *textView; /**< 输入框 */

@property (nonatomic, strong) ImageButton *fullScreenSwitchButton; /**< 输入框 */
@property (nonatomic, strong) UIButton *submitButton; /**< 发送按钮*/

@property (atomic, assign) CGFloat keyboardHeight; /**< 键盘高度 */
@property (atomic, assign) CGFloat currentTextViewHeight; /**< 键盘高度 */

@property (atomic, assign) BOOL showKeyboardWithPop;
@property (atomic, assign) BOOL hideKeyboardWithResign;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation PopCommentInputManager

static PopCommentInputManager *manager = nil;
static dispatch_once_t onceToken;
+ (instancetype)manager
{
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

        [self setupUI];
        [self addObserver];

        self.keyboardHeight = 0;

        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resign:)];
        
        [self addGestureRecognizer:self.tapGestureRecognizer];
        
//        [self setTarget:self action:@selector(resign)];
    }
    return self;
}

- (void)setupUI {
    self.contentLayout = [MyRelativeLayout new];
    [self.contentLayout.layer setCornerRadius:12];
    [self.contentLayout.layer setMasksToBounds:YES];
    [self.contentLayout.layer setMaskedCorners:kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner];

    self.contentLayout.padding = UIEdgeInsetsMake(12, 16, 12, 16);
    self.contentLayout.myHeight = MyLayoutSize.wrap;
    self.contentLayout.leftPos.equalTo(self.leftPos);
    self.contentLayout.rightPos.equalTo(self.rightPos);
    self.contentLayout.backgroundColor = [UIColor backgroundColor];
    [self addSubview:self.contentLayout];
    self.contentLayout.topPos.equalTo(self.bottomPos);

    self.fullScreenSwitchButton.rightPos.equalTo(self.contentLayout.rightPos);
    self.fullScreenSwitchButton.topPos.equalTo(self.contentLayout.topPos);
    [self.contentLayout addSubview:self.fullScreenSwitchButton];

    self.textView.leftPos.equalTo(self.contentLayout.leftPos);
    self.textView.rightPos.equalTo(self.fullScreenSwitchButton.leftPos).offset(8);
    self.textView.topPos.equalTo(self.contentLayout.topPos);
    [self resetLayout];
    Weak(self);
    self.textView.wzb_textViewHeightDidChanged = ^(CGFloat currentTextViewHeight) {
        weakself.currentTextViewHeight = currentTextViewHeight;
    };
    [self.contentLayout addSubview:self.textView];

    MyRelativeLayout *bottomToolLayout = [MyRelativeLayout new];
    bottomToolLayout.leftPos.equalTo(self.contentLayout.leftPos);
    bottomToolLayout.rightPos.equalTo(self.contentLayout.rightPos);
    bottomToolLayout.topPos.equalTo(self.textView.bottomPos);
    bottomToolLayout.paddingTop = 8;
    bottomToolLayout.myHeight = MyLayoutSize.wrap;
    [self.contentLayout addSubview:bottomToolLayout];

    self.submitButton.rightPos.equalTo(bottomToolLayout.rightPos);
    [bottomToolLayout addSubview:self.submitButton];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 添加通知
 */
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)pop {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    [window addSubview:self];

    self.showKeyboardWithPop = YES;
    [self.textView becomeFirstResponder];
}

- (void)resign:(UITapGestureRecognizer *)gestureRecognizer {
    
    //如果手势点自于contentLayout则不做相应
    CGPoint point = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.contentLayout.frame, point)) {
        return;
    }
    self.hideKeyboardWithResign = YES;
    [self.textView resignFirstResponder];
}

- (void)resetLayout {
    self.textView.height = DefaultTextViewHeight;
    self.currentTextViewHeight = DefaultTextViewHeight;
    [self.textView wzb_autoHeightWithMaxHeight:TextViewMaxHeightHalfscreen];
}

/**
 键盘通知
 */
- (void)keyboardChange:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    CGFloat duration = [[userInfo valueForKeyPath:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat keyboardHeight = [[userInfo valueForKeyPath:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;  /**< 键盘的高度 */

    if ([notifi.name isEqualToString:UIKeyboardWillShowNotification]) {
        // 键盘弹起
        self.contentLayout.bottomPos.active = YES;
        self.contentLayout.bottomPos.equalTo(self.bottomPos).offset(keyboardHeight);
        self.keyboardHeight = keyboardHeight;
        if (self.showKeyboardWithPop) {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            self.contentLayout.topPos.active = NO;
        } else {
            self.contentLayout.paddingBottom = 12;
            if (self.fullScreenSwitchButton.selected) {
                self.textView.height = kScreenHeight - self.keyboardHeight - kStatusBarHeight - 12 * 2 - 8 - 30;
                [self.textView wzb_autoHeightWithMaxHeight:self.textView.height];
            }
        }
        
        [UIView animateWithDuration:duration animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (self.showKeyboardWithPop) {
                self.showKeyboardWithPop = NO;
            }
        }];
    } else if ([notifi.name isEqualToString:UIKeyboardWillHideNotification]) {
        if (self.hideKeyboardWithResign) {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            self.contentLayout.topPos.active = YES;
            self.contentLayout.topPos.equalTo(self.bottomPos).offset(0);
            self.contentLayout.bottomPos.active = NO;
        } else {
            self.contentLayout.bottomPos.active = YES;
            self.contentLayout.bottomPos.equalTo(self.bottomPos).offset(0);
            self.contentLayout.paddingBottom = 12 + SafeBottom;
            if (self.fullScreenSwitchButton.selected) {
                self.textView.height = kScreenHeight - kStatusBarHeight - 12 * 2 - 8 - 30 - SafeBottom;
                [self.textView wzb_autoHeightWithMaxHeight:self.textView.height];
            }
        }
        self.keyboardHeight = 0;
        [UIView animateWithDuration:duration animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (self.hideKeyboardWithResign) {
                self.hideKeyboardWithResign = NO;
                [self removeFromSuperview];
            }
        }];
    }
}

- (void)fullScreenButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;

    //普通状态
    if (!sender.selected) {
        self.textView.height = self.currentTextViewHeight;
        [self.textView wzb_autoHeightWithMaxHeight:TextViewMaxHeightHalfscreen];
    } else { // 全屏状态
        CGFloat height =  kScreenHeight - self.keyboardHeight - kStatusBarHeight - 12 * 2 - 8 - 30;
        if (self.fullScreenSwitchButton.selected && self.keyboardHeight == 0) {
            height -= SafeBottom;
        }
        self.textView.height = height;
        [self.textView wzb_autoHeightWithMaxHeight:height];
    }
}

- (void)submitButtonClicked:(UIButton *)sender {
}

#pragma mark - Lazy Load

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.wzb_placeholder = @"良言一句三冬暖，恶语伤人六月寒";
        _textView.font = [UIFont systemFontOfSize:ListContentFontSize];
        _textView.textColor = [UIColor contentTextColor];
    }
    return _textView;
}

- (ImageButton *)fullScreenSwitchButton {
    if (!_fullScreenSwitchButton) {
        _fullScreenSwitchButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24) imageName:@"ic_fullscreen"];
        [_fullScreenSwitchButton setImage:[UIImage imageNamed:@"ic_fullscreen_resume"] forState:UIControlStateSelected];
//        _fullScreenSwitchButton.imageSize = CGSizeMake(24, 24);
        [_fullScreenSwitchButton enableTouchDownAnimation];
        [_fullScreenSwitchButton addTarget:self action:@selector(fullScreenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenSwitchButton;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(0, 0, 80, 30);
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
        _submitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitle:[@"发布" localString] forState:UIControlStateNormal];
        _submitButton.clipsToBounds = YES;
//        [_submitButton.layer setBorderColor:[UIColor mainColor].CGColor];
//        _submitButton.layer.borderWidth = 2;
        [_submitButton setCornerRadius:6];
        _submitButton.backgroundColor = [UIColor mainColor];
        [_submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
