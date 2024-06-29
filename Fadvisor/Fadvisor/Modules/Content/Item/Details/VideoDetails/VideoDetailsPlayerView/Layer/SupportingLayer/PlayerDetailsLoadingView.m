//
//  PlayerDetailsLoadingView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/22.
//

#import "PlayerDetailsLoadingView.h"
#import "Utils.h"

@interface PlayerDetailsLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation PlayerDetailsLoadingView

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        _loadingView.color = [UIColor whiteColor];
    }
    return _loadingView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:12];
        [_textLabel sizeToFit];
    }
    return _textLabel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.orientation = MyOrientation_Vert;
        self.gravity = MyGravity_Horz_Center;
        self.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);

        [self addSubview:self.loadingView];
        self.textLabel.myTop = 8;
        [self addSubview:self.textLabel];

        self.isLoadingShow = NO;
        self.hidden = YES;
    }
    return self;
}

/*
 * 功能 ：展示loading
 */
- (void)showLoading {
    if (self.isLoadingShow && !self.hidden) {
        return;
    }
    [self.loadingView startAnimating];
    _textLabel.text = [NSString stringWithFormat:@"%@...", [@"正在缓冲" localString]];
    [_textLabel sizeToFit];
    self.hidden = NO;
    self.isLoadingShow = YES;
}

/*
 * 功能 ：设置下载速率
 */
- (void)setDownloadSpeed:(int64_t)speed {
    _textLabel.text = [NSString stringWithFormat:@"%@... %@", [@"正在缓冲" localString], [Utils formatFromBytes:speed]];
    [_textLabel sizeToFit];
}

/*
 * 功能 ：移除loading界面
 */
- (void)stopLoading {
    if (!self.isLoadingShow && self.hidden) {
        return;
    }
    [self.loadingView stopAnimating];
    self.hidden = YES;
    self.isLoadingShow = NO;
}

@end
