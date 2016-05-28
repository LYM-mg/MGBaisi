//
//  NSDate+MGExtension.m
//  06-BaiSi
//
//  Created by ming on 14/11/25.
//  Copyright © 2014年 ming. All rights reserved.
/**
 * 这是一个处理时间的分类（用于计算服务器返回的时间与当前时间比较）
 * 分为：
 *      今年 非今年
 *      今天 昨天  明天
 *      几小时前 几分钟前 一分钟以内
 */

#import "NSDate+MGExtension.h"

@implementation NSDate (MGExtension)

- (NSDateComponents *)mg_deltaFrom:(NSDate *)from{
    // 获取日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

/** 是否是今年 */
- (BOOL)mg_isThisYear{
    // 获取日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    // NSInteger之间的比较
    return nowYear == selfYear;
}

/** 是否是今天 */
- (BOOL)mg_isToday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    
    // 字符串之间的比较
    return [nowString isEqualToString:selfString];
//    return [nowString isEqual:selfString];
}

/** 是否是昨天 */
- (BOOL)mg_isYesterday{
    // 去除掉时分秒
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |
    NSCalendarUnitDay;
    NSDateComponents *coms = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return coms.year == 0
    && coms.month == 0
    && coms.day == 1;
}

/** 是否是昨天  (注：这个只是扩展，实际开发不会用到是否是明天的) */
- (BOOL)mg_isTomorrow{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |
    NSCalendarUnitDay;
    NSDateComponents *coms = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return coms.year == 0
    && coms.month == 0
    && coms.day == -1;
}
@end
//- (BOOL)mg_isToday{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//    NSDateComponents *nowComs = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfComs = [calendar components:unit fromDate:self];
//
//    return [nowComs isEqual:selfComs];
//}

//- (BOOL)mg_isToday{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//    NSDateComponents *nowComs = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfComs = [calendar components:unit fromDate:self];
//
//    return nowComs.year == selfComs.year
//    && nowComs.month == selfComs.month
//    && nowComs.day == selfComs.day;
//}

