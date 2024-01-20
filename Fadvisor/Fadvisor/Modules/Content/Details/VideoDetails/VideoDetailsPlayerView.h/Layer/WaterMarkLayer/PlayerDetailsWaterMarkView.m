//
//  AVCWaterMarkView.m
//  AliyunVideoClient_Entrance
//
//  Created by 汪宁 on 2019/3/9.
//  Copyright © 2019年 Alibaba. All rights reserved.
//

#import "PlayerDetailsWaterMarkView.h"

@implementation PlayerDetailsWaterMarkView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    if (self = [super init]) {
        self.frame = frame;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.image = image ? image : [UIImage imageNamed:@"player_water_mark"];
    }
    return self;
}

- (void)setWaterMarkImage:(UIImage *)waterMarkImage {
    if (waterMarkImage) {
        self.image = waterMarkImage;
    }
}

@end
