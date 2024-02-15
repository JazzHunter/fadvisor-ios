//
//  AlivcPlayerDefine.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (int, AlivcPlayMethod) {
    AlivcPlayMethodUrl = 0,
    AlivcPlayMethodMPS,
    AlivcPlayMethodPlayAuth,
    AlivcPlayMethodSTS,
    AlivcPlayMethodLocal,
};


@interface AlivcPlayerDefine : NSObject

+ (NSArray<NSString *> *)allQualities;

@end

NS_ASSUME_NONNULL_END
