//
//  LYMTimeTool.h
//  05-QQ音乐
//
//  Created by ming on 15/11/24.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYMTimeTool : NSObject

+ (NSString *)getFormatTimeWithTimeInterval:(NSInteger)timeInterval;

//+ (float)getTimeIntervalWithFormat:(NSString *)format;
+ (float)getTimeIntervalWithFormatTime:(NSString *)format;

@end
