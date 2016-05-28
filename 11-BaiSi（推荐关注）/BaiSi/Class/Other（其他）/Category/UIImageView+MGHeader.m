//
//  UIImageView+MGHeader.m
//  06-BaiSi
//
//  Created by ming on 13/12/26.
//  Copyright © 2013年 ming. All rights reserved.
/**
 *  前提：必须导入 #import <UIImageView+WebCache.h>
 *  应用场景：当多个地方同时用到同一种形状的图片（比如：都为圆形图片/方形图片）
 *
 *  用到圆形图片时：一般与UIImage+MGImage结合使用
 */

#import "UIImageView+MGHeader.h"
#import <UIImageView+WebCache.h>
#import "UIImage+MGImage.h"

@implementation UIImageView (MGHeader)
//
- (void)mg_setHeader:(NSString *)url{
    // 占位图片
    UIImage *placeholder = [UIImage mg_circleImageName:@"defaultUserIcon"];
    // 下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return ;
        //// 1.圆形图片
        self.image = [image mg_circleImage];
    }];
    
    //// 2.方形图片
//    UIImage *placeholder = [UIImage imageNamed:@"defaultUserIcon"];
//    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
}

@end
