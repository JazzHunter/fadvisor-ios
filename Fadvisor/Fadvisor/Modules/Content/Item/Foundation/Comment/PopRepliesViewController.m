//
//  PopRepliesViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/5.
//

#import "PopRepliesViewController.h"
#import <HWPanModal/HWPanModal.h>
#import "PopNavView.h"

@interface PopRepliesViewController ()<HWPanModalPresentable, PopNavViewDelegate>

@property (nonatomic, strong) PopNavView *navView;

@end

@implementation PopRepliesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];

    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top += 44;
    self.tableView.contentInset = contentInset;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self hw_panModalTransitionTo:PresentationStateLong animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hw_panModalSetNeedsLayoutUpdate];
}

- (PopNavView *)navView {
    if (!_navView) {
        _navView = [[PopNavView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.f)];
        _navView.title = @"Comments";
        _navView.backButtonTitle = @"Back";
        _navView.rightButtonTitle = @"Done";
        _navView.delegate = self;

    }
    return _navView;
}

#pragma mark - PopNavViewDelegate
- (void)didTapRightButton {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark - HWPanModalPresentable

- (nullable UIScrollView *)panScrollable {
    return self.tableView;
}

- (BOOL)shouldRespondToPanModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 如果拖拽的点在navigation bar上，则返回yes，可以拖拽，否则只能滑动tableView
    CGPoint loc = [panGestureRecognizer locationInView:self.view];
    if (CGRectContainsPoint(self.navView.frame, loc)) {
        return YES;
    }
    return NO;
}

- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, [UIApplication sharedApplication].statusBarFrame.size.height);
}

- (CGFloat)topOffset {
    return 0;
}

- (BOOL)showDragIndicator {
    return NO;
}

@end
