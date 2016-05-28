//
//  BSTopicVideoView.h
//  06-BaiSi
//
//  Created by ming on 15/12/27.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSTopicItem;
@interface BSTopicVideoView : UIView
/** 模型 */
@property (nonatomic,strong) BSTopicItem *topic;

/** 播放视频的操作 */
@property (nonatomic, assign) void(^operationBlock)(BSTopicItem *topic);

@end
