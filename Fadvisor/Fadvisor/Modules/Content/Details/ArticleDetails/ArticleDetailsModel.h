//
//  ArticleDetailsModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import "BaseItemDetailsModel.h"
#import "MediaModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleDetailsModel : BaseItemDetailsModel

/** 顶部视频 */
@property (nonatomic, strong) MediaModel *headerVideo;

/** 详情顶部封面图 */
@property (nonatomic, copy) NSString *headerImages;

/** 富文本音频 */
@property (nonatomic, strong) NSURL *contentVoice;

@end

NS_ASSUME_NONNULL_END
