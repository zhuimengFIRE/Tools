//
//  NSString+FFHelper.h
//  TestDemo
//
//  Created by 方超 on 2019/7/17.
//  Copyright © 2019 GTion. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FFHelper)

#pragma mark -----  正则验证
- (BOOL)ff_verifyEmail;
- (BOOL)ff_verifytelPhone;
- (BOOL)ff_verifyIdentityCardNum;
- (BOOL)ff_verifyUrl;
- (BOOL)ff_verifyChinese;




- (NSString *)ff_md5;
- (NSString *)ff_base64;

/**
 * 获得第一个字母（大写），第一个不为字母则返回#
 */
- (NSString *)ff_getHeaderOfString;

/**
 *  每3位数加一个逗号分隔
 */
- (NSString *)ff_addSeparated;

/**
 *  判断是否包含表情
 */
- (BOOL)ff_stringContainsEmoji;


/**
 时间戳转字符串
 
 @param format @"yyyy-MM-dd HH:mm:ss"
 @return 时间字符串
 */
- (NSString *)ff_stringFromTimestampWithFormat:(NSString *)format;

/**
 字符串转NSDate
 
 @param format @"yyyy-MM-dd HH:mm:ss"
 @return NSDate
 */
- (NSDate *)ff_dateWithStringFormat:(NSString *)format;

/**
 保留小数点后几位
 
 @param count 保留几位小数
 @return 截取后的字符串
 */
- (NSString *)ff_subStringWithDortCount:(NSInteger)count;

/**
 
 去除浮点数字符串后面的0
 */
- (NSString *)ff_removeFloatAllZero;

/**
 
 手机号中间数用*替代
 */
- (NSString *)ff_hiddenPhoneNum;


/**
 
 两个数相加
 */
- (NSString *)ff_numberAddWith:(NSString *)num;

/**
 
 两个数相减
 */
- (NSString *)ff_numberSubtractingWith:(NSString *)num;
/**
 
 两个数相乘
 */
- (NSString *)ff_numberMultiplyingWith:(NSString *)num;

/**
 
 两个数相除
 */
- (NSString *)ff_numberDivisionWith:(NSString *)num;


@end

NS_ASSUME_NONNULL_END
