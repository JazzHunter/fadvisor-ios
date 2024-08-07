//
//  AuthorSectionAuthorsPanModalView.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/7.
//

#import "AuthorSectionAuthorsPanModalView.h"

@interface AuthorSectionAuthorsPanModalView()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation AuthorSectionAuthorsPanModalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.scrollView = [UIScrollView new];
        self.scrollView.backgroundColor = [UIColor yellowColor];

        [self addSubview:self.scrollView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

#pragma mark - HWPanModalPresentable

- (PanModalHeight)shortFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 100);
}

- (PanModalHeight)mediumFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, 500);
}



- (CGFloat)topOffset {
    return [UIApplication sharedApplication].keyWindow.rootViewController.topLayoutGuide.length + 21;
}

- (BOOL)shouldRoundTopCorners {
    return YES;
}

//- (UIViewAnimationOptions)transitionAnimationOptions {
//    return UIViewAnimationOptionCurveLinear;
//}

- (PresentationState)originPresentationState {
    return PresentationStateMedium;
}

- (CGFloat)springDamping {
    return 0.618;
}

- (UIScrollView *)panScrollable {
    return self.scrollView;
}

- (HWPanModalShadow *)contentShadow {
    return [[HWPanModalShadow alloc] initWithColor:[UIColor systemPinkColor] shadowRadius:10 shadowOffset:CGSizeMake(1, 1) shadowOpacity:1];
}

//- (BOOL)allowsTouchEventsPassingThroughTransitionView {
//    return YES;
//}

- (HWBackgroundConfig *)backgroundConfig {
    return [HWBackgroundConfig configWithBehavior:HWBackgroundBehaviorSystemVisualEffect];
}

@end
