//
//  UIImageView+FitNet.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/22.
//

#import "UIImageView+FitNet.h"
#import <AFNetworking.h>
#import "UIImageView+YYWebImage.h"
#import "YYWebImageOperation.h"
#import "_YYWebImageSetter.h"
#import "YYKitMacro.h"
#import <objc/runtime.h>

static int _YYWebImageSetterKey;

@implementation UIImageView (FitNet)

- (void)setImageWithURL:(NSURL *)imageURL {
    [self setImageWithURL:imageURL
              placeholder:nil
                  options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                 progress:nil
                transform:nil
               completion:nil];
}

- (void)setImageWithURL:(NSURL *)imageURL
              transform:(YYWebImageTransformBlock)transform {
    [self setImageWithURL:imageURL
              placeholder:nil
                  options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                 progress:nil
                transform:transform
               completion:nil];
}


- (void)setImageWithURL:(NSURL *)imageURL
            placeholder:(UIImage *)placeholder
                options:(YYWebImageOptions)options
               progress:(YYWebImageProgressBlock)progress
              transform:(YYWebImageTransformBlock)transform
             completion:(YYWebImageCompletionBlock)completion {
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    if (!placeholder) placeholder = [UIImage imageNamed:@"placeholder_img"];
    
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    
    _YYWebImageSetter *setter = objc_getAssociatedObject(self, &_YYWebImageSetterKey);
    if (!setter) {
        setter = [_YYWebImageSetter new];
        objc_setAssociatedObject(self, &_YYWebImageSetterKey, setter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    int32_t sentinel = [setter cancelWithNewURL:imageURL];
    
    dispatch_async_on_main_queue(^{
        if ((options & YYWebImageOptionSetImageWithFadeAnimation) &&
            !(options & YYWebImageOptionAvoidSetImage)) {
            if (!self.highlighted) {
                [self.layer removeAnimationForKey:_YYWebImageFadeAnimationKey];
            }
        }
        
        if (!imageURL) {
            if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
                self.image = placeholder;
            }
            return;
        }
        
        // get the image from memory as quickly as possible
        UIImage *imageFromMemory = nil;
        if (manager.cache &&
            !(options & YYWebImageOptionUseNSURLCache) &&
            !(options & YYWebImageOptionRefreshImageCache)) {
            imageFromMemory = [manager.cache getImageForKey:[manager cacheKeyForURL:imageURL] withType:YYImageCacheTypeMemory];
        }
        if (imageFromMemory) {
            if (!(options & YYWebImageOptionAvoidSetImage)) {
                self.image = imageFromMemory;
            }
            if(completion) completion(imageFromMemory, imageURL, YYWebImageFromMemoryCacheFast, YYWebImageStageFinished, nil);
            return;
        }
        
        //    AFNetworkReachabilityStatusUnknown          = -1,
        //    AFNetworkReachabilityStatusNotReachable     = 0,
        //    AFNetworkReachabilityStatusReachableViaWWAN = 1,
        //    AFNetworkReachabilityStatusReachableViaWiFi = 2,
        
        AFNetworkReachabilityManager *netMgr = [AFNetworkReachabilityManager sharedManager];
        
        BOOL forbidDownload = netMgr.isReachableViaWWAN && ![[NSUserDefaults standardUserDefaults] boolForKey:DownloadImageViaWWAN];
        BOOL networkUnavailable = !netMgr.isReachable;
        if (forbidDownload || networkUnavailable) {
            self.image = placeholder;
            if(completion) completion(placeholder, imageURL, YYWebImageFromMemoryCacheFast, YYWebImageStageFinished, nil);
            return;
        }
        
        if (!(options & YYWebImageOptionIgnorePlaceHolder)) {
            self.image = placeholder;
        }
        
        __weak typeof(self) _self = self;
        dispatch_async([_YYWebImageSetter setterQueue], ^{
            YYWebImageProgressBlock _progress = nil;
            if (progress) _progress = ^(NSInteger receivedSize, NSInteger expectedSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(receivedSize, expectedSize);
                });
            };
            
            __block int32_t newSentinel = 0;
            __block __weak typeof(setter) weakSetter = nil;
            YYWebImageCompletionBlock _completion = ^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                __strong typeof(_self) self = _self;
                BOOL setImage = (stage == YYWebImageStageFinished || stage == YYWebImageStageProgress) && image && !(options & YYWebImageOptionAvoidSetImage);
                dispatch_async(dispatch_get_main_queue(), ^{
                    BOOL sentinelChanged = weakSetter && weakSetter.sentinel != newSentinel;
                    if (setImage && self && !sentinelChanged) {
                        BOOL showFade = ((options & YYWebImageOptionSetImageWithFadeAnimation) && !self.highlighted);
                        if (showFade) {
                            CATransition *transition = [CATransition animation];
                            transition.duration = stage == YYWebImageStageFinished ? _YYWebImageFadeTime : _YYWebImageProgressiveFadeTime;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionFade;
                            [self.layer addAnimation:transition forKey:_YYWebImageFadeAnimationKey];
                        }
                        self.image = image;
                    }
                    if (completion) {
                        if (sentinelChanged) {
                            completion(nil, url, YYWebImageFromNone, YYWebImageStageCancelled, nil);
                        } else {
                            completion(image, url, from, stage, error);
                        }
                    }
                });
            };
            
            newSentinel = [setter setOperationWithSentinel:sentinel url:imageURL options:options manager:manager progress:_progress transform:transform completion:_completion];
            weakSetter = setter;
        });
    });
}

@end
