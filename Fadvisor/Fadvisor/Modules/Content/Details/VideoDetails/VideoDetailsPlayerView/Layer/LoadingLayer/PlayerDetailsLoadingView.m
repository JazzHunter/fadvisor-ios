//
//  ALPVCenterView.m
//

#import "PlayerDetailsLoadingView.h"
#import "PlayerDetailsGifView.h"

static const CGFloat LoadingViewGifViewWidth   = 28;   //gifView 宽度
static const CGFloat LoadingViewGifViewHeight  = 28;   //gifView 高度
static const CGFloat LoadingViewMargin         = 2;    //间隙
static const CGFloat LoadingViewWidth = 130;
static const CGFloat LoadingViewHeight = 120;

@interface PlayerDetailsLoadingView ()
@property (nonatomic, strong) PlayerDetailsGifView *gifView;
@property (nonatomic, strong) UILabel *tipLabelView;

@end

@implementation PlayerDetailsLoadingView

- (PlayerDetailsGifView *)gifView{
    if (!_gifView) {
        _gifView = [[PlayerDetailsGifView alloc] init];
//        [_gifView setGifImageWithName:@"al_loader"];
    }
    return _gifView;
}

- (UILabel *)tipLabelView{
    if (!_tipLabelView) {
        _tipLabelView = [[UILabel alloc] init];
        [_tipLabelView setText:[@"Loading" localString]];
        [_tipLabelView setTextColor:[UIColor colorFromHexString:@"e7e7e7"]];
        [_tipLabelView setFont:[UIFont systemFontOfSize:14]];
        [_tipLabelView setTextAlignment:NSTextAlignmentCenter];
    }
    return _tipLabelView;
}


#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setHidden:YES];
        [self addSubview:self.gifView];
        [self addSubview:self.tipLabelView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float margin = LoadingViewMargin;
    float textHeight = 14;
    float messageViewY = (width - textHeight) / 2;
    self.tipLabelView.frame = CGRectMake(0, messageViewY, width, textHeight);
    float gifWidth = LoadingViewGifViewWidth;
    float gifHeight = LoadingViewGifViewHeight;
    self.gifView.frame = CGRectMake((width - gifWidth) / 2, messageViewY - gifHeight - margin, gifWidth, gifWidth);
    [self.gifView startAnimation];
}

#pragma mark - public method
- (void)show {
    if (![self isHidden]) {
        return;
    }
    [self.gifView startAnimation];
    [self setHidden:NO];
}

- (void)dismiss {
    if ([self isHidden]) {
        return;
    }
    [self.gifView stopAnimation];
    [self setHidden:YES];
}

@end
