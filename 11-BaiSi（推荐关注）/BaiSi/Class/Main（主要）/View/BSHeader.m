//
//  BSHeader.m
//  06-BaiSi
//
//  Created by ming on 13/11/23.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSHeader.h"

@interface BSHeader()
/** logo */
@property (nonatomic, weak) UIImageView *logo;
@end

@implementation BSHeader

- (void)prepare{
    [super prepare];
    
    self.automaticallyChangeAlpha = YES;
    self.stateLabel.textColor = [UIColor yellowColor];
    self.lastUpdatedTimeLabel.hidden = YES;
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.contentMode = UIViewContentModeCenter;
    logo.image = [UIImage imageNamed:@"MainTitle"];
    [self addSubview:logo];
    self.logo = logo;
    
    // 修改那个刷新箭头
    self.arrowView.image = [UIImage imageNamed:@"MainTitle"];

}

- (void)placeSubviews{
    [super placeSubviews];
    
    self.logo.frame = CGRectMake(0, -60, self.width, 60);
}

@end
