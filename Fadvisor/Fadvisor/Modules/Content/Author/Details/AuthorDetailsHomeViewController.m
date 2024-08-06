//
//  AuthorDetailsHomeViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/2.
//

#import "AuthorDetailsHomeViewController.h"

@interface AuthorDetailsHomeViewController ()

@property (nonatomic, copy) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);

@end

@implementation AuthorDetailsHomeViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *fakeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 1200)];
    [self.contentLayout addSubview:fakeView];
}

#pragma mark - GKPageListViewDelegate or GKPageSmoothListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.listScrollViewScrollCallback = callback;
}

- (void)listViewWillAppear {
    
}

- (void)listViewDidAppear {
    
}

- (void)listViewWillDisappear {
    
}

- (void)listViewDidDisappear {
    
}

@end
