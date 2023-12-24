//
//  AUIPlayerRecommendWatchPointView.m
//  ApsaraVideo
//
//  Created by mengyehao on 2021/7/29.
//

#import "AUIPlayerRecommendWatchPointView.h"
#import "AlivcPlayerAsset.h"

@interface AUIPlayerRecommendWatchPointView()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AUIPlayerRecommendWatchPointView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.titleLabel];
        self.backgroundColor = APGetColor(APColorTypeVideoBg60);
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat padding = 12;
    CGFloat top = 8;
    CGFloat height = 24;
    self.leftLabel.frame = CGRectMake(padding, top, 58, height);
    self.timeLabel.frame = CGRectMake(self.leftLabel.right + padding, top, 32, height);
        
    self.titleLabel.frame = CGRectMake(self.timeLabel.right + padding, top, self.width - self.timeLabel.right - padding - padding, height);

}

- (void)setModel:(AlivcPlayerWatchPointModel *)model
{
    _model = model;
    self.titleLabel.text = model.text;
    self.timeLabel.text = [self.class timeformatFromMilSeconds:model.ts];
    [self setNeedsLayout];
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 22)];
//        _leftLabel.accessibilityIdentifier = [self accessibilityId:@"leftLabel"];
        _leftLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _leftLabel.textColor = APGetColor(APColorTypeCyanBg);
        _leftLabel.layer.cornerRadius = 4;
        _leftLabel.layer.borderWidth = 1;
        _leftLabel.layer.borderColor = APGetColor(APColorTypeCyanBg).CGColor;
        _leftLabel.clipsToBounds = YES;
        _leftLabel.backgroundColor = APGetColor(APColorTypeCyanBg20);
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        NSString *text = @"看点 ";
        NSMutableAttributedString *attrubuteString = [[NSMutableAttributedString alloc] initWithString:text];
        
        NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
        attchment.image = [UIImage imageNamed:@"player_watchPoint"];
        attchment.bounds = CGRectMake(0, 0, 10, 10);
        NSAttributedString *attchmentString = [NSAttributedString attributedStringWithAttachment:attchment];
        [attrubuteString appendAttributedString:attchmentString];
        _leftLabel.attributedText = attrubuteString;

    }
    return _leftLabel;
}



- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 22)];
//        _titleLabel.accessibilityIdentifier = [self accessibilityId:@"titleLabel"];
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}


- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 22)];
//        _timeLabel.accessibilityIdentifier = [self accessibilityId:@"timeLabel"];
        _timeLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        _timeLabel.textColor = APGetColor(APColorTypeCCC);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}


+ (NSString *)timeformatFromMilSeconds:(NSInteger)seconds {
    //s
    seconds = seconds/1000;
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (long) (seconds / 60) % 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld", (long) seconds % 60];
    //format of time
    NSString *format_time = nil;

    format_time = [NSString stringWithFormat:@"%@:%@", str_minute, str_second];
    
    return format_time;
}

@end
