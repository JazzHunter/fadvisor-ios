//
//  ContentUtils.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/11.
//

#import "ContentUtils.h"

@implementation ContentUtils

+ (NSString *)itemTypeDescByItemType:(NSInteger)itemType {
    switch (itemType) {
        case ItemTypeArticle:
            return @"图文";
        case ItemTypeDoc:
            return @"文档";
        case ItemTypeVideo:
            return @"视频";
        case ItemTypeAudio:
            return @"音频";
        case ItemTypeColumn:
            return @"合集";
        case ItemTypeTopic:
            return @"专题";
        default:
            return @"";
    }
}

@end
