//
//  BSCategoryCell.m
//  06-BaiSi
//
//  Created by ming on 16/1/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "BSCategoryCell.h"
#import "BSCategory.h"

@interface BSCategoryCell ()
/** 左边选中的指示器 */
@property (weak, nonatomic) IBOutlet UIView *IndicatorView;

@end

@implementation BSCategoryCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.backgroundColor = [UIColor clearColor];
}

- (void)setCategory:(BSCategory *)category{
    _category = category;
    self.textLabel.text = category.name;
    
    /// 当selectionStyle != None的cell选中的时候,里面的子控件都会变成高亮highLighter状态，
    // 前提是：这个cell的self.selectionStyle ！= UITableViewCellSelectionStyleNone;
}

/**
 *  在这里可以设置cell被选中时的状态（比如：文字颜色大小等等）
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // 设置选中和不选中时的文字颜色
    self.textLabel.textColor = selected ? [UIColor redColor] : [UIColor  darkGrayColor];
    
    // 左边选中的指示器没有选中的时候就隐藏
    self.IndicatorView.hidden = !selected;
}

@end
