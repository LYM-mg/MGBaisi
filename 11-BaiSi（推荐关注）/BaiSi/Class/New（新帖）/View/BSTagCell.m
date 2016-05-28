//
//  BSTagCell.m
//  02-BaiSi
//
//  Created by ming on 13/12/18.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSTagCell.h"
#import "BSTagItem.h"
#import <UIImageView+WebCache.h>

@interface BSTagCell ()
/** 推荐标签的图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconVeiw;
/** 主题名字 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 关注度 */
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
/** 订阅按钮 */
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;

@end

@implementation BSTagCell
// 订阅按钮的点击
- (IBAction)subscribeBtnClick:(UIButton *)sender {
}

- (void)awakeFromNib {
    // 设置内边距
    self.separatorInset = UIEdgeInsetsZero;
    
    // 清除系统添加的约束
    self.layoutMargins = UIEdgeInsetsZero;
}

- (void)setTagItem:(BSTagItem *)tagItem{
    _tagItem = tagItem;
    
    self.nameLabel.text = tagItem.theme_name;
    if (tagItem.sub_number > 10000) {
        self.subLabel.text = [NSString stringWithFormat:@"%.1f万人关注",tagItem.sub_number/10000.0];
    }else if (tagItem.sub_number > 1000){
        self.subLabel.text = [NSString stringWithFormat:@"%.1f千人关注",tagItem.sub_number/1000.0];
    }else{
        self.subLabel.text = [NSString stringWithFormat:@"%ld人关注",tagItem.sub_number];
    }

    // 设置图片
    [self.iconVeiw mg_setHeader:tagItem.image_list];
}

@end
