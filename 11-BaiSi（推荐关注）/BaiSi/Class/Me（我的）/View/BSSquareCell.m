//
//  BSSquareCell.m
//  04-BaiSi
//
//  Created by ming on 13/12/21.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSSquareCell.h"
#import "BSSquareItem.h"
#import <UIImageView+WebCache.h>

@interface BSSquareCell ()
/** 照片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 名字 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BSSquareCell

- (void)awakeFromNib {
    // Initialization code
}

/** 重写模型set方法 */
- (void)setSquareItem:(BSSquareItem *)squareItem{
    // 重写模型
    _squareItem = squareItem;
    
    // 名字
    _nameLabel.text = squareItem.name;
    
    // 图片
    [_iconView sd_setImageWithURL:[NSURL URLWithString:squareItem.icon]];
    

}

@end
