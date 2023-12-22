//
//  RichTextView.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/3.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebContentFileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface RichTextView : WKWebView

/** 加载完成Block */
@property (nonatomic, copy) void (^ loadedFinishBlock)(CGFloat);

- (void)offsetY:(CGFloat)offsetY;

- (void)handleHTML:(NSString *)htmlString;

@end

NS_ASSUME_NONNULL_END
