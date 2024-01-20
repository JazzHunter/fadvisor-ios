//
//  CommonFunc.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonFunc : NSObject

+ (NSString *)getDeviceId;

+ (void)saveImage:(UIImage *)image inView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
