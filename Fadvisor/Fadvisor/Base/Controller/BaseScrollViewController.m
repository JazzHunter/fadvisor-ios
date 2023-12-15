//
//  BaseScrollViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/4.
//

#import "BaseScrollViewController.h"

@interface BaseScrollViewController ()

@end

@implementation BaseScrollViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBaseScrollViewUI];
}

- (void)setupBaseScrollViewUI {
    if ([self baseViewControllerIsNeedNavBar:self]) {
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.top += kDefaultNavBarHeight;
        self.scrollView.contentInset = contentInset;
    }
    self.scrollView.backgroundColor = [UIColor clearColor];

    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0); //设置布局内的子视图离自己的边距.
    contentLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    contentLayout.heightSize.lBound(_scrollView.heightSize, 0, 1); //高度虽然是自适应的。但是最小的高度不能低于父视图的高度.
    [_scrollView addSubview:contentLayout];
    self.contentLayout = contentLayout;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:scrollView];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView = scrollView;
    }
    return _scrollView;
}

@end
