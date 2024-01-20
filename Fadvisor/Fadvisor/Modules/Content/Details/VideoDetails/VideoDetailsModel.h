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

@end

NS_ASSUME_NONNULL_END
