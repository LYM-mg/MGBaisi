//
//  BSSquareItem.h
//  04-BaiSi
//
//  Created by ming on 13/12/21.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSSquareItem : NSObject
/*
 android = "";
 icon = "http://img.spriteapp.cn/ugc/2013/05/20/150532_5078.png";
 id = 28;
 ipad = "";
 iphone = "";
 market = "";
 name = "\U5ba1\U8d34";
 url = "mod://BDJ_To_Check";
 */
/** 图片 */
@property (nonatomic,copy) NSString *icon;
/** 名字 */
@property (nonatomic,copy) NSString *name;
/** 跳转链接 */
@property (nonatomic,copy) NSString *url;

@end
