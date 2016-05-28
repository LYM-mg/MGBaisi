//
//  BSLoginVeiw.m
//  02-BaiSi
//
//  Created by ming on 13/12/19.
//  Copyright © 2015年 ming. All rights reserved.
// 

#import "BSLoginVeiw.h"

@implementation BSLoginVeiw

/** 从Xib快速创建 */
+ (instancetype)loginViewWithXib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

/** 从Xib快速创建 */
+ (instancetype)registerViewWithXib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    
}

@end
