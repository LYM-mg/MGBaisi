//
//  BSCommentViewController.h
//  06-BaiSi
//
//  Created by ming on 15/12/28.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSTopicItem;

@interface BSCommentViewController : UIViewController
/** 模型 */
@property (nonatomic,strong) BSTopicItem *topic;
@end
