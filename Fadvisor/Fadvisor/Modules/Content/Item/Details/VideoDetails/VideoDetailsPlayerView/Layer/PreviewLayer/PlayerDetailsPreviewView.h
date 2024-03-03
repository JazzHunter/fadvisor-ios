//
//  AlivcLongVideoPreviewView.h
//  AliyunVideoClient_Entrance
//
//  Created by wn Mac on 2019/7/15.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PlayerDetailsPreviewViewDelegate <NSObject>

- (void)previewViewReplay;

- (void)previewViewGoVipController;

- (void)previewViewGoBack;

@end


@interface PlayerDetailsPreviewView : UIView

@property (nonatomic, weak) id <PlayerDetailsPreviewViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
