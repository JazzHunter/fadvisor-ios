//
//  UIColor+Additions.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2019/11/29.
//  Copyright © 2019 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

#define MAIN_COLOR @"#CC4024"

// color from RGB or RGBA hex value starts with '#'
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if (![[hexString substringToIndex:1] isEqualToString:@"#"]) {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }

    if (hexString.length == 4) {
        NSString *str1 = [hexString substringWithRange:NSMakeRange(1, 1)];
        NSString *str2 = [hexString substringWithRange:NSMakeRange(2, 1)];
        NSString *str3 = [hexString substringWithRange:NSMakeRange(3, 1)];
        hexString = [NSString stringWithFormat:@"#%@%@%@%@%@%@", str1, str1, str2, str2, str3, str3];
    }
    if (hexString.length != 7 && hexString.length != 9) {
        return nil;
    }
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    scanner.scanLocation = 1;
    unsigned int hex;
    [scanner scanHexInt:&hex];
    if (hexString.length == 7) {
        unsigned int r = (hex & 0xFF0000) >> 16;
        unsigned int g = (hex & 0x00FF00) >> 8;
        unsigned int b = hex & 0x0000FF;
        return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
    } else {

        unsigned int r = (hex & 0xFF000000) >> 24;
        unsigned int g = (hex & 0x00FF0000) >> 16;
        unsigned int b = (hex & 0x0000FF00) >> 8;
        unsigned int a = hex & 0x000000FF;
        return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 255.0];
    }

    return nil;
}

+ (UIColor *)getColorWithLightColor:(UIColor *)lightColor
                          darkColor:(UIColor *_Nullable)darkColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor *_Nonnull (UITraitCollection *_Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark && [[NSUserDefaults standardUserDefaults] boolForKey:NightTheme]) {
                return darkColor;
            } else {
                return lightColor;
            }
        }];
    } else {
        return lightColor;
    }
}

+ (UIColor *)backgroundColorGray {
    return [UIColor getColorWithLightColor:[UIColor colorFromHexString:@"f5f5f5"]
                                 darkColor:[UIColor colorFromHexString:@"373737"]];
}

+ (UIColor *)backgroundColor {
    return [UIColor getColorWithLightColor:[UIColor whiteColor]
                                 darkColor:[UIColor colorFromHexString:@"3f3f3f"]];
}

+ (UIColor *)mainColor {
    return [UIColor colorFromHexString:MAIN_COLOR];
}

+ (UIColor *)lightMainColor {
    return [UIColor colorFromHexString:@"#f0c6bd"];
}

+ (UIColor *)backgroundMainColor {
    return [UIColor colorFromHexString:@"#faece9"];
}

+ (UIColor *)pwcRedColor {
    return [UIColor colorFromHexString:@"#E0301E"];
}

+ (UIColor *)pwcPinkColor {
    return [UIColor colorFromHexString:@"#D04A02"];
}

+ (UIColor *)pwcOrangeColor {
    return [UIColor colorFromHexString:@"#D93954"];
}

+ (UIColor *)RandomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

+ (UIColor *)titleTextColor {
    return [UIColor getColorWithLightColor:[UIColor colorFromHexString:@"333333"]
                                 darkColor:[UIColor colorFromHexString:@"cccccc"]];
}

+ (UIColor *)descriptionTextColor {
    return [UIColor colorFromHexString:@"8590a6"];
}

+ (UIColor *)metaTextColor {
    return [UIColor getColorWithLightColor:[UIColor colorFromHexString:@"999999"]
                                 darkColor:[UIColor colorFromHexString:@"a8a8a8"]];
}

+ (UIColor *)contentTextColor {
    return [UIColor getColorWithLightColor:[UIColor colorFromHexString:@"2f2f2f"]
                                 darkColor:[UIColor colorFromHexString:@"b1b1b1"]];
}

+ (UIColor *)borderColor {
    return [UIColor getColorWithLightColor:[UIColor colorFromHexString:@"EBEEF5"]
                                 darkColor:[UIColor colorFromHexString:@"2F2F2F"]];
}

+ (UIColor *)lightBorderColor {
    return [UIColor colorFromHexString:@"f0f0f0"];
}

+ (UIColor *)lightBackgroundColor {
    return [UIColor getColorWithLightColor:[UIColor colorFromHexString:@"f7f7f7"]
                                 darkColor:[UIColor colorFromHexString:@"474747"]];
}

static void RGBtoHSV(float r, float g, float b, float *h, float *s, float *v)
{
    float min, max, delta;
    min = MIN(r, MIN(g, b));
    max = MAX(r, MAX(g, b));
    *v = max;                                     // v
    delta = max - min;
    if (max != 0) *s = delta / max;               // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if (r == max) *h = (g - b) / delta;           // between yellow & magenta
    else if (g == max) *h = 2 + (b - r) / delta;  // between cyan & yellow
    else *h = 4 + (r - g) / delta;                // between magenta & cyan
    *h *= 60;                                     // degrees
    if (*h < 0) *h += 360;
}

+ (UIColor *)mostColor:(UIImage *)image {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif

    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
//    CGSize thumbSize=CGSizeMake(40, 40);
    CGSize thumbSize = CGSizeMake(40, 40);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width * 4,
                                                 colorSpace,
                                                 bitmapInfo);

    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);

    //第二步 取每个点的像素值
    unsigned char *data = CGBitmapContextGetData(context);

    if (data == NULL) return nil;
    NSArray *MaxColor = nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore = 0;
    for (int x = 0; x < thumbSize.width * thumbSize.height; x++) {
        int offset = 4 * x;
        int red = data[offset];
        int green = data[offset + 1];
        int blue = data[offset + 2];
        int alpha =  data[offset + 3];

        if (alpha < 25) continue;

        float h, s, v;

        RGBtoHSV(red, green, blue, &h, &s, &v);

        float y = MIN(abs(red * 2104 + green * 4130 + blue * 802 + 4096 + 131072) >> 13, 235);
        y = (y - 16) / (235 - 16);
        if (y > 0.9) continue;

        float score = (s + 0.1) * x;
        if (score > maxScore) {
            maxScore = score;
        }
        MaxColor = @[@(red), @(green), @(blue), @(alpha)];
    }

    CGContextRelease(context);
    return [UIColor colorWithRed:([MaxColor[0] intValue] / 255.0f) green:([MaxColor[1] intValue] / 255.0f) blue:([MaxColor[2] intValue] / 255.0f) alpha:([MaxColor[3] intValue] / 255.0f)];
}

@end
