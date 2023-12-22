//
//  WebContentFileManager.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/24.
//

#import "WebContentFileManager.h"

@implementation WebContentFileManager

+ (void)initData {
    // 获取资源文件
    NSBundle *contentFileBundle = [NSBundle bundleWithPath:[[[NSBundle resourceBundle] resourcePath] stringByAppendingPathComponent:@"ContentFils"]];

    // 获取临时缓存目录
    NSString *jqueryJSPath = [[WebContentFileManager getStaticCachePath:@"js"] stringByAppendingPathComponent:@"jquery.min.js"];

//    NSString *webContentHandleJSPath = [[WebContentFileManager getStaticCachePath:@"js"] stringByAppendingPathComponent:@"WebContentHandle.js"];

    NSString *webContentStyleCSSPath = [[WebContentFileManager getStaticCachePath:@"css"] stringByAppendingPathComponent:@"WebContentStyle.css"];

    // 写入临时缓存目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:jqueryJSPath]) {
        NSString *jqueryJS = [NSString stringWithContentsOfFile:[contentFileBundle pathForResource:@"jquery.min" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL]; //jqueryJS

        [jqueryJS writeToFile:jqueryJSPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }

//    if (![[NSFileManager defaultManager] fileExistsAtPath:webContentHandleJSPath]) {
//        NSString *webContentHandleJS = [NSString stringWithContentsOfFile:[contentFileBundle pathForResource:@"WebContentHandle" ofType:@"js"] encoding:NSUTF8StringEncoding error:NULL]; //web内容处理JS
//
//        [webContentHandleJS writeToFile:webContentHandleJSPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
//    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:webContentStyleCSSPath]) {
        NSString *webContentStyleCSS = [NSString stringWithContentsOfFile:[contentFileBundle pathForResource:@"WebContentStyle" ofType:@"css"] encoding:NSUTF8StringEncoding error:NULL];

        [webContentStyleCSS writeToFile:webContentStyleCSSPath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    }

    NSArray *imageArray = @[@"placeholder_img.png", @"placeholder_img_long.png"];

    for (NSString *imageName in imageArray) {
        NSString *imagePath = [[WebContentFileManager getStaticCachePath:@"img"] stringByAppendingPathComponent:imageName];

        if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
            [[NSData dataWithContentsOfURL:[[contentFileBundle bundleURL] URLByAppendingPathComponent:imageName]] writeToFile:imagePath atomically:YES];
        }
    }
}

#pragma mark - 获取缓存路径

+ (NSString *)getCachePath:(NSString *)folder {
    // 缓存目录结构: /tmp/WebContent/[folder]
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *filePath = [NSString stringWithFormat:@"%@%@/%@", NSTemporaryDirectory(), @"WebContent", folder ? folder : @""];

    // 判断该文件夹是否存在
    if (![fileManager fileExistsAtPath:filePath]) {
        // 不存在创建文件夹 创建文件夹
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

+ (NSString *)getCachePath {
    return [self getCachePath:nil];
}

+ (NSString *)getStaticCachePath:(NSString *)folder {
    return [self getCachePath:[NSString stringWithFormat:@"%@/%@", @"static", folder ? folder : @""]];
}

#pragma mark - 清理缓存

+ (void)clearCacheWithResultBlock:(void (^)(void))resultBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSFileManager *manager = [NSFileManager defaultManager];

        [manager removeItemAtPath:[self getCachePath] error:nil];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultBlock) resultBlock();
        });
    });
}

#pragma mark - 设置内容缩放
+ (NSInteger)contentZoom {
    return [[NSUserDefaults standardUserDefaults] integerForKey:ContentZoom];
}

+ (void)setContentZoom:(NSInteger)contentZoom {
    [[NSUserDefaults standardUserDefaults] setInteger:contentZoom forKey:ContentZoom];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
