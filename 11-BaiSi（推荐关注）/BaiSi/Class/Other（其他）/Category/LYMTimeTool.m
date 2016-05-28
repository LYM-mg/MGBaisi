//
//  LYMTimeTool.m
//  05-QQ音乐
//
//  Created by ming on 15/11/24.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "LYMTimeTool.h"

@implementation LYMTimeTool

+ (NSString *)getFormatTimeWithTimeInterval:(NSInteger)timeInterval{
    NSInteger sec = (NSInteger)timeInterval % 60;
    NSInteger min = (NSInteger)timeInterval / 60;
    
    return [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
}

+ (float)getTimeIntervalWithFormatTime:(NSString *)format{
//    NSArray *minsec = [format componentsSeparatedByString:@":"];
//    NSString *min = [minsec firstObject];
//    NSString *sec = [minsec lastObject];
//    return min.intValue*60 + sec.floatValue*0.01;
    NSArray *minAsec = [format componentsSeparatedByString:@":"];
    NSString *min = [minAsec firstObject];
    NSString *sec = [minAsec lastObject];
    
    return min.intValue * 60 + sec.floatValue;
}


@end
