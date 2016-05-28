//
//  BSUserCell.h
//  06-BaiSi
//
//  Created by ming on 16/1/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSFollowUser;

@interface BSUserCell : UITableViewCell

/** 用户模型 */
@property (nonatomic,strong) BSFollowUser *user;

@end
