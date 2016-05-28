//
//  LYMPublishButton.m
//  04-百思不得姐-发布
//
//  Created by ming on 15/12/8.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "LYMPublishButton.h"

@implementation LYMPublishButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 设置字体颜色
        [self setTitleColor:BSColor(10, 10, 10) forState:UIControlStateNormal];
        
        // 让文字居中显示
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.y = self.height * 0.15;
    self.imageView.centerX = self.width * 0.5;
    
    // 调整文字位置
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
}

@end
