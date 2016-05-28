//
//  BSCommentCell.h
//  06-BaiSi
//
//  Created by ming on 15/12/28.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSComment;

@interface BSCommentCell : UITableViewCell
/** 热评模型 */
@property (nonatomic,strong) BSComment *comment;

@end
