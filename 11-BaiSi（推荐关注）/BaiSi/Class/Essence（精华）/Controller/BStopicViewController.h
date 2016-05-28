//
//  BStopicViewController.h
//  06-BaiSi
//
//  Created by ming on 15/12/29.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTopicItem.h"

@interface BStopicViewController : UITableViewController
/** 帖子的类型 */
// @property (nonatomic, assign) XMGTopicType type;

- (BSTopicType)type;

@end
