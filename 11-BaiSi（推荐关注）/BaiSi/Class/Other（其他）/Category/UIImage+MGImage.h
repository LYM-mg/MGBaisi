//
//  UIImage+MGImage.h
//  06-BaiSi
//
//  Created by ming on 13/11/26.
//  Copyright © 2013年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MGImage)

/** 提供一个加载原始图片方法 */
+ (instancetype)mg_imageNamedWithOriganlMode:(NSString *)imageName;

/** 加载拉伸中间1个像素图片 */
- (instancetype)mg_stretchableImage;

/** 对象方法 用drawRect方法生成一张圆形图片 */
- (instancetype)mg_circleImage;

/** 类方法 用drawRect方法生成一张圆形图片 */
+ (instancetype)mg_circleImageName:(NSString *)name;

@end
