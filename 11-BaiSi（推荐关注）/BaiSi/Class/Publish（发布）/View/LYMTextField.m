//
//  LYMTextField.m
//  05-百思不得姐-发布标签封装
//
//  Created by ming on 15/12/12.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "LYMTextField.h"

@implementation LYMTextField

/**
 *  监听键盘内部删除按钮的点击
 */
- (void)deleteBackward{
    // 如果self.deleteBackwardOperation为空，不执行；否则，执行
    !self.deleteBackwardOperation ?:self.deleteBackwardOperation();
    
    [super deleteBackward];
}

@end
