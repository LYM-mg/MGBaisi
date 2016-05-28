
//
//  LYMAddTagButton.m
//  04-百思不得姐-发布
//
//  Created by ming on 15/12/11.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "LYMAddTagButton.h"

@implementation LYMAddTagButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.x = BSSmallCommandMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + BSSmallCommandMargin;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
    
    self.width += 3 * BSSmallCommandMargin;
    self.height = BSTagHight;
}

@end
