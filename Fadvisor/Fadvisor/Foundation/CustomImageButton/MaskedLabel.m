//
//  TestButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/20.
//

#import "MaskedLabel.h"

@implementation MaskedLabel
{
    UIColor *_maskedBackgroundColor;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _maskedBackgroundColor = [super backgroundColor];
        [super setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (UIColor *)backgroundColor
{
    return _maskedBackgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _maskedBackgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
}

- (void)drawRect:(CGRect)rect {
    // Render into a temporary bitmap context at a max of 8 bits per component for subsequent CGImageMaskCreate operations
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);

    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef image = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();

    // Revert to normal graphics context for the rest of the rendering
    context = UIGraphicsGetCurrentContext();

    CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, CGRectGetHeight(rect)));

    // create a mask from the normally rendered text
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(image), CGImageGetHeight(image), CGImageGetBitsPerComponent(image), CGImageGetBitsPerPixel(image), CGImageGetBytesPerRow(image), CGImageGetDataProvider(image), CGImageGetDecode(image), CGImageGetShouldInterpolate(image));

    CFRelease(image); image = NULL;

    // wipe the slate clean
    CGContextClearRect(context, rect);

    CGContextSaveGState(context);
    CGContextClipToMask(context, rect, mask);

    if (self.layer.cornerRadius != 0.0f) {
        CGPathRef path = CGPathCreateWithRoundedRect(rect, self.layer.cornerRadius, self.layer.cornerRadius, nil);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }

    CFRelease(mask); mask = NULL;

    [self drawBackgroundInRect:rect];

    CGContextRestoreGState(context);
}

- (void)drawBackgroundInRect:(CGRect)rect
{
    // this is where you do whatever fancy drawing you want to do!
    CGContextRef context = UIGraphicsGetCurrentContext();

    [_maskedBackgroundColor set];
    CGContextFillRect(context, rect);
}

@end
