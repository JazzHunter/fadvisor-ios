//
//  Theme.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/24.
//

#import "Theme.h"

@interface ColorReader : NSObject

@property (nonatomic, copy) NSDictionary *lightColorMap;
@property (nonatomic, copy) NSDictionary *darkColorMap;


@end

@implementation ColorReader

- (instancetype)initWithModule:(NSString *)module {
    self = [super init];
    if (self) {
        
        NSString *bundlePath = [NSBundle.mainBundle.resourcePath stringByAppendingPathComponent:[module stringByAppendingString:@".bundle"]];
        
        NSString *darkPath = [bundlePath stringByAppendingString:@"/Theme/DarkMode/color.plist"];
        _darkColorMap = [NSDictionary dictionaryWithContentsOfFile:darkPath];
        
        NSString *lightPath = [bundlePath stringByAppendingString:@"/Theme/LightMode/color.plist"];
        _lightColorMap = [NSDictionary dictionaryWithContentsOfFile:lightPath];
        
    }
    return self;
}

- (UIColor *)colorNamed:(NSString *)name lightMode:(BOOL)lightMode {
    return lightMode ? [UIColor colorFromHexString:[self.lightColorMap objectForKey:name]] : [UIColor colorWithHexString:[self.darkColorMap objectForKey:name]];
}

@end

@interface Theme ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, ColorReader *> *moduleColorMap;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSBundle *> *moduleImageBundleMap;

@property (nonatomic, assign) ThemeMode currentMode;

// App是否支持自动模式
// YES时，支持ThemeModeAuto，切换模式时实时生效
// NO时，ThemeModeAuto与Light一致，切换模式时必须重启APP生效，
// iOS13及以上以上默认为YES，其他默认为NO。当你APP不支持多种主题模式时（即使是iOS13及以上），建议设置为NO，并选择Light或Dark作为你的界面UI样式
@property (nonatomic, assign) BOOL supportsAutoMode;

@property (nonatomic, strong, readonly, class) Theme *currentTheme;


@end

@implementation Theme

- (instancetype)init {
    self = [super init];
    if (self) {
        self.moduleColorMap = [NSMutableDictionary dictionary];
        self.moduleImageBundleMap = [NSMutableDictionary dictionary];
        if (@available(iOS 13.0, *)) {
            _supportsAutoMode = YES;
            self.currentMode = ThemeModeLight;
        }
        else {
            _supportsAutoMode = NO;
            self.currentMode = ThemeModeLight;
        }
    }
    return self;
}

- (void)setSupportsAutoMode:(BOOL)supportsAutoMode {
    if (@available(iOS 13.0, *)) {
        _supportsAutoMode = supportsAutoMode;
    }
    else {
        _supportsAutoMode = NO;
    }
}

#pragma mark - Color

- (ColorReader *)addColorModule:(NSString *)module {
    if (module.length == 0) {
        return nil;
    }
    ColorReader *colorReader = [self.moduleColorMap objectForKey:module];
    if (colorReader) {
        return colorReader;
    }
    colorReader = [[ColorReader alloc] initWithModule:module];
    [self.moduleColorMap setObject:colorReader forKey:module];
    return colorReader;
}

- (UIColor *)colorNamed:(NSString *)name opacity:(CGFloat)opacity module:(NSString *)module {
    if (name.length == 0) {
        return nil;
    }
    ColorReader *colorReader = [self addColorModule:module];
    UIColor *lightColor = [colorReader colorNamed:name lightMode:YES];
    UIColor *darkColor = [colorReader colorNamed:name lightMode:NO];
    if (opacity >= 0) {
        lightColor = [lightColor colorWithAlphaComponent:opacity];
        darkColor = [darkColor colorWithAlphaComponent:opacity];
    }
    
    if (self.supportsAutoMode) {
        NSAssert(darkColor, @"In auto mode, darkColor(name:%@) can't be nil", name);
        NSAssert(lightColor, @"In auto mode, lightColor(name:%@) can't be nil", name);
        return [UIColor getColorWithLightColor:lightColor darkColor:darkColor];
    }
    
    if (self.currentMode == ThemeModeDark) {
        NSAssert(darkColor, @"In dark mode, darkColor(name:%@) can't be nil", name);
        return darkColor;
    }

    NSAssert(lightColor, @"In light mode, lightColor(name:%@) can't be nil", name);
    return lightColor;
}

- (UIColor *)colorNamed:(NSString *)name module:(NSString *)module {
    return [self colorNamed:name opacity:-1.0 module:module];
}


#pragma mark - Global Methods

+ (Theme *)currentTheme {
    static Theme *_global = nil;
    if (!_global) {
        _global = [Theme new];
    }

    return _global;
}

+ (void)setCurrentMode:(ThemeMode)themeMode {
    [Theme.currentTheme setCurrentMode:themeMode];
    if (Theme.currentTheme.supportsAutoMode) {
        [self updateRootViewInterfaceStyle:[UIApplication sharedApplication].delegate.window];
    }
}

+ (ThemeMode)currentMode {
    return Theme.currentTheme.currentMode;
}

+ (void)setSupportsAutoMode:(BOOL)supportsAutoMode {
    [Theme.currentTheme setSupportsAutoMode:supportsAutoMode];
}

+ (BOOL)supportsAutoMode {
    return Theme.currentTheme.supportsAutoMode;
}

+ (UIColor *)colorWithNamed:(NSString *)named withModule:(NSString *)module {
    return [Theme.currentTheme colorNamed:named module:module];
}

+ (UIColor *)colorWithNamed:(NSString *)named withOpacity:(CGFloat)opacity withModule:(NSString *)module {
    return [Theme.currentTheme colorNamed:named opacity:opacity module:module];
}

+ (void)updateRootViewInterfaceStyle:(UIView *)view {
    if (Theme.currentMode == ThemeModeDark) {
        if (@available(iOS 13.0, *)) {
            view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        }
        return;
    }
    
    if (Theme.currentMode == ThemeModeLight) {
        if (@available(iOS 13.0, *)) {
            view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
        return;
    }
    
    if (@available(iOS 13.0, *)) {
        view.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
    }
}

@end
