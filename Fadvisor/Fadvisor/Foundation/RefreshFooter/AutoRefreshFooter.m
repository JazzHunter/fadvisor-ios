//
//  AutoRefreshFooter.m
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/2/22.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import "AutoRefreshFooter.h"

@implementation AutoRefreshFooter

#pragma mark - 重写方法
- (void)prepare {
    [super prepare];

//    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i <= 60; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
//        [idleImages addObject:image];
//    }
//    [self setImages:idleImages forState:MJRefreshStateIdle];
//
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i <= 3; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
//        [refreshingImages addObject:image];
//    }
//    [self setImages:refreshingImages forState:MJRefreshStatePulling];
//
//    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
