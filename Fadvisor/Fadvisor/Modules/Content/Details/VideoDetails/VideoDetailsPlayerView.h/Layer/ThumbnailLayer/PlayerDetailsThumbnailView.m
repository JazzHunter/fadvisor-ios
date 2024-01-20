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

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PlayerDetailsThumbnailView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.imageView];
        [self addSubview:self.timeLabel];
    }

    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.layer.borderWidth = 1;
        _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imageView.backgroundColor = [UIColor yellowColor];
    }

    return _imageView;
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

- (void)setTime:(NSTimeInterval)time {
    NSString *curTimeStr = [Utils timeformatFromSeconds:roundf(time)];
    self.timeLabel.text = curTimeStr;
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    self.imageView.image = thumbnailImage;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.width;
    CGFloat height = self.height;
    self.imageView.frame = CGRectMake(0, 30, width, height - 30);
    self.timeLabel.frame = CGRectMake(0, 0, width, 30);
}

@end
