//
//  BSTitleButton.m
//  04-BaiSi
//
//  Created by ming on 13/11/22.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSTitleButton.h"

@implementation BSTitleButton

// 在这个方法中初始化一些东西（使用纯代码创建的时候就会调用这个方法）
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 文字大小
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 亮灰色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 红色
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}

// 取消高亮状态(只需要重写这个方法即可)
- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
