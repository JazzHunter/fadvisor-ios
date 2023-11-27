//
//  BaseItemDetailsModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseItemDetailsModel : NSObject

/** id */
@property (nonatomic, copy) NSString *itemId;

/** 富文本内容 */
@property (nonatomic, copy) NSString *content;

/** 查看原文的地址 */
@property (nonatomic, strong) NSURL *sourceUrl;

/** 富文本容类型，普通/Markdown */
@property (nonatomic, copy) NSString *richTextType;

@end

NS_ASSUME_NONNULL_END
