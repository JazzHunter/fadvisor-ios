//
//  ViideoDetailsModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/17.
//

#import <UIKit/UIKit.h>
#import "BaseItemDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoDetailsModel : BaseItemDetailsModel

/** VideoId */
@property (nonatomic, copy) NSString *videoId;

/** 宽 */
@property (nonatomic, assign) NSUInteger width;

/** 高 */
@property (nonatomic, assign) NSUInteger height;

/** 跑马灯 */
@property (nonatomic, copy) NSString *bulletScreen;

/** 预览时间 */
@property (nonatomic, assign) NSUInteger previewTime;

/** 持续时间 */
@property (nonatomic, assign) CGFloat duration;

@end

NS_ASSUME_NONNULL_END
