//
//  BSTopicCell.h
//  06-BaiSi
//
//  Created by ming on 13/11/25.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSTopicItem;
@interface BSTopicCell : UITableViewCell
/** 模型 */
@property (nonatomic,strong) BSTopicItem *topic;
@end
