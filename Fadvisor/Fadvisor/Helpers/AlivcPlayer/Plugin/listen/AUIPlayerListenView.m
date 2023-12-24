//
//  AUIPlayerListenView.m
//  ApsaraVideo
//
//  Created by mengyehao on 2021/7/15.
//

#import "AUIPlayerListenView.h"
#import "AlivcPlayerAsset.h"
#import "AlivcPlayerMacro.h"
#import "UIImage+FitNet.h"

const static CGFloat kBgImageBlurRadius = 64;

@interface AUIPlayerListenViewButton : UIButton
@property (nonatomic, assign) CGFloat customImageHeight;
@end

@implementation AUIPlayerListenViewButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super imageRectForContentRect:contentRect];

    CGFloat height = _customImageHeight;

    if (height <= 0) {
        height = contentRect.size.height / 2;
    }

    rect.origin.x += (rect.size.width - height) / 2;
    rect.origin.y += (rect.size.height - height) / 2;
    rect.size = CGSizeMake(height, height);

    return rect;
}

@end

@interface AUIPlayerListenView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) AUIPlayerListenViewButton *avatarView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *waveImageView;
@property (nonatomic, strong) AUIPlayerListenViewButton *quitButton;
@property (nonatomic, strong) AUIPlayerListenViewButton *repalyButton;

@end

@implementation AUIPlayerListenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (UIButton *)playButton
{
    return _avatarView;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
//        _bgImageView.accessibilityIdentifier = [self accessibilityId:@"bgImageView"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.image = [UIImage imageNamed:@"comment_avatar"];
        [_bgImageView.image imageByBlurSoft];
        [_bgImageView.image imageByRoundCornerRadius:kBgImageBlurRadius];
    }
    return _bgImageView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[NoActionView alloc] init];
//        _maskView.accessibilityIdentifier = [self accessibilityId:@"maskView"];
        _maskView.backgroundColor = APGetColor(APColorTypeListenVideo);
    }
    return _maskView;
}

- (void)setupUI
{
    [self addSubview:self.maskView];
    [self addSubview:self.avatarView];
    [self addSubview:self.statusImageView];
    [self addSubview:self.descLabel];
    [self addSubview:self.waveImageView];
    [self addSubview:self.quitButton];
    [self addSubview:self.repalyButton];
}

- (void)updateAvataImageWithCoverurl:(NSString *)coverurl
{
    if (coverurl) {
        NSURL *imageURL = [NSURL URLWithString:coverurl];
        [UIImage loadImageWithURL:imageURL transform:nil completion:^(UIImage *_Nullable image, NSURL *_Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError *_Nullable error) {
            if (image && [imageURL isEqual:url]) {
                [self.avatarView setBackgroundImage:image forState:UIControlStateNormal];
//                _bgImageView.image = [image sd_blurredImageWithRadius:kBgImageBlurRadius];
            }
        }];
    }
}

