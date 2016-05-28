//
//  NSDate+MGExtension.h
//  06-BaiSi
//
//  Created by ming on 13/11/25.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MGExtension)
/**
 * 比较self和from时间的差值
 * 返回一个NSDateComponents：包括年月日时分秒
 */
- (NSDateComponents *)mg_deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)mg_isThisYear;

/**
 * 是否为今天
 */
- (BOOL)mg_isToday;

/**
 * 是否为昨天
 */
- (BOOL)mg_isYesterday;

@end
