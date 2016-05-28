//
//  BSThirdBitton.m
//  02-BaiSi
//
//  Created by ming on 13/12/19.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSThirdBitton.h"

@implementation BSThirdBitton

- (void)awakeFromNib{
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 设置照片
    self.imageView.y = 0;
    self.imageView.centerX = self.width*0.5;
    
    // 设置文字
    [self.titleLabel sizeToFit];
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame)+3;
    self.titleLabel.centerX = self.width * 0.5;
    
    
}

@end
