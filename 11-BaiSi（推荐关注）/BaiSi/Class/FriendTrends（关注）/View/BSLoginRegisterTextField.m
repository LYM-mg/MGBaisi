//
//  BSLoginRegisterTextField.m
//  02-BaiSi
//
//  Created by ming on 13/12/19.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSLoginRegisterTextField.h"


@implementation BSLoginRegisterTextField

- (void)awakeFromNib{
    // 设置光标
    self.tintColor = [UIColor whiteColor];
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
//    self.placeholder = @"dsa";
}

/**
 *  成为焦点的时候调用（弹出当前文本框对应的键盘的时候调用）
 */
 - (BOOL)becomeFirstResponder{
    [self setValue:[UIColor whiteColor] forKeyPath:@"placeholderLabel.textColor"];
    return  [super becomeFirstResponder];
}

/**
 *  失去焦点的时候调用（退出当前文本框对应的键盘的时候调用）
 */
- (BOOL)resignFirstResponder{
    [self setValue:[UIColor lightGrayColor] forKeyPath:@"placeholderLabel.textColor"];
    return [super resignFirstResponder];
}



@end
