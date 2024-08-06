//
//  RichTextView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/3.
//

#import "RichTextView.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "WebContentFileManager.h"

@interface RichTextView ()<WKUIDelegate, WKNavigationDelegate, GKPhotoBrowserDelegate>

/** 图片地址数组 */
@property (nonatomic, strong) NSArray *imgUrls;

/** 图片位置数组 */
@property (nonatomic, strong) NSArray *imgFrames;

/** 图片mask UI */
@property (nonatomic, strong) UIView *imgMaskView;

/** 当前View 的 Offset，会参与计算图片的回归位置 */
@property (nonatomic, assign) CGFloat offsetY;

@end

static NSString *const ScriptName_clickImage = @"clickImage";
static NSString *const ScriptName_loadImage = @"loadImage";
static NSString *const ScriptName_loadGifImage = @"loadGifImage";

@implementation RichTextView

- (instancetype)initWithFrame:(CGRect)frame {
    WKWebViewConfiguration *wkWebViewConfig = [[WKWebViewConfiguration alloc] init];
    wkWebViewConfig.preferences = [[WKPreferences alloc] init]; // 设置偏好设置
    wkWebViewConfig.preferences.javaScriptEnabled = YES; // 默认认为YES
    wkWebViewConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO; // 在iOS上默认为NO，表示不能自动通过窗口打开
    self = [super initWithFrame:frame configuration:wkWebViewConfig];
    if (self) {
        //WKWebView对象直接设置背景色后，上面依然有白色的背景，需要设置参数opaque=NO即可
        //https://www.jianshu.com/p/941c5bd97152
        self.opaque = NO;

        self.navigationDelegate = self;
        self.scrollView.bouncesZoom = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.directionalLockEnabled = YES;
        self.scrollView.scrollEnabled = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];

        [WebContentFileManager initData];
    }
    return self;
}

#pragma mark - 处理HTML

- (void)handleHTML:(NSString *)contentHTMLString {
    if (!contentHTMLString) return;

    Weak(self);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Strong(weakself);
        if (!strongSelf) return;

        NSString *contentZoom = @"1";
        NSString *frame = [NSString stringWithFormat:@"\
                           <html class=\"%@\">\
                           <head>\
                           <meta http-equiv =\"Content-Type\" content=\"text/html; charset=utf-8\"/>\
                           <meta name = \"viewport\" content=\"width = device-width, initial-scale = 1, user-scalable=no\"/>\
                           <title></title>\
                           <link href=\"./static/css/WebContentStyle.css\" rel=\"stylesheet\" type=\"text/css\"/>\
                           </head>\
                           <body style=\"zoom:%@; margin: 0px;\">\
                           <div class=\"content\">%@</div>\
                           </body>\
                           </html>", @"night-theme", contentZoom, contentHTMLString];

        NSString *htmlPath = [[WebContentFileManager getCachePath] stringByAppendingPathComponent:@"richContent.html"];
        NSURL *htmlUrl = [NSURL fileURLWithPath:htmlPath];
        NSError *error = nil;
        [frame writeToURL:htmlUrl atomically:YES encoding:NSUTF8StringEncoding error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) [strongSelf loadRequest:[NSURLRequest requestWithURL:htmlUrl]];
        });
    });
}

#pragma mark - GKPhotoBrowserDelegate
- (void)photoBrowser:(GKPhotoBrowser *)browser panBeginWithIndex:(NSInteger)index {
    // 执行js，隐藏对应的图片
    [self addViewToImageWithIndex:index hidden:NO];
}

- (void)photoBrowser:(GKPhotoBrowser *)browser panEndedWithIndex:(NSInteger)index willDisappear:(BOOL)disappear {
    // 执行js，显示对应的图片
    [self addViewToImageWithIndex:index hidden:YES];
}

- (void)addViewToImageWithIndex:(NSInteger)index hidden:(BOOL)hidden {
    if (hidden) {
        [self.imgMaskView removeFromSuperview];
        self.imgMaskView = nil;
    } else {
        CGRect frame = CGRectFromString(self.imgFrames[index]);
        self.imgMaskView = [[UIView alloc] initWithFrame:frame];
        self.imgMaskView.backgroundColor = [UIColor backgroundColor];
        [self addSubview:self.imgMaskView];
    }
}

#pragma mark - 打开图片浏览

