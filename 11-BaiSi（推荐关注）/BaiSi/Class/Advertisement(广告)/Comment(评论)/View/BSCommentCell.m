//
//  BSCommentCell.m
//  06-BaiSi
//
//  Created by ming on 15/12/28.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSCommentCell.h"
#import "BSComment.h"
#import "BSUser.h"
#import <AVFoundation/AVFoundation.h>

@interface BSCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;
/** 播放声音的播放器 */
@property (nonatomic,strong) AVPlayer *player;
@end

@implementation BSCommentCell

- (void)awakeFromNib
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setComment:(BSComment *)comment{
    _comment = comment;
    _comment = comment;
    
    self.usernameLabel.text = comment.user.username;
    self.contentLabel.text = comment.content;
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd", comment.like_count];
    [self.profileImageView mg_setHeader:comment.user.profile_image];
    
    NSString *sexImageName = [comment.user.sex isEqualToString:BSUserSexMale] ? @"Profile_manIcon" : @"Profile_womanIcon";
    self.sexView.image =  [UIImage imageNamed:sexImageName];
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''", comment.voicetime] forState:UIControlStateNormal];
    } else {
        self.voiceButton.hidden = YES;
    }
}

- (IBAction)playVoiceClick {
    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.comment.voiceuri]];
    [self.player play];
}
@end
