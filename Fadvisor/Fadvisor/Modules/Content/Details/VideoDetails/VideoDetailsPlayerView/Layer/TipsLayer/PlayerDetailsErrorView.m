//
//  ALPVErrorMessageView.m
//

#import "PlayerDetailsErrorView.h"
#import "Utils.h"

static const CGFloat PlayerErrorViewWidth = 220;         //宽度
static const CGFloat PlayerErrorViewHeight = 120;        //高度
static const CGFloat PlayerErrorViewTextMarginTop = 30;  //text距离顶部距离
static const CGFloat PlayerErrorViewButtonWidth = 82;    //button宽度
static const CGFloat PlayerErrorViewButtonHeight = 30;       //button高度
static const CGFloat PlayerErrorViewButtonMarginLeft = 68;   //button左侧距离父类距离
static const CGFloat PlayerErrorViewRadius = 4;          //半径

@interface PlayerDetailsErrorView ()

@property (nonatomic, strong) UILabel *textLabel;        //错误界面，文本提示
@property (nonatomic, strong) UIButton *button;          //界面中 点击按钮
@property (nonatomic, strong) NSString *errorButtonEventType; //按钮中，提示信息（重播、重试等）

@end

@implementation PlayerDetailsErrorView

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setTextColor:[UIColor colorFromHexString:@"e7e7e7"]];
        [_textLabel setFont:[UIFont systemFontOfSize:14]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        _textLabel.numberOfLines = 999;
    }
    return _textLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:[UIImage imageNamed:@"player_rectangle_color"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"ic_reload_color"] forState:UIControlStateNormal];
        _button.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -12);
        [_button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

#pragma mark - init
- (instancetype)init {
    CGRect defaultFrame = CGRectMake(0, 0, PlayerErrorViewWidth, PlayerErrorViewHeight);
    return [self initWithFrame:defaultFrame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        [self.button setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
        self.button.titleLabel.textColor = [UIColor mainColor];
        self.button.layer.cornerRadius = 5;
        self.button.layer.borderWidth = 1;
        self.button.layer.masksToBounds = YES;
        self.button.layer.borderColor = [UIColor mainColor].CGColor;
        [self.button setImage:[UIImage imageNamed:@"ic_reload_color"] forState:UIControlStateNormal];
        self.textLabel.textColor = [UIColor mainColor];

        [self addSubview:self.textLabel];
        [self addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = PlayerErrorViewWidth;
    CGFloat height = PlayerErrorViewHeight;
    self.textLabel.frame = CGRectMake(0, PlayerErrorViewTextMarginTop, width, height);
    self.button.frame = CGRectMake(PlayerErrorViewButtonMarginLeft, PlayerErrorViewTextMarginTop / 2.0,
                                   PlayerErrorViewButtonWidth,
                                   PlayerErrorViewButtonHeight);
}

#pragma mark - 重写setter方法
- (void)setMessage:(NSString *)message {
    _message = message;
    self.textLabel.text = message;
    int width = PlayerErrorViewWidth;
    NSDictionary *dic = @{ NSFontAttributeName: self.textLabel.font };
    CGRect infoRect = [message boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    self.textLabel.frame = CGRectMake(0, self.width / 2.0, width, infoRect.size.height);
    [self setNeedsLayout];
}

/*
 "Retry" = "重试";
 "Replay" = "重播";
 "Play" = "播放";
 */
- (void)setErrorType:(PlayerErrorType)errorType {
    _errorType = errorType;
    NSString *str = @"";
    switch (errorType) {
        case PlayerErrorTypeUnknown:
            str = [@"Retry" localString];
            break;
        case PlayerErrorTypeRetry:
            str = [@"Retry" localString];
            break;
        case PlayerErrorTypeReplay:
            str = [@"Replay" localString];
            break;
        case PlayerErrorTypePause:
            str = [@"Play" localString];
            break;
        case PlayerErrorTypeStsExpired:
            str = [@"Retry" localString];
            break;
        default:
            break;
    }
    [_button setTitle:str forState:UIControlStateNormal];
}

#pragma mark - public method
/*
 * 功能 ：展示错误页面偏移量
 * 参数 ：parent 插入的界面
 */
- (void)showWithParentView:(UIView *)parent {
    if (!parent) {
        return;
    }
    parent.hidden = NO;
    [parent addSubview:self];
    self.center = CGPointMake(parent.frame.size.width / 2, parent.frame.size.height / 2);
    self.backgroundColor = [UIColor clearColor];
}

/*
 * 功能 ：是否展示界面
 */
- (BOOL)isShowing {
    return self.superview != nil;
}

/*
 * 功能 ：是否删除界面
 */
- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - onClick
- (void)onClick:(UIButton *)sender {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorViewClickedWithType:)]) {
        [self.delegate onErrorViewClickedWithType:self.errorType];
    }
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [Utils drawFillRoundRect:rect radius:PlayerErrorViewRadius/2 color:[UIColor colorFromHexString:@"373737"] context:context];
    CGContextRestoreGState(context);
}

@end
