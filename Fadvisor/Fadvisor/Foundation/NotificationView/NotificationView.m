//
//  NotificationView.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/1.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "NotificationView.h"
#import <MyLayout/MyLayout.h>

#define MarginVertical  10
#define MarginHorizon   18
#define MessageTextSize 15

#pragma mark - NotificationView
@interface NotificationView ()<CAAnimationDelegate>
@end

@implementation NotificationView

+ (NotificationView *)showNotificaiton:(NSString *)message {
    return [self showNotificaiton:message type:NotificationInfo];
}

+ (NotificationView *)showNotificaiton:(NSString *)message type:(NotificationType)type {
    return [[self alloc] initWithMessage:message type:type];
}

- (NotificationView *)initWithMessage:(NSString *)message type:(NotificationType)type {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        self.myWidth = MyLayoutSize.wrap;
        self.myHeight = MyLayoutSize.wrap;
        MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        rootLayout.padding = UIEdgeInsetsMake(MarginVertical, MarginHorizon, MarginVertical, MarginHorizon);
        rootLayout.gravity = MyGravity_Horz_Center;
        rootLayout.widthSize.equalTo(@(MyLayoutSize.wrap));
        rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));

        rootLayout.layer.shadowColor = [UIColor blackColor].CGColor;
        rootLayout.layer.shadowOffset = CGSizeMake(1, 1);
        rootLayout.layer.shadowOpacity = 0.12f;
        rootLayout.layer.shadowRadius = 0;

        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.font = [UIFont systemFontOfSize:MessageTextSize];
        messageLabel.numberOfLines = 1;
        messageLabel.text = message;
        [messageLabel sizeToFit];
        [rootLayout addSubview:messageLabel];
        [rootLayout setNeedsLayout];
        [rootLayout layoutIfNeeded];
        rootLayout.layer.cornerRadius = rootLayout.height / 2;
        switch (type) {
            case NotificationInfo:
                rootLayout.backgroundColor = [UIColor colorFromHexString:@"8799a3"];
                messageLabel.textColor = [UIColor whiteColor];
                break;
            case NotificationSuccess:
                rootLayout.backgroundColor = [UIColor colorFromHexString:@"39b54a"];
                messageLabel.textColor = [UIColor whiteColor];
                break;
            case NotificationWarning:
                rootLayout.backgroundColor = [UIColor colorFromHexString:@"f37b1d"];
                messageLabel.textColor = [UIColor whiteColor];
                break;
            case NotificationDanger:
                rootLayout.backgroundColor = [UIColor colorFromHexString:@"e54d42"];
                messageLabel.textColor = [UIColor whiteColor];
                break;
            default:
                break;
        }

        //位移开始动画
        CABasicAnimation *posStartAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        posStartAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, rootLayout.height / 2)];
        posStartAnim.byValue = [NSValue valueWithCGPoint:CGPointMake(0, kDefaultNavBarHeight)];
        posStartAnim.removedOnCompletion = NO;
        posStartAnim.fillMode = kCAFillModeForwards;
        posStartAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        posStartAnim.duration = 0.6f;

        //位移结束动画
        CABasicAnimation *posEndAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        posEndAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, rootLayout.height / 2 + kDefaultNavBarHeight)];
        posEndAnim.byValue = [NSValue valueWithCGPoint:CGPointMake(0, -kDefaultNavBarHeight)];
        posEndAnim.removedOnCompletion = NO;
        posEndAnim.beginTime = 3.6;
        posEndAnim.fillMode = kCAFillModeForwards;
        posEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        posEndAnim.duration = 0.6f;

        //透明度开始动画
        CABasicAnimation *opacityStartAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityStartAnim.fromValue = @(0.0f);
        opacityStartAnim.toValue = @(1.0f);
        opacityStartAnim.duration = 0.6f;
        opacityStartAnim.fillMode = kCAFillModeForwards;
        opacityStartAnim.removedOnCompletion = NO;
        opacityStartAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        //透明度结束动画
        CABasicAnimation *opacityEndAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityEndAnim.fromValue = @(1.0f);
        opacityEndAnim.toValue = @(0.0f);
        opacityEndAnim.duration = 0.6f;
        opacityEndAnim.beginTime = 3.6;
        opacityEndAnim.fillMode = kCAFillModeForwards;
        opacityEndAnim.removedOnCompletion = NO;
        opacityEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        // 创建组动画对象
        CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
        groupAnim.animations = @[posStartAnim, posEndAnim, opacityStartAnim, opacityEndAnim];

        // 设置动画执行时间
        groupAnim.duration = 4.f;
        groupAnim.fillMode = kCAFillModeForwards;
        groupAnim.delegate = self;
        groupAnim.removedOnCompletion = NO;

        [self.layer addAnimation:groupAnim forKey:nil];
        [self addSubview:rootLayout];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeFromSuperview];
}

