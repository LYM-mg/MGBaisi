//
//  BSAdItem.h
//  02-BaiSi
//
//  Created by ming on 13/12/18.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSAdItem : NSObject
/** 图片URL */
@property (nonatomic,copy) NSString *w_picurl;
/** 点击图片的回调网址 */
@property (nonatomic,copy) NSString *ori_curl;
/** 宽 */
@property (nonatomic, assign) NSInteger w;
/** 高 */
@property (nonatomic, assign) NSInteger h;


@end
