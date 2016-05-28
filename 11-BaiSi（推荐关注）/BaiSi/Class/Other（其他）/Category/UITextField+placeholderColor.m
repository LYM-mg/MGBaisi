//
//  UITextField+placeholderColor.m
//  02-BaiSi
//
//  Created by ming on 13/12/19.
//  Copyright © 2013年 ming. All rights reserved.
/**
 *  设置占位文字的颜色,让外界直接使用
 */

#import "UITextField+placeholderColor.h"
/** 占位文字的颜色 */
static NSString *const placeholderColorKey = @"placeholderLabel.textColor";

@implementation UITextField (placeholderColor)

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    BOOL change = NO;
    if (self.placeholder == nil) {
        self.placeholder = @"mingge";
        change = YES;
    }
    [self setValue:placeholderColor forKeyPath:placeholderColorKey];
    if (change) {
        self.placeholder = nil;
    }
}

//- (UIColor *)placeholderColor{
//    return [self valueForKeyPath:placeholderColorKey];
//}

@end