@end

#pragma mark - NotificationLargeView
@interface NotificationLargeView ()<CAAnimationDelegate>
@end

@implementation NotificationLargeView

+ (NotificationLargeView *)showNotificaiton:(NSString *)message {
    return [self showNotificaiton:message type:NotificationSuccess];
}

+ (NotificationLargeView *)showNotificaiton:(NSString *)message type:(NotificationType)type {
    return [[self alloc] initWithMessage:message type:type];
}

- (NotificationLargeView *)initWithMessage:(NSString *)message type:(NotificationType)type {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kDefaultNavBarHeight)];
    if (self) {
        switch (type) {
            case NotificationInfo:
                self.backgroundColor = [UIColor colorFromHexString:@"606266"];
                break;
            case NotificationSuccess:
                self.backgroundColor = [UIColor colorFromHexString:@"67C23A"];
                break;
            case NotificationWarning:
                self.backgroundColor = [UIColor colorFromHexString:@"E6A23C"];
                break;
            case NotificationDanger:
                self.backgroundColor = [UIColor colorFromHexString:@"F56C6C"];
                break;
            default:
                break;
        }

        MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
        rootLayout.myHeight = 44.f;
        rootLayout.myTop = kStatusBarHeight;
        rootLayout.myHorzMargin = 0;
        rootLayout.paddingLeft = 16;
        rootLayout.gravity = MyGravity_Vert_Center | MyGravity_Horz_Left;

        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.font = [UIFont systemFontOfSize:MessageTextSize];
        messageLabel.numberOfLines = 1;
        messageLabel.text = message;
        messageLabel.textColor = [UIColor whiteColor];
        [messageLabel sizeToFit];
        [rootLayout addSubview:messageLabel];

        //位移开始动画
        CABasicAnimation *posStartAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        posStartAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, -kDefaultNavBarHeight / 2)];
        posStartAnim.byValue = [NSValue valueWithCGPoint:CGPointMake(0, kDefaultNavBarHeight)];
        posStartAnim.removedOnCompletion = NO;
        posStartAnim.fillMode = kCAFillModeForwards;
        posStartAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        posStartAnim.duration = 0.5f;

        //位移结束动画
        CABasicAnimation *posEndAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        posEndAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth / 2, kDefaultNavBarHeight / 2)];
        posEndAnim.byValue = [NSValue valueWithCGPoint:CGPointMake(0, -kDefaultNavBarHeight)];
        posEndAnim.removedOnCompletion = NO;
        posEndAnim.beginTime = 3.5;
        posEndAnim.fillMode = kCAFillModeForwards;
        posEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        posEndAnim.duration = 0.5f;

        // 创建组动画对象
        CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
        groupAnim.animations = @[posStartAnim, posEndAnim];

        // 设置动画执行时间
        groupAnim.duration = 4.f;
        groupAnim.fillMode = kCAFillModeForwards;
        groupAnim.delegate = self;
        groupAnim.removedOnCompletion = NO;

        [self.layer addAnimation:groupAnim forKey:nil];
        [self addSubview:rootLayout];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self removeFromSuperview];
}

@end
