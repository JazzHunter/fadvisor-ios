//
//  Author.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthorModel : NSObject

/** id */
@property (nonatomic, copy) NSString *authorId;

/** 永远是itemTypeAuthor */
@property (assign, nonatomic) NSInteger itemType;

/** 修改时间 */
@property (nonatomic, copy) NSString *updateTime;

/** 姓名 */
@property (nonatomic, copy) NSString *name;

/** 别名 */
@property (nonatomic, copy) NSString *aliasName;

/**头像 */
@property (nonatomic, strong) NSURL *avatar;

/** 全身像 */
@property (nonatomic, strong) NSURL *coverUrl;

/**背景图 */
@property (nonatomic, strong) NSURL *bgUrl;

/** 邮件 */
@property (nonatomic, copy) NSString *email;

/** 介绍 */
@property (nonatomic, copy) NSString *introduction;

/** 职位 */
@property (nonatomic, copy) NSString *title;

/** 手机 */
@property (nonatomic, copy) NSString *phone;

/** 固话 */
@property (nonatomic, copy) NSString *tel;

/** 是否推荐 */
@property (nonatomic, assign) BOOL rcmd;

/** 是否热门 */
@property (nonatomic, assign) BOOL hot;

/** 是否精选 */
@property (nonatomic, assign) BOOL feature;

/** 正文节选 */
@property (nonatomic, copy) NSString *contentText;

/** 发布模式 */
@property (nonatomic, assign) NSString *pubMode;

/** 是否关注 */
@property (nonatomic, assign) BOOL followed;

/** 查看数量 */
@property (assign, nonatomic) NSUInteger viewCount;

/** 追随者数量 */
@property (assign, nonatomic) NSUInteger followerCount;

/** 内容数量 */
@property (assign, nonatomic) NSUInteger itemCount;

/** 动作时间 */
@property (nonatomic, copy) NSString *actionTime;

/** 最近的内容 */
//@property (nonatomic, strong) NSMutableArray<Item *> *recentItems;

@end

NS_ASSUME_NONNULL_END
