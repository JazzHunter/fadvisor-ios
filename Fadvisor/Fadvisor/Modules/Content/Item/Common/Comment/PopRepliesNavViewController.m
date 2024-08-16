//
//  PopReplies.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/5.
//

#import "PopRepliesNavViewController.h"
#import "PopRepliesViewController.h"
#import <HWPanModal/HWPanModal.h>

@interface PopRepliesNavViewController ()<HWPanModalPresentable>

@property (nonatomic, strong) CommentModel *masterCommentModel;

@end

@implementation PopRepliesNavViewController

- (instancetype)initWithMasterComment:(CommentModel *)model {
    self = [super init];
    if (self) {
        self.masterCommentModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    PopRepliesViewController *repliesVC = [[PopRepliesViewController alloc] init];
    [repliesVC resetWithMasterComment:self.masterCommentModel];
    self.viewControllers = @[repliesVC];
}

#pragma mark - overridden to update panModal

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *controller = [super popViewControllerAnimated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return controller;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *viewControllers = [super popToViewController:viewController animated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return viewControllers;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray<__kindof UIViewController *> *viewControllers = [super popToRootViewControllerAnimated:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
    return viewControllers;
}

#pragma mark - HWPanModalPresentable

- (UIScrollView *)panScrollable {
    UIViewController *VC = self.topViewController;
    if ([VC conformsToProtocol:@protocol(HWPanModalPresentable)]) {
        id<HWPanModalPresentable> obj = VC;
        return [obj panScrollable];
    }
    return nil;
}

- (CGFloat)topOffset {
    return 0;
}

- (PanModalHeight)longFormHeight {
    // we will let child vc to config panModal
    UIViewController *VC = self.topViewController;
    if ([VC conformsToProtocol:@protocol(HWPanModalPresentable)]) {
        id<HWPanModalPresentable> obj = VC;
        return [obj longFormHeight];
    }
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, [UIApplication sharedApplication].statusBarFrame.size.height + 20);
}

- (BOOL)allowScreenEdgeInteractive {
    return YES;
}

- (BOOL)showDragIndicator {
    return NO;
}

// let the navigation stack top VC handle it.
- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIViewController *VC = self.topViewController;
    if ([VC conformsToProtocol:@protocol(HWPanModalPresentable)]) {
        id<HWPanModalPresentable> obj = VC;
        return [obj shouldRespondToPanModalGestureRecognizer:panGestureRecognizer];
    }
    return YES;
}

@end
