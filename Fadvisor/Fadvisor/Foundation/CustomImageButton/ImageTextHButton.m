//
//  ImageTextHButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/29.
//

#import "ImageTextHButton.h"

@implementation ImageTextHButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.imageSize = frame.size;
        self.spacing = 5;
    }
    return self;
}

- (void)setupUI
{
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    if (CGSizeEqualToSize(self.imageSize, CGSizeZero)) {
        return [super imageRectForContentRect:contentRect];
    }

    CGSize size = self.imageSize;
    
    CGFloat x = 0;
    CGFloat y = (contentRect.size.height - size.height) / 2;
    
    return CGRectMake(x, y, size.width, size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super titleRectForContentRect:contentRect];
    
    rect.origin.x = CGRectGetMaxX([self imageRectForContentRect:contentRect])  + _spacing;
    
    rect.origin.y = 0;
    
    rect.size.height = CGRectGetHeight(contentRect);
    
    rect.size.width = CGRectGetWidth(contentRect) - CGRectGetMaxX([self imageRectForContentRect:contentRect]) - _spacing;
    
    return rect;
}


@end
