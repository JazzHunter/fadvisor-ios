//
//  AuthorAvatarWithWrapper.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import "AuthorAvatarWithWrapper.h"

@interface AuthorAvatarWithWrapper ()

@property (nonatomic, strong) YYAnimatedImageView *avatarImage;

@end

@implementation AuthorAvatarWithWrapper

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, AuthorAvatarWithWrapperWidth, AuthorAvatarWithWrapperWidth)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.width / 2;
        [self xy_setLayerBorderColor:[UIColor borderColor]];
        self.layer.borderWidth = 1;

        NSUInteger padding = frame.size.width / 20;
        self.avatarImage = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(padding, padding, frame.size.width - 2 * padding, frame.size.height - 2 * padding)];
        self.avatarImage.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImage.layer.masksToBounds = YES;
        [self.avatarImage setCornerRadius:self.avatarImage.width / 2];
        [self addSubview:self.avatarImage];
    }
    return self;
}

- (void)setAvatarUrl:(NSURL *)url {
    if (!url || url.absoluteString.length == 0) {
        [self.avatarImage setImage:[UIImage imageNamed:@"default_author_avatar"]];
    } else {
        [self.avatarImage setImageWithURL:url];
    }
}

@end
