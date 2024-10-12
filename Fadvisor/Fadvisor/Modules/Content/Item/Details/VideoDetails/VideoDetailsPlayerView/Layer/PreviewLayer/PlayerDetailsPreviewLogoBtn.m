//
//  AlivcLongVideoPreviewLogoView.m
//  AliyunVideoClient_Entrance
//
//  Created by wn Mac on 2019/7/16.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import "PlayerDetailsPreviewLogoBtn.h"

@implementation PlayerDetailsPreviewLogoBtn

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor maskBgColor];
        [self setImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"bg_vip"] forState:UIControlStateNormal];
        [self setTitle:[@"试看前5分钟" localString] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
       
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
   
    CGFloat height = self.height;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:0.99f green:0.73f blue:0.01f alpha:1.00f].CGColor;
    self.layer.cornerRadius = height/2;
    
}

@end