- (void)getImgsJSToWebView:(WKWebView *)webView {
    // 获取图片地址
    NSString *getImgUrlsJS = @"\
    function getImgUrls() {\
    var imgs = document.getElementsByTagName('img');\
    var urls = [];\
    for (var i = 0; i < imgs.length; i++) {\
    var img = imgs[i];\
    urls[i] = img.src;\
    }\
    return urls;\
    }";

    [webView evaluateJavaScript:getImgUrlsJS completionHandler:nil];

    [webView evaluateJavaScript:@"getImgUrls()" completionHandler:^(id _Nullable obj, NSError *_Nullable error) {
        self.imgUrls = obj;
    }];

    // 获取图片frame
    NSString *getImgFramesJS = @"\
    function getImgFrames() {\
    var imgs = document.getElementsByTagName('img');\
    var frames = [];\
    for (var i = 0; i < imgs.length; i++) {\
    var img = imgs[i];\
    var imgX = img.offsetLeft;\
    var imgY = img.offsetTop;\
    var imgW = img.offsetWidth;\
    var imgH = img.offsetHeight;\
    frames[i] = {'x': imgX, 'y': imgY, 'w': imgW, 'h': imgH};\
    }\
    return frames;\
    }";

    [webView evaluateJavaScript:getImgFramesJS completionHandler:nil];

    [webView evaluateJavaScript:@"getImgFrames()" completionHandler:^(id _Nullable obj, NSError *_Nullable error) {
        NSArray *frames = (NSArray *)obj;

        NSMutableArray *imgFrames = [NSMutableArray new];

        for (NSDictionary *dic in frames) {
            CGRect rect = CGRectMake([dic[@"x"] floatValue],
                                     [dic[@"y"] floatValue],
                                     [dic[@"w"] floatValue],
                                     [dic[@"h"] floatValue]);

            [imgFrames addObject:NSStringFromCGRect(rect)];
        }
        self.imgFrames = imgFrames;
    }];
}

// 给网页中的图片添加点击方法
- (void)addImgClick {
    NSString *imgClickJS = @"function imgClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0; i < length;i++){img=imgs[i];if(\"ad\" ==img.getAttribute(\"flag\")){var parent = this.parentNode;if(parent.nodeName.toLowerCase() != \"a\")return;}img.onclick=function(){window.location.href='image-preview:'+this.src}}}";
    [self evaluateJavaScript:imgClickJS completionHandler:nil];

    [self evaluateJavaScript:@"imgClickAction()" completionHandler:nil];
}

- (void)showImageWithArray:(NSArray *)imageUrls index:(NSInteger)index {
    NSMutableArray *photos = [NSMutableArray new];

    [imageUrls enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:obj];

        if (index == idx) {
            CGRect rect = CGRectFromString(self.imgFrames[idx]);
            rect.origin.y += self.offsetY;
            photo.sourceFrame = rect;
        }

        photo.placeholderImage = [UIImage imageNamed:@"placeholder_img_long"];

        [photos addObject:photo];
    }];

    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    browser.showStyle = GKPhotoBrowserShowStyleZoom;        // 缩放显示
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;   // 缩放隐藏
    browser.loadStyle = GKPhotoBrowserLoadStyleIndeterminateMask; // 不明确的加载方式带阴影
    browser.maxZoomScale = 20.0f;
    browser.doubleZoomScale = 2.0f;
    browser.isAdaptiveSafeArea = YES;
    browser.hidesCountLabel = NO;
//        browser.hidesPageControl = YES;
    browser.hidesSavedBtn = NO;
    browser.isFullWidthForLandScape = YES;
    browser.isSingleTapDisabled = NO;
    browser.isStatusBarShow = YES;      // 显示状态栏
    if (kIsiPad) {
        browser.isFollowSystemRotation = YES;
    }
    browser.delegate = self;
    [browser showFromVC:self.viewController];
}

#pragma mark - 更新高度

- (void)updateHeight {
    // 获取内容高度
    NSString *getContentHeightJS = @"\
    function getBodyHeight() {\
    return document.getElementsByTagName('body')[0].offsetHeight;\
    }";
    [self evaluateJavaScript:getContentHeightJS completionHandler:nil];

    Weak(self);
    [self evaluateJavaScript:@"getBodyHeight();" completionHandler:^(id _Nullable response, NSError *_Nullable error) {
        if (!error) {
            CGFloat height = [response floatValue];
            !weakself.loadedFinishBlock ? : weakself.loadedFinishBlock(height);
        }
    }];
}

#pragma mark - WKNavigationDelegate

// 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接单独处理。但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;

    if ([url hasPrefix:@"image-preview:"]) {
        NSString *imgUrl = [url substringFromIndex:14];
        NSInteger index = [self.imgUrls indexOfObject:imgUrl];
        if (index >= 0 && index < self.imgUrls.count) {
            [self showImageWithArray:self.imgUrls index:index];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 当main frame导航完成时，会回调
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self updateHeight];
    [self getImgsJSToWebView:webView];
    [self addImgClick];
}

- (void)offsetY:(CGFloat)offsetY {
    self.offsetY = offsetY;
}

@end
