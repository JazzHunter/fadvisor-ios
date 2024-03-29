//
//  NSString+AlivcHelper.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/3/22.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Additions)

/**
 语言国际化
 
 @return 本地化的语言
 */
- (NSString *)localString;


/**
 nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
 
 @discussion 可用于判断用户名或者密码是否为空
 */
- (BOOL)isNotEmpty;

/*
 * 功能 ： 检查字符串是否是nil/null，返回判断后的字符串
 * 参数 : inputString : 输入字符串
 * return : 返回判断后的字符串
 */
+ (NSString *)checkString:(NSString *)inputString;
+ (BOOL)checkStringIsEmpty:(NSString *)inputString;

/*
 * 功能 ： MD5
 * 参数 : inputString : 输入字符串
 * return : 返回MD5后的字符串
 */
+ (NSString *)MD5:(NSString *) inputString;

/*
 * 功能 ： 编码
 * 参数 : inputString : 输入字符串
 * return : 返回编码后的字符串
 */
+ (NSString *)encodeToPercentEscapeString: (NSString *) inputString;

/*
 * 功能 ： 解码
 * 参数 : inputString : 输入字符串
 * return : 返回解码后的字符串
 */
+ (NSString *)decodeFromPercentEscapeString: (NSString *) inputString;

/*
 * 功能 : 获取UUID
 * return : 返回UUID的字符串
 */
+ (NSString*)generateUUID;

/*
 * 功能 : 获取UTC时间
 * return : 返回UTC时间的字符串
 */
+ (NSString *)getDateUTCTime;

/*
 * 功能 : HmacSHA1加密；
 * return : 返回加密后的字符串
 */
+(NSString *)HmacSha1:(NSString *)key input:(NSString *)input;


//密码加密方式：SHA1
+(NSString *)EncriptPassword_SHA1:(NSString *)password;


/**
 返回一个字符串的字符长度

 @param strtemp 字符串
 @return 字符长度
 */
+ (NSInteger)charLengthWith:(NSString *)strtemp;
NS_ASSUME_NONNULL_END

@end
