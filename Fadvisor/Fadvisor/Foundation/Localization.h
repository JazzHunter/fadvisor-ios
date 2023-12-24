//
//  Localization.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define GetString(key, module)  [Localization stringWithKey:(key) withModule:(module)]

@interface Localization : NSObject

+ (NSString *)stringWithKey:(NSString *)key withModule:(NSString *)module;

@end

NS_ASSUME_NONNULL_END