- (void)setLandScape:(BOOL)landScape
{
    if (_landScape != landScape) {
        _landScape = landScape;
        _quitButton.titleEdgeInsets = [self kQuikTilteInset];
        _quitButton.imageEdgeInsets = [self kQuikImageInset];

        _repalyButton.titleEdgeInsets = [self kReplayTilteInset];
        _repalyButton.imageEdgeInsets = [self kReplayImageInset];

        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.width;
    CGFloat height = self.height;

    if (!self.landScape) {
        self.statusImageView.frame = CGRectMake(self.width - 26 - 12, 12, 20, 20);
    } else {
        self.statusImageView.frame = CGRectMake(self.width - 64 - 24, 26, 20, 20);
    }

    self.bgImageView.frame = self.bounds;
    self.maskView.frame = self.bounds;

    self.descLabel.font = [UIFont systemFontOfSize:[self kDescLabelFontSize] weight:UIFontWeightRegular];
    [self.descLabel sizeToFit];
    CGFloat paddingX = [self kPaddingX];
    CGFloat kAvatarSizeWidth = [self kAvatarViewSize].width;
    CGFloat left = (width - self.descLabel.width - paddingX - kAvatarSizeWidth) / 2;
    CGFloat top = (height - kAvatarSizeWidth) / 2;

    self.avatarView.frame = CGRectMake(left, top, kAvatarSizeWidth, kAvatarSizeWidth);
    self.avatarView.layer.cornerRadius = kAvatarSizeWidth / 2;
    self.avatarView.clipsToBounds = YES;
    self.avatarView.customImageHeight = kAvatarSizeWidth * 0.3;

    CGFloat descLabelHeight = [self kDescLabelHeight];
    self.descLabel.frame = CGRectMake(self.avatarView.right + paddingX, top, self.descLabel.width, descLabelHeight);

    CGSize waveSize = [self kWaveSize];

    self.waveImageView.frame = CGRectMake(self.avatarView.right + paddingX, CGRectGetMidY(self.avatarView.frame) - waveSize.height, waveSize.width, waveSize.height);

    CGSize buttonSize = [self kButtonSize];

    _quitButton.titleLabel.font = [UIFont systemFontOfSize:[self kButtonFontSize] weight:UIFontWeightRegular];
    self.quitButton.frame = CGRectMake(self.avatarView.right + paddingX, top, buttonSize.width, buttonSize.height);
    self.quitButton.bottom = self.avatarView.bottom;
    self.quitButton.customImageHeight =  buttonSize.height / 2 - 2;

    buttonSize = [self kRePlayButtonSize];
    _repalyButton.titleLabel.font =  [UIFont systemFontOfSize:[self kButtonFontSize] weight:UIFontWeightRegular];
    self.repalyButton.frame = CGRectMake(self.quitButton.right + paddingX, top, buttonSize.width, buttonSize.height);
    self.repalyButton.bottom = self.avatarView.bottom;
    self.repalyButton.customImageHeight =  buttonSize.height / 2 - 2;
}

- (CGSize)kAvatarViewSize
{
    CGSize size = CGSizeMake(80, 80);
    if (self.landScape) {
        size.width = 159;
        size.height = 159;
    }
    return size;
}

- (CGSize)kButtonSize
{
    CGSize size = CGSizeMake(80, 28);
    if (self.landScape) {
        size.width = 105;
        size.height = 36;
    }
    return size;
}

- (CGSize)kRePlayButtonSize
{
    CGSize size = CGSizeMake(56, 28);
    if (self.landScape) {
        size.width = 77;
        size.height = 36;
    }
    return size;
}

- (CGSize)kWaveSize
{
    CGSize size = CGSizeMake(163, 10);
    if (self.landScape) {
        size.width = 216;
        size.height = 10;
    }
    return size;
}

- (CGFloat)kButtonFontSize
{
    CGFloat pading = 12;
    if (self.landScape) {
        pading = 14;
    }
    return pading;
}

- (CGFloat)kPaddingX
{
    CGFloat pading = 12;
    if (self.landScape) {
        pading = 18;
    }
    return pading;
}

- (CGFloat)kDescLabelFontSize
{
    CGFloat pading = 12;
    if (self.landScape) {
        pading = 16;
    }
    return pading;
}

- (CGFloat)kDescLabelHeight
{
    CGFloat pading = 17;
    if (self.landScape) {
        pading = 24;
    }
    return pading;
}

- (UIEdgeInsets)kQuikImageInset
{
    if (self.landScape) {
        return UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return UIEdgeInsetsMake(0, -6, 0, 0);
}

- (UIEdgeInsets)kQuikTilteInset
{
    if (self.landScape) {
        return UIEdgeInsetsMake(0, 6, 0, 0);
    }
    return UIEdgeInsetsMake(0, 2, 0, 0);
}

- (UIEdgeInsets)kReplayImageInset
{
    if (self.landScape) {
        return UIEdgeInsetsMake(0, -8, 0, 0);
    }
    return UIEdgeInsetsMake(0, -3, 0, 0);
}

- (UIEdgeInsets)kReplayTilteInset
{
    if (self.landScape) {
        return UIEdgeInsetsMake(0, 2, 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UIImageView *)statusImageView
{
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
//        _statusImageView.accessibilityIdentifier = [self accessibilityId:@"statusImageView"];
        _statusImageView.image = [UIImage imageNamed:@"player_backmode_seleted"];
        _statusImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onQuitButtonClick:)];
        [_statusImageView addGestureRecognizer:tap];
    }
    return _statusImageView;
}

- (AUIPlayerListenViewButton *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[AUIPlayerListenViewButton alloc] init];
//        _avatarView.accessibilityIdentifier = [self accessibilityId:@"avatarView"];
        [_avatarView addTarget:self action:@selector(onPlayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_avatarView setBackgroundImage:[UIImage imageNamed:@"comment_avatar"] forState:UIControlStateNormal];
        [_avatarView setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [_avatarView setImage:[UIImage imageNamed:@"player_paused"] forState:UIControlStateSelected];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarView;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
//        _descLabel.accessibilityIdentifier = [self accessibilityId:@"descLabel"];
        _descLabel.text = AlivcPlayerString(@"Player_Audio_Tips");
        _descLabel.textColor = UIColor.whiteColor;
        _descLabel.numberOfLines = 1;
    }
    return _descLabel;
}

- (UIImageView *)waveImageView
{
    if (!_waveImageView) {
        _waveImageView = [[UIImageView alloc] init];
//        _waveImageView.accessibilityIdentifier = [self accessibilityId:@"waveImageView"];
    }

    return _waveImageView;
}

- (AUIPlayerListenViewButton *)quitButton
{
    if (!_quitButton) {
        _quitButton = [[AUIPlayerListenViewButton alloc] init];
//        _quitButton.accessibilityIdentifier = [self accessibilityId:@"quitButton"];
        [_quitButton addTarget:self action:@selector(onQuitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_quitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_quitButton setTitle:AlivcPlayerString(@"Player_Back_Video") forState:UIControlStateNormal];
        [_quitButton setImage:[UIImage imageNamed:@"player_back_video"] forState:UIControlStateNormal];
        [_quitButton setBackgroundColor:APGetColor(APColorTypeVideoBg40)];
        _quitButton.layer.cornerRadius = 4;
        _quitButton.clipsToBounds = YES;
        _quitButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _quitButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _quitButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    }
    return _quitButton;
}

- (AUIPlayerListenViewButton *)repalyButton
{
    if (!_repalyButton) {
        _repalyButton = [[AUIPlayerListenViewButton alloc] init];
//        _repalyButton.accessibilityIdentifier = [self accessibilityId:@"repalyButton"];
        [_repalyButton addTarget:self action:@selector(onRePlayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_repalyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_repalyButton setTitle:@"重播" forState:UIControlStateNormal];
        [_repalyButton setImage:[UIImage imageNamed:@"player_refresh"] forState:UIControlStateNormal];
        [_repalyButton setBackgroundColor:APGetColor(APColorTypeVideoBg40)];
        _repalyButton.layer.cornerRadius = 4;
        _repalyButton.clipsToBounds = YES;
        _repalyButton.hidden = YES;
    }
    return _repalyButton;
}

- (void)onPlayButtonClick:(id)sender
{
    if (self.onPlayButtonBlock) {
        self.onPlayButtonBlock();
    }
}

- (void)onQuitButtonClick:(id)sender
{
    if (self.onQuitButtonBlock) {
        self.onQuitButtonBlock();
    }
}

- (void)onRePlayButtonClick:(id)sender
{
    if (self.onRePlayButtonBlock) {
        self.onRePlayButtonBlock();
    }
}

- (void)updatePlayStatus:(BOOL)play
{
    self.avatarView.selected = play;
    if (play) {
        self.waveImageView.image = [UIImage imageNamed:@"player_wave_play"];
    } else {
        self.waveImageView.image = [UIImage imageNamed:@"player_wave_paused"];
    }
}

- (void)updaRePlayHidden:(BOOL)hidden
{
    self.repalyButton.hidden = hidden;
}

@end
