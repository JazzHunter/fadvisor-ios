//
//  AliyunStartPagesView.m
//  AliyunVodPlayerViewSDK
//
//  Created by 王凯 on 2017/10/12.
//  Copyright © 2017年 SMY. All rights reserved.
//

#import "PlayerDetailsFirstStartGuideView.h"

static const CGFloat FirstStartGuideViewCenterIVWidth = 56;  //centerImageView 宽度
static const CGFloat FirstStartGuideViewCenterIVHeight = 72; //centerImageView 高度
static const CGFloat FirstStartGuideViewLabelWidth = 150;    //label 宽度
static const CGFloat FirstStartGuideViewLabelHeight = 50;    //label 高度
static const CGFloat FirstStartGuideViewMargin = 10;         //centerImageView 高度
static const CGFloat FirstStartGuideViewTextFont = 17.0f;    //字体型号
static const CGFloat FirstStartGuideViewImageViewMargin = 100;      //图片之间间隙
static const CGFloat FirstStartGuideViewLeftIVWidth = 82;    //leftImageView 宽度
static const CGFloat FirstStartGuideViewLeftIVHeight = 58;   //leftImageView 高度

@interface PlayerDetailsFirstStartGuideView ()

@property (nonatomic, strong) UIControl *control;            //整体view，增加control手势
@property (nonatomic, strong) UIImageView *centerImageView; //中间图片
@property (nonatomic, strong) UILabel *centerLabel;          //中间图片下方label
@property (nonatomic, strong) UIImageView *leftImageView;   //左边图片
@property (nonatomic, strong) UILabel *leftLabel;            //左边图片下方label
@property (nonatomic, strong) UIImageView *rightImageView;  //右边图片
@property (nonatomic, strong) UILabel *rightLabel;           //右边图片下方label

@end;

@implementation PlayerDetailsFirstStartGuideView

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FirstStartGuideViewCenterIVWidth, FirstStartGuideViewCenterIVHeight)];
        _centerImageView.image = [UIImage imageNamed:@"player_guide_center"];
    }
    return _centerImageView;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FirstStartGuideViewLabelWidth, FirstStartGuideViewLabelHeight)];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.numberOfLines = 999;
        _centerLabel.textColor = [UIColor whiteColor];
    }
    return _centerLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FirstStartGuideViewLeftIVWidth, FirstStartGuideViewLeftIVHeight)];
        _leftImageView.image = [UIImage imageNamed:@"player_guide_left"];
    }
    return _leftImageView;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FirstStartGuideViewLabelWidth, FirstStartGuideViewLabelHeight)];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.numberOfLines = 999;
        _leftLabel.textColor = [UIColor whiteColor];
    }
    return _leftLabel;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FirstStartGuideViewLeftIVWidth, FirstStartGuideViewLeftIVHeight)];
        _rightImageView.image = [UIImage imageNamed:@"player_guide_right"];
    }
    return _rightImageView;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FirstStartGuideViewLabelWidth, FirstStartGuideViewLabelHeight)];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.numberOfLines = 999;
        _rightLabel.textColor = [UIColor whiteColor];
    }
    return _rightLabel;
}

- (UIControl *)control {
    if (!_control) {
        _control = [[UIControl alloc] init];
        [_control addTarget:self action:@selector(controlButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _control;
}

- (void)controlButton:(UIControl *)sender {
    [self removeFromSuperview];
    [[NSUserDefaults standardUserDefaults] setValue:FIRST_OPEN_FALSE_VALUE forKey:FIRST_OPEN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor maskBgColor];
        [self initUI];
        [self initText];
    }
    return self;
}

- (void)initUI {
    self.control.myMargin = 0;
    [self addSubview:self.control];

    self.centerImageView.centerXPos.equalTo(self.centerXPos);
    self.centerImageView.centerYPos.equalTo(self.centerYPos).offset(-(FirstStartGuideViewLabelHeight + FirstStartGuideViewMargin) / 2);
    [self addSubview:self.centerImageView];

    self.centerLabel.centerXPos.equalTo(self.centerImageView.centerXPos);
    self.centerLabel.topPos.equalTo(self.centerImageView.bottomPos).offset(FirstStartGuideViewMargin);
    [self addSubview:self.centerLabel];

    self.leftImageView.rightPos.equalTo(self.centerImageView.leftPos).offset(FirstStartGuideViewImageViewMargin);
    self.leftImageView.centerYPos.equalTo(self.centerImageView.centerYPos);
    [self addSubview:self.leftImageView];

    self.leftLabel.centerXPos.equalTo(self.leftImageView.centerXPos);
    self.leftLabel.topPos.equalTo(self.leftImageView.bottomPos).offset(FirstStartGuideViewMargin);
    [self addSubview:self.leftLabel];

    self.rightImageView.leftPos.equalTo(self.centerImageView.rightPos).offset(FirstStartGuideViewImageViewMargin);
    self.rightImageView.centerYPos.equalTo(self.centerImageView.centerYPos);
    [self addSubview:self.rightImageView];

    self.rightLabel.centerXPos.equalTo(self.rightImageView.centerXPos);
    self.rightLabel.topPos.equalTo(self.rightImageView.bottomPos).offset(FirstStartGuideViewMargin);
    [self addSubview:self.rightLabel];
}

- (void)initText {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = FirstStartGuideViewMargin;// 字体的行间距

    NSString *center = [@"center" localString];
    NSString *progress = [@"progress" localString];
    NSString *control = [@"control" localString];
    NSString *centerStr = [NSString stringWithFormat:@"%@\n %@ %@", center, progress, control];
    //    @"中心\n  进度调节";
    NSMutableAttributedString *maString = [[NSMutableAttributedString alloc] initWithString:centerStr];
    [maString addAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                               NSFontAttributeName: [UIFont systemFontOfSize:FirstStartGuideViewTextFont weight:UIFontWeightBold],
                               NSParagraphStyleAttributeName: paragraphStyle, } range:NSMakeRange(center.length + 2, progress.length + 1)];
    self.centerLabel.attributedText = maString;

    //    @"左侧\n  亮度调节";
    NSString *left = [@"left" localString];
    NSString *brightness = [@"brightness" localString];
    NSString *centerStr1 = [NSString stringWithFormat:@"%@\n %@ %@", left, brightness, control];
    NSMutableAttributedString *maString1 = [[NSMutableAttributedString alloc] initWithString:centerStr1];
    [maString1 addAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                NSFontAttributeName: [UIFont systemFontOfSize:FirstStartGuideViewTextFont weight:UIFontWeightBold],
                                NSParagraphStyleAttributeName: paragraphStyle, } range:NSMakeRange(left.length + 2, brightness.length + 1)];
    self.leftLabel.attributedText = maString1;

    //    @"右侧\n  音量调节";
    NSString *right = [@"right" localString];
    NSString *volume = [@"volume" localString];
    NSString *centerStr3 = [NSString stringWithFormat:@"%@\n %@ %@", right, volume, control];

    NSMutableAttributedString *maString3 = [[NSMutableAttributedString alloc] initWithString:centerStr3];
    [maString3 addAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                NSFontAttributeName: [UIFont systemFontOfSize:FirstStartGuideViewTextFont weight:UIFontWeightBold],
                                NSParagraphStyleAttributeName: paragraphStyle, } range:NSMakeRange(right.length + 2, volume.length + 1)];
    self.rightLabel.attributedText = maString3;
}

@end
