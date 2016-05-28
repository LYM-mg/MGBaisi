//
//  BSFollowUser.h
//  06-BaiSi
//
//  Created by ming on 16/1/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSFollowUser : NSObject
/** 用户的昵称 */
@property (nonatomic,copy) NSString *screen_name;
/** 此用户的被关注数量 */
@property (nonatomic, assign) NSInteger fans_count;
/** 用户头像的url */
@property (nonatomic,copy) NSString *header;


/*
{
    info =     {
        "last_coord" = 9300737;
        "last_flag" = "top_list";
    };
    "top_list" = (
                  {
                      "fans_count" = 55254;
                      gender = m;
                      header = "http://wimg.spriteapp.cn/profile/large/2015/07/12/55a275d48591f_mini.jpg";
                      id = 437;
                      introduction = "\U8fd9\U4e2a\U7528\U6237\U5f88\U61d2\Uff0c\U4ec0\U4e48\U4e5f\U6ca1\U6709\U7559\U4e0b\Uff01";
                      "is_follow" = 0;
                      "plat_flag" = 2;
                      "screen_name" = "Gif\U5c0f\U89c6\U9891\U5927\U53d4";
                      "social_name" = "";
                      "tiezi_count" = 0;
                      uid = 437;
                  }
*/

@end
