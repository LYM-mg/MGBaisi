//
//  BSCategory.h
//  06-BaiSi
//
//  Created by ming on 16/1/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSCategory : NSObject
/** 用户id */
@property (nonatomic,copy) NSString *ID;
/** 名字 */
@property (nonatomic,copy) NSString *name;
/** 发过的帖子总数 */
@property (nonatomic,copy) NSString *count;

/** 存放用户的数组 */
@property (nonatomic,strong) NSMutableArray *users;
/** 右边当前页码 */
@property (nonatomic, assign) NSInteger page;
/** 右边的总用户数量 */
@property (nonatomic, assign) NSInteger total;

/*
 list =     (
 {
 count = 79;
 id = 9;
 name = "\U7535\U53f0";
 },
 */
@end
