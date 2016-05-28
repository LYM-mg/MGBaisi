//
//  UITextField+LYMPlaceholderColor.m
//  03-BaiSi
//
//  Created by ming on 13/12/20.
//  Copyright © 2013年 ming. All rights reserved.
/**
 *  利用RunTime来设置占位文字的颜色
 */

#import "UITextField+LYMPlaceholderColor.h"
#import <objc/runtime.h>
//#import <objc/message.h>

// OC最喜欢懒加载,用的的时候才会去加载

// 需要给系统UITextField添加属性,只能使用runtime

static NSString *const LYMPlaceholderLabelKey = @"placeholderLabel";
static NSString *const placeholderColorName = @"placeholderColor";
@implementation UITextField (LYMPlaceholderColor)

#pragma mark - 利用RunTime动态增加属性和交换方法 =
/// 实现交换方法 （bs_setPlaceholder:和setPlaceholder:的互换）
+ (void)load{
    Method bs_setPlaceholder = class_getInstanceMethod(self, @selector(bs_setPlaceholder:));
    
    Method setPlaceholder = class_getInstanceMethod(self, @selector(setPlaceholder:));
    
    method_exchangeImplementations(setPlaceholder,bs_setPlaceholder);
}

/// 外界赋值占位颜色的时候就会调用
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    // 动态增加placeholderColor属性
    objc_setAssociatedObject(self, (__bridge const void *)(placeholderColorName), placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 设置颜色
   UILabel *placeholderLabel = [self valueForKeyPath:LYMPlaceholderLabelKey];
    placeholderLabel.textColor = placeholderColor;
}
- (UIColor *)placeholderColor{
    //    return  _placeholderColor;
    return objc_getAssociatedObject(self,(__bridge const void *)(placeholderColorName));
}

/// 外界赋值占位文字的时候会调用
- (void)bs_setPlaceholder:(NSString *)placeholder{
    // 1.设置占位文字
    [self bs_setPlaceholder:placeholder];
   
    // 2.设置占位文字颜色
    self.placeholderColor = self.placeholderColor;
}


#pragma mark - 测试RunTime动态增加属性
- (void)setName:(NSString *)name{
    // 动态增加“name”属性
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)name{
    return objc_getAssociatedObject(self, @"name");
}

@end
