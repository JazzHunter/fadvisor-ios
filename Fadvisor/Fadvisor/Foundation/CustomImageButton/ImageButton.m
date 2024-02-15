//
//  ImageButton.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/21.
//

#import "ImageButton.h"
@interface ImageButton ()


@end

@implementation ImageButton

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageSize = frame.size;
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (CGSizeEqualToSize(self.imageSize, CGSizeZero)) {
        return [super imageRectForContentRect:contentRect];
    }

    CGSize size = self.imageSize;

    CGFloat x = (contentRect.size.width - size.width) / 2;
    CGFloat y = (contentRect.size.height - size.height) / 2;

    return CGRectMake(x, y, size.width, size.height);
}

- (void)enableTouchDownAnimation {
    [self addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
}

- (void)handleTouchDown:(UIButton *)sender {
    self.transform = CGAffineTransformIdentity;

    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }];

        [UIView addKeyframeWithRelativeStartTime:1 / 3.0 relativeDuration:1 / 3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];

        [UIView addKeyframeWithRelativeStartTime:2 / 3.0 relativeDuration:1 / 3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

@end
