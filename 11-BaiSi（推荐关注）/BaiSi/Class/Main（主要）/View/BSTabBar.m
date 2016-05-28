//
//  BSTabBar.m
//  BaiSi
//
//  Created by ming on 13/12/17.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSTabBar.h"


@interface BSTabBar ()

/** 发布按钮 */
@property (nonatomic,strong) UIButton *plusButton;
/** 记录上一次点击过的按钮的Tag */
@property (nonatomic,assign) NSInteger previousClicktag;
/** 记录上一次点击过的按钮 */
@property (nonatomic,strong) UIControl *previousClickTaBarButton;

@end

@implementation BSTabBar
/// 苹果也是懒加载的
// 懒加载plusButton并初始化该按钮
- (UIButton *)plusButton{
    if (!_plusButton) {
        _plusButton = [[UIButton alloc] init];

        [_plusButton setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [_plusButton setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        [_plusButton sizeToFit];
        
        [self addSubview:_plusButton];
        
        // 监听按钮的点击
        [_plusButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusButton;
}

// 重新布局TabBar的子控件
- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat width = self.width/( self.items.count + 1);
    CGFloat height = self.height;
    CGFloat x = 0;
    CGFloat y = 0;
    NSInteger i = 0;
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                if (i==2) {
                    i++;
                }
                x = i*width;
                tabBarButton.frame = CGRectMake(x, y, width, height);
                i++;
            
            tabBarButton.tag = i;
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            /// 短时间内连续点击，类似于鼠标的双击事件
//             [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchDownRepeat];
        }
    }
    
    // 计算plusButton的位置
    self.plusButton.center = CGPointMake(self.width*0.5, self.height*0.5);
}

#pragma mark - 操作
// 监听按钮的点击
- (void)plusButtonClick{
    if (self.operationBlock) {
        self.operationBlock();
    }
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton{
    if (self.previousClicktag == tabBarButton.tag) {
        // 告诉其他人（按钮呗重复点击了）
        [[NSNotificationCenter defaultCenter] postNotificationName:BSTabBarButtonRepeatClickNotification object:nil];
    }
    self.previousClicktag = tabBarButton.tag;
}

@end
