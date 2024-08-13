//
//  AlivcPlayerDefine.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/20.
//

#import "AlivcPlayerDefine.h"

@implementation AlivcPlayerDefine

//获取所有已知清晰度泪飙
+ (NSArray<NSString *> *)allQualities {
    return @[[@"VOD_FD" localString],
             [@"VOD_LD" localString],
             [@"VOD_SD" localString],
             [@"VOD_HD" localString],
             [@"VOD_2K" localString],
             [@"VOD_4K" localString],
             [@"VOD_OD" localString],
    ];
}

@end
