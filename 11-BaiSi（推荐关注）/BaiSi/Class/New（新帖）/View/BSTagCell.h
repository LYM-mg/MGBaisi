//
//  BSTagCell.h
//  02-BaiSi
//
//  Created by ming on 13/12/18.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSTagItem;
@interface BSTagCell : UITableViewCell
/** 模型 */
@property (nonatomic,strong) BSTagItem *tagItem;
@end
