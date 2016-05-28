//
//  UIImageView+MGHeader.h
//  06-BaiSi
//
//  Created by ming on 13/11/26.
//  Copyright © 2013年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MGHeader)
/**
 *  根据URL或者字符串设置图片
 */
- (void)mg_setHeader:(NSString *)url;
@end
