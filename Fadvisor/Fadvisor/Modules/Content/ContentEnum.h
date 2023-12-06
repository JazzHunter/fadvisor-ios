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

/**
 返回的 ResultMode类型
 */
typedef enum : NSInteger {
    ResultModeNotAuthorized = -1,
    ResultModeNotFound = -2,
    ResultModeWaiting = -3,
    ResultModeHalt = -4,
    ResultModeNormal = 1,
    ResultModePreview = 2
} ResultMode;

/**
 获取方式
 */
typedef enum : NSInteger {
    AcquisitionActionLoginRequired = -1,
    AcquisitionActionInternalResource = -2,
    AcquisitionActionRestrictResource = -3,
    AcquisitionActionCodeRequired = -4,
    AcquisitionActionPayRequired = -5,
    AcquisitionActionCollRequired = -6,
    AcquisitionActionNone = -9,
    AcquisitionActionFree = 1,
    AcquisitionActionLimitedFree = 2,
    AcquisitionActionPay = 3,
    AcquisitionActionCode = 4,
    AcquisitionActionGift = 5,
    AcquisitionActionColl = 6,
    AcquisitionActionTrial = 7,
    AcquisitionActionUserGroup = 8,
    AcquisitionActionSys = 9
} AcquisitionAction;

#endif /* ContentConstants_h */
