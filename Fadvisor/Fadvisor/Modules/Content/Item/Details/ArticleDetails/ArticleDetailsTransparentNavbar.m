//
//  ArticleDetailsTransparentNavbar.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/14.
//

#import "ArticleDetailsTransparentNavbar.h"
#import "ImageButton.h"

@interface ArticleDetailsTransparentNavbar ()

@property (nonatomic, strong) ImageButton *backButton;

@end

@implementation ArticleDetailsTransparentNavbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.myHorzMargin = 0;
    self.myHeight = kDefaultNavBarHeight;
    self.paddingTop = kStatusBarHeight;
    self.paddingLeft = self.paddingRight = 8;

    self.backButton = [[ImageButton alloc] initWithFrame:CGRectMake(0, 0, kButtonStandardSize, kButtonStandardSize)];
    [self.backButton setImage:[[[UIImage imageNamed:@"ic_left_arr"] imageWithTintColor:[UIColor whiteColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.backButton.layer.masksToBounds = YES;
    self.backButton.layer.cornerRadius = kButtonStandardSize / 2;
    
    self.backButton.leftPos.equalTo(self.leftPos);
    self.backButton.centerYPos.equalTo(self.centerYPos);
    [self addSubview:self.backButton];
    
    [self.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backButtonTapped:(UIView *)sender {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

@end
