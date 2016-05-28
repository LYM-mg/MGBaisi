//
//  BSTabBar.h
//  BaiSi
//
//  Created by ming on 13/12/17.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTabBar : UITabBar

/** 保存点击plusButton按钮之后要执行的代码 */
@property (nonatomic,strong) void(^operationBlock)();

@end
