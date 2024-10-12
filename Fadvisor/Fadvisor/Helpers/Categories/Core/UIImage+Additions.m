//
//  1231231231.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/15.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (UIImage *)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

@end
