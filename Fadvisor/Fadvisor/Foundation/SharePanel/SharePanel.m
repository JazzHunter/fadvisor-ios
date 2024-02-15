//
//  SharePanel.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/8.
//

#import "SharePanel.h"
#import <LEEAlert/LEEAlert.h>
#import "UMengHelper.h"

@interface SharePanel ()

@property (nonatomic) CGFloat viewWidth;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 简介 */
@property (nonatomic, copy) NSString *introduction;
/** 封面图地址 */
@property (nonatomic, copy) NSString *thumbUrl;
/** 分享地址 */
@property (nonatomic, copy) NSString *shareURL;

@property (nonatomic, strong) MyLinearLayout *weChatShareBtn;

@end

@implementation SharePanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        self.viewWidth = screenWidth > screenHeight ? screenHeight : screenWidth;
        
        self.orientation = MyOrientation_Vert;
        self.backgroundColor = [UIColor backgroundColor];
        self.gravity = MyGravity_Horz_Center;
        self.mySize = CGSizeMake(self.viewWidth, MyLayoutSize.wrap);
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [@"Share To" localString];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [titleLabel sizeToFit];
    titleLabel.myTop = 12;
    [self addSubview:titleLabel];
    
    UIScrollView *topScrollView = [self createThirdPartyShareLayout];
    topScrollView.myTop = 12;
    [self addSubview:topScrollView];

    UIScrollView *bottomScrollView = [self createCommonShareLayout];
    bottomScrollView.myTop = 12;
    [self addSubview:bottomScrollView];
}

- (UIScrollView *)createThirdPartyShareLayout {
    UIScrollView *topScrollView = [self createScrollView];

    MyLinearLayout *topLayout = [self createBtnsLayout];
    [topScrollView addSubview:topLayout];
    
    self.weChatShareBtn = [self createShareBtn:@"ic_wechat_color" label:@"微信好友" tag:1000];
    
    [topLayout addSubview:self.weChatShareBtn];
    [topLayout addSubview:[self createShareBtn:@"ic_moments_color" label:@"朋友圈" tag:2000]];
    [topLayout addSubview:[self createShareBtn:@"ic_qq_color" label:@"QQ" tag:3000]];
    [topLayout addSubview:[self createShareBtn:@"ic_weibo_color" label:@"微博" tag:4000]];
    return topScrollView;
}

- (UIScrollView *)createScrollView {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.mySize = CGSizeMake(self.viewWidth, MyLayoutSize.wrap);
    scrollView.showsHorizontalScrollIndicator = NO;
    return scrollView;
}

- (MyLinearLayout *)createBtnsLayout{
    MyLinearLayout *btnsLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    btnsLayout.padding = UIEdgeInsetsMake(12, 32, 12, 32);
    btnsLayout.myHeight = MyLayoutSize.wrap;
    btnsLayout.subviewHSpace = 10;
    btnsLayout.gravity = MyGravity_Horz_Center;
    return btnsLayout;
}

- (MyLinearLayout *)createShareBtn:(NSString *)imageName label:(NSString *)label tag:(NSInteger)tag {
    MyLinearLayout *shareBtnLayer = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    shareBtnLayer.myWidth = (self.viewWidth - 1 * 32 * 2 - 1 * 4 * 10) / 5;
    shareBtnLayer.gravity = MyGravity_Horz_Center;
    shareBtnLayer.tag = tag;
    [shareBtnLayer setTarget:self action:@selector(handleShareBtnClicked:)];

    UIImageView *imageView = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, 36, 36);
    [shareBtnLayer addSubview:imageView];

    UILabel *btnLabel = [[UILabel alloc] init];
    btnLabel.myTop = 8;
    btnLabel.text = label;
    btnLabel.textColor = [UIColor titleTextColor];
    btnLabel.font = [UIFont systemFontOfSize:13];
    [btnLabel sizeToFit];
    [shareBtnLayer addSubview:btnLabel];

    return shareBtnLayer;
}


