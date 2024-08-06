//
//  PDFWebViewController.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/30.
//

#import "PDFWebViewController.h"
#import <WebKit/WebKit.h>

@interface PDFWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation PDFWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];

    [self creatUI];
}

- (void)creatUI {
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(10, 20, 60, 40);
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
//
//    [self.view addSubview:self.myWebView];
//
//    [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(60);
//        make.left.right.bottom.offset(0);
//    }];
//
//    NSURL *pathUrl = [NSURL URLWithString:self.urlStr];
//    NSURLRequest *request = [NSURLRequest requestWithURL:pathUrl];
//
//    [self.myWebView loadRequest:request];
//    //使文档的显示范围适合UIWebView的bounds
//    [self.myWebView setScalesPageToFit:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在加载中...";
}

- (void)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor backgroundColor];
    }
    return _webView;
}


@end
