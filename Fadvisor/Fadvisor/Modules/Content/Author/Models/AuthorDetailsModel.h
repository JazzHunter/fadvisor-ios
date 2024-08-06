//
//  AuthorDetailsModel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/7/2.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "AuthorModel.h"
#import "TagModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorDetailsModel : NSObject

/** id */
@property (nonatomic, copy) NSString *authorId;

/** 富文本内容 */
@property (nonatomic, copy) NSString *content;

/** 主页URL */
@property (nonatomic, copy) NSString *homepageUrl;

/** 文章数量 */
@property (assign, nonatomic) NSUInteger articleCount;

/** 文档数量 */
@property (assign, nonatomic) NSUInteger docCount;

/** 视频数量 */
@property (assign, nonatomic) NSUInteger videoCount;

/** 音频数量 */
@property (assign, nonatomic) NSUInteger audioCount;

/** 直播数量 */
@property (assign, nonatomic) NSUInteger liveCount;

/** 专题数量 */
@property (assign, nonatomic) NSUInteger topicCount;

/** 栏目数量 */
@property (assign, nonatomic) NSUInteger columnCount;

/** 组织 */
@property (nonatomic, copy) NSString *organization;

/** 级别 */
@property (nonatomic, copy) NSString *grade;

/** 联系人 */
@property (nonatomic, strong) NSMutableArray<UserModel *> *contacts;

/** 相关作者 */
@property (nonatomic, strong) NSMutableArray<AuthorModel *> *relatedAuthors;

/** 标签信息 */
@property (nonatomic, strong) NSMutableArray<TagModel *> *tags;

@end

NS_ASSUME_NONNULL_END
