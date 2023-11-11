//
//  UIButton+ViolenceBtn.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/7/26.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
防止按钮重复暴力点击
*/
@interface UIButton (ViolenceBtn)
//点击间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;
//用于设置单个按钮不需要被hook (设为yes说明可以重复点击)
@property (nonatomic, assign) BOOL isIgnore;

@end

NS_ASSUME_NONNULL_END