- (UIScrollView *)createCommonShareLayout {
    UIScrollView *bottomScrollView = [self createScrollView];

    MyLinearLayout *bottomLayout = [self createBtnsLayout];
    [bottomScrollView addSubview:bottomLayout];

    [bottomLayout addSubview:[self createShareRoundBtn:@"ic_link_plain" label:@"拷贝链接" tag:6000]];
    [bottomLayout addSubview:[self createShareRoundBtn:@"ic_safari_plain" label:@"浏览器" tag:7000]];
    [bottomLayout addSubview:[self createShareRoundBtn:@"ic_more_plain" label:@"更多" tag:8000]];
    return bottomScrollView;
}

- (MyLinearLayout *)createShareRoundBtn:(NSString *)imageName label:(NSString *)label tag:(NSInteger)tag {
    MyLinearLayout *shareBtnLayer = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    shareBtnLayer.myWidth = (self.viewWidth - 1 * 32 * 2 - 1 * 4 * 10) / 5;
    shareBtnLayer.gravity = MyGravity_Horz_Center;
    shareBtnLayer.tag = tag;
    [shareBtnLayer setTarget:self action:@selector(handleShareBtnClicked:)];

    MyLinearLayout *imageContainer = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    imageContainer.mySize = CGSizeMake(42, 42);
    imageContainer.padding = UIEdgeInsetsMake(7, 7, 7, 7);
    imageContainer.layer.cornerRadius = 21;
    imageContainer.layer.masksToBounds = YES;
    imageContainer.backgroundColor = [UIColor colorFromHexString:@"d9d9d9"];
    [shareBtnLayer addSubview:imageContainer];
    
    UIImageView *imageView = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, 28, 28);
    [imageContainer addSubview:imageView];

    UILabel *btnLabel = [[UILabel alloc] init];
    btnLabel.myTop = 8;
    btnLabel.text = label;
    btnLabel.textColor = [UIColor titleTextColor];
    btnLabel.font = [UIFont systemFontOfSize:13];
    [btnLabel sizeToFit];
    [shareBtnLayer addSubview:btnLabel];

    return shareBtnLayer;
}

-(void)handleShareBtnClicked:(MyBaseLayout*)sender{
    // 关闭当前显示的Alert或ActionSheet
   [LEEAlert  closeWithIdentifier:@"sharePanel" completionBlock:^{
       switch (sender.tag) {
           case 1000:
               [UMengHelper shareLinkToPlatform:UMSocialPlatformType_WechatSession title:self.title introduction:self.introduction thumbURL:self.thumbUrl shareURL:self.shareURL];
               break;
           default:
               break;
       }
   }];
}

/** 显示Item */
- (void)showPanelWithItem:(ItemModel *)itemModel {
    self.title = [itemModel.title copy];
    self.introduction = [itemModel.introduction copy];
//    self.thumbUrl = [model.coverUrl copy];
//    self.shareURL = [model.coverUrl copy];
    self.thumbUrl = @"https://upload.jianshu.io/users/upload_avatars/2784338/0d53044867da.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/90/h/90/format/webp";
    self.shareURL = @"https://upload.jianshu.io/users/upload_avatars/2784338/0d53044867da.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/90/h/90/format/webp";
    
    Weak(self);
    
    [LEEAlert actionsheet].config
    .LeeIdentifier(@"sharePanel")
    .LeeAddCustomView(^(LEECustomView *custom) {
        custom.view = self;
        custom.isAutoWidth = YES;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeActionSheetBottomMargin(0.0f)
    .LeeActionSheetBackgroundColor([UIColor backgroundColor])
    .LeeCornerRadius(12.0f)
//    .LeeBackGroundColor([UIColor grayColor])     //屏幕背景颜色
    .LeeBackgroundStyleTranslucent(0.5f)     //屏幕背景半透明样式 参数为透明度
    .LeeConfigMaxWidth(^CGFloat (LEEScreenOrientationType type, CGSize size) {     // 设置最大宽度 (根据横竖屏类型进行设置 最大高度同理)
        // 横屏类型
        if (type == LEEScreenOrientationTypeVertical) {
            return CGRectGetWidth([[UIScreen mainScreen] bounds]);
        }
        return 414.0f;
    })
    .LeeOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            animatingBlock(); //调用动画中Block
        } completion:^(BOOL finished) {
            animatedBlock(); //调用动画结束Block
        }];
    })
    .LeeShow();
}

+ (instancetype)manager {
    static SharePanel *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


@end
