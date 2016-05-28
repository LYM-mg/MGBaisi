//
//  BSTagItem.h
//  02-BaiSi
//
//  Created by ming on 13/12/18.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTagItem : NSObject

/*
 返回值字段	字段类型	字段说明
 is_sub	int	是否含有子标签
 theme_id	string	此标签的id
 theme_name	string	标签名称
 sub_number	string	此标签的订阅量
 is_default	int	是否是默认的推荐标签
 image_list	string	推荐标签的图片url地址
 */

/** 此标签的订阅量 */
@property (nonatomic,assign) NSInteger sub_number;
/** 标签名称 */
@property (nonatomic,copy) NSString *theme_name;
/** 推荐标签的图片url地址 */
@property (nonatomic,copy) NSString *image_list;



@end
