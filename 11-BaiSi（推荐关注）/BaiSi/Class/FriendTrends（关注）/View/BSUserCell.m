//
//  BSUserCell.m
//  06-BaiSi
//
//  Created by ming on 16/1/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "BSUserCell.h"
#import "BSFollowUser.h"

@interface BSUserCell()
/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
/** 用户的昵称 */
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
/** 此用户的被关注数量 */
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation BSUserCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(BSFollowUser *)user{
    _user = user;
    
    [self.headerView mg_setHeader:user.header];
    
    self.screenNameLabel.text = user.screen_name;
    if (user.fans_count > 10000) {
        self.fansCountLabel.text = [NSString stringWithFormat:@"%.1f万",user.fans_count/10000.0];
    }else{
        self.fansCountLabel.text = [NSString stringWithFormat:@"%zd",user.fans_count];
    }
}

@end
