//
//  UIImage+MGImage.m
//  06-BaiSi
//
//  Created by ming on 13/11/26.
//  Copyright © 2013年 ming. All rights reserved.
/**
 *  改分类封装了拉伸图片、加载原始图片以及生成圆形图片等方法
 */

#import "UIImage+MGImage.h"

@implementation UIImage (MGImage)

/** 加载拉伸中间1个像素图片 */
- (instancetype)mg_stretchableImage
{
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}

/** 提供一个加载原始图片方法 */
+ (instancetype)mg_imageNamedWithOriganlMode:(NSString *)imageName
{
    // 加载原始图片
    UIImage *selImage = [UIImage imageNamed:imageName];
    
    // imageWithRenderingMode:返回每一个没有渲染图片给你
    return  [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/** 对象方法 用drawRect方法生成一张圆形图片 */
- (instancetype)mg_circleImage
{
    // 1.开启位图上下文
    UIGraphicsBeginImageContext(self.size);
    
    // 2.添加一个圆(贝瑟尔曲线画圆)
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.裁剪图片
    [path addClip];
    [path stroke];
    
    // 4.将图片绘制到当前
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    // 5.获取当前图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.结束图文上下文
    UIGraphicsEndImageContext();
    
    // 7.返回一张图片
    return image;
}

/** 类方法 用drawRect方法生成一张圆形图片 */
+ (instancetype)mg_circleImageName:(NSString *)name
{
    return [[UIImage imageNamed:name] mg_circleImage];
}

/*
//- (instancetype)mg_circleImage1{
//    // 开启位图上下文
//    UIGraphicsBeginImageContext(self.size);
//    
//    // 开启上下文
//    CGContextRef  c = UIGraphicsGetCurrentContext();
//    
////    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
////    // 添加一个圆
////    CGContextAddEllipseInRect(c, rect);
////    CGContextClosePath(c);
////    // 裁剪图片
////    CGContextClip(UIGraphicsGetCurrentContext());
//    
//    // 将图片绘制到当前
//    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
//    
//    // 获取当前图片
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // 结束图文上下文
//    UIGraphicsEndImageContext();
//    
//    // 返回一张图片
//    return image;
//}
*/

@end
