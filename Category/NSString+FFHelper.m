//
//  NSString+FFHelper.m
//  TestDemo
//
//  Created by 方超 on 2019/7/17.
//  Copyright © 2019 GTion. All rights reserved.
//

#import "NSString+FFHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (FFHelper)

- (BOOL)isValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

- (BOOL)ff_verifyEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isValidateByRegex:regex];
}

- (BOOL)ff_verifytelPhone {
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    if ([self isValidateByRegex:CM] || [self isValidateByRegex:CU] || [self isValidateByRegex:CT] || [self isEqualToString:PHS]) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)ff_verifyIdentityCardNum {
    NSString *identity = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self isValidateByRegex:identity];
}

- (BOOL)ff_verifyUrl {
    NSString *url = @"^((http)|(https))+:[^\\s]+\\.[^\\s]*$";
    return [self isValidateByRegex:url];
}

- (BOOL)ff_verifyChinese {
    NSString *chineseRegex = @"^[\u4e00-\u9fa5]+$";
    return [self isValidateByRegex:chineseRegex];
}


- (NSString *)ff_md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)ff_base64 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

/**
 *  获得第一个字母（大写），第一个不为字母则返回#
 */
- (NSString *)ff_getHeaderOfString {
    NSMutableString *strM = [[NSMutableString alloc] initWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)strM, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)strM, NULL, kCFStringTransformStripDiacritics, NO);
    if (strM.length != 0) {
        NSString *firstCharter = [[strM substringToIndex:1] uppercaseString];
        NSArray *alphabets = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
        if ([alphabets containsObject:firstCharter]) {
            return firstCharter;
        }
        return @"#";
    }
    return @"#";
}

- (NSString *)ff_addSeparated {
    if (self.length < 3) {
        return self;
    }
    NSArray *array = [self componentsSeparatedByString:@"."];
    NSString *numInt = array[0];
    if (numInt.length <= 3) {
        return self;
    }
    NSString *suffixStr = @"";
    if (array.count > 1) {
        suffixStr = [NSString stringWithFormat:@".%@",array[1]];
    }
    NSMutableArray *numArr = [[NSMutableArray alloc] init];
    while (numInt.length > 3) {
        NSString *temp = [numInt substringFromIndex:numInt.length - 3];
        numInt = [numInt substringToIndex:numInt.length - 3];
        // 得到倒序的数组
        [numArr addObject:[NSString stringWithFormat:@",%@",temp]];
    }
    for (int i = 0; i < [numArr count]; i ++) {
        numInt = [numInt stringByAppendingFormat:@"%@",numArr[numArr.count-1-i]];
    }
    return [NSString stringWithFormat:@"%@%@",numInt,suffixStr];
}

- (BOOL)ff_stringContainsEmoji {
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    
    return returnValue;
}



/**
 字符串转NSDate
 
 @param format @"yyyy-MM-dd HH:mm:ss"
 @return NSDate
 */
- (NSString *)ff_stringFromTimestampWithFormat:(NSString *)format{
    NSTimeInterval interval    = [self doubleValue];
    NSDate *date   = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}

- (NSDate *)ff_dateWithStringFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:self];
    return date;
}

- (NSString *)ff_subStringWithDortCount:(NSInteger)count {
    NSRange range = [self rangeOfString:@"."];
    NSString *result;
    if (self.length > range.location+count+1) {
        result = [self substringWithRange:NSMakeRange(0, range.location+count+1)];
    }else {
        result = self;
    }
    return result;
}

- (NSString *)ff_removeFloatAllZero {
    NSString *resultString = [NSString stringWithFormat:@"%@",@(self.floatValue)];
    return resultString;
}

- (NSString *)ff_hiddenPhoneNum {
    NSInteger length = self.length;
    if (length == 6) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(2, 2) withString:@"**"];
    }else if (length == 7) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(2, 3) withString:@"***"];
    }else if (length == 8) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 2) withString:@"**"];
    }else if (length == 9) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 3) withString:@"***"];
    }else if (length == 10) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else if (length == 11) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return self;
}

//两个double相除
- (NSString *)ff_numberDivisionWith:(NSString *)num{
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                             scale:8
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:YES];
    NSDecimalNumber *dec1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *dec2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *multiplyResult = [dec1 decimalNumberByDividingBy:dec2
                                                         withBehavior:handler];
    return [multiplyResult stringValue];
}

- (NSString *)ff_numberSubtractingWith:(NSString *)num{
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                             scale:8
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:YES];
    NSDecimalNumber *dec1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *dec2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *multiplyResult = [dec1 decimalNumberBySubtracting:dec2
                                                          withBehavior:handler];
    return [multiplyResult stringValue];
}

- (NSString *)ff_numberMultiplyingWith:(NSString *)num {
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                             scale:8
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:YES];
    NSDecimalNumber *dec1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *dec2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *multiplyResult = [dec1 decimalNumberByMultiplyingBy:dec2
                                                            withBehavior:handler];
    return [multiplyResult stringValue];
}

- (NSString *)ff_numberAddWith:(NSString *)num {
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                             scale:8
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:YES];
    NSDecimalNumber *dec1 = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *dec2 = [NSDecimalNumber decimalNumberWithString:num];
    NSDecimalNumber *multiplyResult = [dec1 decimalNumberByAdding:dec2
                                                     withBehavior:handler];
    return [multiplyResult stringValue];
}


@end
