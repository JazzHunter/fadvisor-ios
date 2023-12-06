//
//  Macro.h
//  FadvisorBaseUI
//
//  Created by 韩建伟 on 2021/3/17.
//

#ifndef Macro_h
#define Macro_h

//#define kStatusBarHeight                  [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height

// 状态栏高度
#define kStatusBarHeight \
({\
    CGFloat height = 0.0;\
    if (@available(iOS 11.0, *)) {\
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;\
        height = insets.top;\
    } else {\
        height = 20.0;\
    }\
    height;\
})


#define kDefaultNavBarHeight              \
({\
    CGFloat height = 44.0;\
    if (@available(iOS 11.0, *)) {\
        UIEdgeInsets insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;\
        height = insets.top  + 44.0;\
    } else {\
        height = 20.0 + 44.0;\
    }\
    height;\
})

#define kBottomBarHeight                  49
#define kAPPDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define kIsiPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

/// iPhoneX  iPhoneXS  iPhoneXS Max  iPhoneXR 机型判断
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)

#define mainNavigationController          [UIApplication sharedApplication].keyWindow.rootViewController

//是否是空对象
#define IsEmpty(_object) (_object == nil \
                          || [_object isKindOfClass:[NSNull class]] \
                          || ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
                          || ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#define Weak(type)       __weak typeof(type) weak ## type = type
#define Strong(type)     __strong typeof(&*self) strongSelf = type

#define WeakSelf                          __weak __typeof(&*self) wSelf = self;
#define StrongSelf                        __strong __typeof(&*self) sSelf = wSelf;

#define ItemMarginVertical                16 // cell 上下留白
#define ItemMarginHorizon                 18 // cell 左右留白
#define SectionMarginVertical             12 //Section之间的纵向间隔

#define ItemTitleFontSize                 16
#define ItemIntroductionFontSize          14
#define ItemMetaFontSize                  12
#define NightTheme                        @"NightTheme"


#endif /* Macro_h */
