//
//  AlivcLongVideoThumbnailView.h
//  AliyunVideoClient_Entrance
//
//  Created by wn Mac on 2019/7/15.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import <MyLayout/MyLayout.h>

@interface PlayerDetailsThumbnailView : MyRelativeLayout

// 应该是根据 Video 尺寸来的
//- (instancetype)initWithVideoSize:(CGSize)imageSize;

- (void)updateThumbnail:(UIImage *)thumbnailImage time:(NSTimeInterval)time durationTime:(float)durationTime;

@end
