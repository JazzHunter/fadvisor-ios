//
//  ImageTextButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/21.
//

#import "ImageTextButton.h"

@implementation ImageTextButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.imageSize = frame.size;
    }
    return self;
}

- (void)setupUI
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
//    CGRect rect = [super imageRectForContentRect:contentRect];
//    rect.origin.x = (CGRectGetWidth(contentRect)  - CGRectGetWidth(rect)) / 2.0;
//    rect.origin.y = CGRectGetHeight(contentRect) * 0.2;
//
//    return rect;
    
    if (CGSizeEqualToSize(self.imageSize, CGSizeZero)) {
        return [super imageRectForContentRect:contentRect];
    }

    CGSize size = self.imageSize;

    CGFloat x = (contentRect.size.width - size.width) / 2;
    CGFloat y = (contentRect.size.height) * 0.1;
    
    return CGRectMake(x, y, size.width, size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect = [super titleRectForContentRect:contentRect];
    //设置为0里要设置button的titleLabel.textAlignment为NSTextAlignmentCenter
    rect.origin.x = 0;
    rect.origin.y = CGRectGetMaxY([self imageRectForContentRect:contentRect]) + 5;
    rect.size.width = CGRectGetWidth(contentRect);

    return rect;
}

@end
