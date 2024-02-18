//
//  AlivcLongVideoThumbnailView.m
//  AliyunVideoClient_Entrance
//
//  Created by wn Mac on 2019/7/15.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import "PlayerDetailsThumbnailView.h"
#import "Utils.h"

@interface PlayerDetailsThumbnailView ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *thumbnailImageView;

@end

@implementation PlayerDetailsThumbnailView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor yellowColor];
        self.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        [self addSubview:self.thumbnailImageView];
        [self addSubview:self.timeLabel];
    }

    return self;
}

- (UIImageView *)thumbnailImageView {
    if (!_thumbnailImageView) {
        _thumbnailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 208, 208 * 9 / 16)];
        _thumbnailImageView.layer.cornerRadius = 5;
        _thumbnailImageView.layer.masksToBounds = YES;
        _thumbnailImageView.layer.borderWidth = 3;
        _thumbnailImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        _thumbnailImageView.backgroundColor = [UIColor yellowColor];
    }

    return _thumbnailImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:20];
    }

    return _timeLabel;
}

- (void)updateThumbnail:(UIImage *)thumbnailImage time:(NSTimeInterval)time durationTime:(float)durationTime {
    self.thumbnailImageView.image = thumbnailImage;
    NSString *curTimeStr = [Utils timeformatFromSeconds:roundf(time)];
    self.timeLabel.text = curTimeStr;
    [self.timeLabel sizeToFit];
}

@end
