//
//  AlivcPlayerDefine.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (int, AlvcPlayMethod) {
    AlvcPlayMethodUrl = 0,
    AlvcPlayMethodMPS,
    AlvcPlayMethodPlayAuth,
    AlvcPlayMethodSTS,
    AlvcPlayMethodLocal,
};


@interface AlivcPlayerDefine : NSObject

+ (NSArray<NSString *> *)allQualities;

@end

NS_ASSUME_NONNULL_END
