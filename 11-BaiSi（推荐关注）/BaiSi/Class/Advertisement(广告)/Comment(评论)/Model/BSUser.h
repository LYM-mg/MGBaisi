//
//  BSUser.h
//  06-BaiSi
//
//  Created by ming on 15/12/28.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUser : NSObject

/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 性别 m(male) f(female) */
@property (nonatomic, copy) NSString *sex;

@end
