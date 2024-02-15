//
//  VideoDetailsContentViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/22.
//

#import "VideoDetailsContentViewController.h"
#import "RichTextView.h"
#import "SharePanel.h"

@interface VideoDetailsContentViewController ()

@property (nonatomic, copy) void (^ scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pubTimeLabel;
@property (nonatomic, strong) RichTextView *richTextView;
@property (nonatomic, strong) MyLinearLayout *shareBtn;

@end

@implementation VideoDetailsContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor pwcPinkColor];
    
    Weak(self);
    self.richTextView.loadedFinishBlock = ^(CGFloat height) {
        if (height > 0) {
            weakself.richTextView.myHeight = height;
            weakself.richTextView.alpha = 0.0f;
            [UIView animateWithDuration:0.3f animations:^{
                weakself.richTextView.alpha = 1.0f;
            }];
        } else {
            // 加载失败 提示用户
        }
    };
}

-(void)handleSharePanelOpen:(MyBaseLayout*)sender{
    [[SharePanel manager] showPanelWithItem:self.itemModel];
}


#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listWillAppear {
}

- (void)listDidAppear {
}

- (void)listWillDisappear {
}

- (void)listDidDisappear {
}

#pragma mark - getters and setters

@end
