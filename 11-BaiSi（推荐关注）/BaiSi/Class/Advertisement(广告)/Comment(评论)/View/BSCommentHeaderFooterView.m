//
//  BSCommentHeaderFooterView.m
//  06-BaiSi
//
//  Created by ming on 15/12/28.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSCommentHeaderFooterView.h"


@implementation BSCommentHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor darkGrayColor];
        
        self.contentView.backgroundColor = BSGlobalBgColor;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 在layoutSubviews方法中覆盖对子控件的一些设置
    self.textLabel.font = BSCommentSectionHeaderFont;
    
    // 设置label的x值
    self.textLabel.x = BSCommandMargin * 0.5;
}


@end
