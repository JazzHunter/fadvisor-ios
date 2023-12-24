//
//  FitNet.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (FitNet)

+ (void)loadImageWithURL:(NSURL *)imageURL
               transform:(YYWebImageTransformBlock)transform
              completion:(YYWebImageCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
