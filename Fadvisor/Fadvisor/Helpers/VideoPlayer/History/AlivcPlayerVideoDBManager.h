//
//  AlivcPlayerVideoDBManager.h
//  AliyunVideoClient_Entrance
//
//  Created by wn Mac on 2019/7/2.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlivcPlayerVideoDBModel.h"

#define VIDEO_HISTORY_DB [AlivcPlayerVideoDBManager shareManager]

@interface AlivcPlayerVideoDBManager : NSObject

+ (instancetype)shareManager;

/*********** 观看历史记录部分 *********/

- (void)addHistoryModel:(AlivcPlayerVideoDBModel *)model;

- (BOOL)hasHistoryModelFromvideoId:(NSString *)videoId userId:(NSString *)userId;

- (AlivcPlayerVideoDBModel *)getHistoryModelFromVideoId:(NSString *)videoId userId:(NSString *)userId;

- (void)deleteAllHistory:(NSString *)userId;

- (NSArray *)historyModelArray:(NSString *)userId;

- (void)deleteHistoryTimeOut;

@end
