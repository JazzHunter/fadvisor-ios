//
//  DocDetailsModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/23.
//

#import <Foundation/Foundation.h>
#import "BaseItemDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DocDetailsModel : BaseItemDetailsModel

/** snapshots */
@property (nonatomic, copy) NSString *snapshots;

@end

NS_ASSUME_NONNULL_END
