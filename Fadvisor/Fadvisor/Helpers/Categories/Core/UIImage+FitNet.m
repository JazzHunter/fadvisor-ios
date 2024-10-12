//
//  FitNet.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/25.
//

#import "UIImage+FitNet.h"
#import <AFNetworking.h>
#import "UIImageView+YYWebImage.h"
#import "YYWebImageOperation.h"
#import "_YYWebImageSetter.h"
#import "YYKitMacro.h"
#import <objc/runtime.h>
#import "CacheKey.h"

static int _YYWebImageSetterKey;

@implementation UIImage (FitNet)

+ (void)loadImageWithURL:(NSURL *)imageURL
              transform:(YYWebImageTransformBlock)transform
             completion:(YYWebImageCompletionBlock)completion {
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
//    if (!placeholder) placeholder = [UIImage imageNamed:@"placeholder_img"];
    
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    
    _YYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    if (!setter) {
        setter = [_YYWebImageSetter new];
        objc_setAssociatedObject(self, &_YYWebImageSetterKey, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    dispatch_async_on_main_queue(^{
        if (!imageURL) {
            if(completion) completion(nil, imageURL, YYWebImageFromNone, YYWebImageStageCancelled, nil);
            return;
        }
        
        // get the image from memory as quickly as possible
        UIImage *imageFromMemory = nil;
        if (manager.cache) {
            imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:YYImageCacheTypeMemory];
        }
        if (imageFromMemory) {
            if(completion) completion(imageFromMemory, imageURL, YYWebImageFromMemoryCacheFast, YYWebImageStageFinished, nil);
        }
        
        //    AFNetworkReachabilityStatusUnknown          = -1,
        //    AFNetworkReachabilityStatusNotReachable     = 0,
        //    AFNetworkReachabilityStatusReachableViaWWAN = 1,
        //    AFNetworkReachabilityStatusReachableViaWiFi = 2,
        
        AFNetworkReachabilityManager *netMgr = [AFNetworkReachabilityManager sharedManager];
        
        BOOL forbidDownload = netMgr.isReachableViaWWAN && ![[NSUserDefaults standardUserDefaults] boolForKey:DownloadImageViaWWAN];
        BOOL networkUnavailable = !netMgr.isReachable;
        if (forbidDownload || networkUnavailable) {
            if(completion) completion(nil, imageURL, YYWebImageFromMemoryCacheFast, YYWebImageStageFinished, nil);
        }
        
        __weak typeof(self) _self = self;
        dispatch_async([_YYWebImageSetter setterQueue], ^{
            __block int32_t newSentinel = 0;
            __block __weak typeof(setter) weakSetter = nil;
            YYWebImageCompletionBlock _completion = ^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                __strong typeof(_self) self = _self;
                BOOL setImage = (stage == YYWebImageStageFinished || stage == YYWebImageStageProgress) && image;
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (completion) {
                        if (sentinelChanged) {
                            completion(nil, url, YYWebImageFromNone, YYWebImageStageCancelled, nil);
                        } else {
                            completion(image, url, from, stage, error);
                        }
                    }
                });
            };
            
            newSentinel = [setter setOperationWithSentinel:sentinel url:imageURL options:kNilOptions manager:manager progress:nil transform:transform completion:_completion];
            weakSetter = setter;
        });
    });
}

@end
