//
//  Theme.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define GetColor(key, module)  [Theme colorWithNamed:(key) withModule:(module)]

typedef NS_ENUM(NSUInteger, ThemeMode) {
    ThemeModeAuto,  //supportsAutoMode为NO时，与Light一致
    ThemeModeLight,
    ThemeModeDark,
};

@interface Theme : NSObject

@property (nonatomic, assign, class) ThemeMode currentMode;

// App是否支持自动模式
// YES时，支持ThemeModeAuto，切换模式时实时生效
// NO时，ThemeModeAuto与Light一致，切换模式时必须重启APP生效，
// iOS13及以上以上默认为YES，其他默认为NO。当你APP不支持多种主题模式时（即使是iOS13及以上），建议设置为NO，并选择Light或Dark作为你的界面UI样式
@property (nonatomic, assign, class) BOOL supportsAutoMode;

+ (UIColor *)colorWithNamed:(NSString *)named withModule:(NSString *)moduleNamed;
+ (UIColor *)colorWithNamed:(NSString *)named withOpacity:(CGFloat)opacity withModule:(NSString *)moduleNamed;

+ (void)updateRootViewInterfaceStyle:(UIView *)view;

@end
NS_ASSUME_NONNULL_END
