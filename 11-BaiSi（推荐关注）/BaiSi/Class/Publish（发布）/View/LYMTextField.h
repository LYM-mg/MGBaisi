//
//  LYMTextField.h
//  05-百思不得姐-发布标签封装
//
//  Created by ming on 15/12/12.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYMTextField : UITextField

/** <#注释#> */
@property (nonatomic, copy) void (^deleteBackwardOperation)();


@end
