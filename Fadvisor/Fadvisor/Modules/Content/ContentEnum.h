//
//  ContentConstants.h
//  Fadvisor
//
//  Created by 韩建伟 on 2023/11/18.
//

#ifndef ContentConstants_h
#define ContentConstants_h

/**
 需要加载的数据类型
 */
typedef enum : NSUInteger {
    ItemTypeAuthor = 1,
    ItemTypeUser = 2,
    ItemTypeUserGroup = 3,
    ItemTypeImageFile = 6,
    ItemTypeMediaFile = 7,
    ItemTypeMp = 8,
    ItemTypeWebLink = 11,
    ItemTypeCard = 12,
    ItemTypePwCPage = 13,
    ItemTypeText = 14,
    ItemTypeArticle = 21,
    ItemTypeDoc = 22,
    ItemTypeVideo = 23,
    ItemTypeAudio = 24,
    ItemTypeTopic = 41,
    ItemTypeColumn = 42,
    ItemTypeChapter = 44,
    ItemTypeTag = 61,
    ItemTypeFavorites = 66,
} ItemType;

#endif /* ContentConstants_h */
