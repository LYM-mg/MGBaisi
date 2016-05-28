//
//  BSFooter.m
//  06-BaiSi
//
//  Created by ming on 13/11/25.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSFooter.h"

@interface BSFooter ()
/** logo */
@property (nonatomic, weak) UIImageView *logo;
@end

@implementation BSFooter

- (void)prepare{
    [super prepare];
    // 是否需要自动隐藏
    self.automaticallyHidden = YES;
    
    // 是否需要自动刷重新
    self.automaticallyRefresh = NO;
    
    // 设置文字
    self.stateLabel.text = @"明哥帮你加载";
    self.stateLabel.textColor = [UIColor redColor];

    UIImageView *logo = [[UIImageView alloc] init];
    logo.contentMode = UIViewContentModeCenter;
    logo.image = [UIImage imageNamed:@"MainTitle"];
    [self  addSubview:logo];
    self.logo = logo;
//    logo.frame = CGRectMake(0, 60, self.width, 60);
    
}

-  (void)placeSubviews{
    [super placeSubviews];
    self.logo.frame = CGRectMake(0, 60, self.width, 60);
}

@end
