//
//  NSBundle+Additions.h
//  FingerAdvisor
//
//  Created by 韩建伟 on 2020/3/30.
//  Copyright © 2020 普华永道迪祺通数据服务（上海）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Additions)

/**
 Get the path of `resource.bundle`.

 @return path of the `PYSearch.bundle`
 */
+ (NSBundle *)resourceBundle;

@end

NS_ASSUME_NONNULL_END
