//
//  BSTopicVoiceView.m
//  06-BaiSi
//
//  Created by ming on 15/12/27.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSTopicVoiceView.h"
#import "BSTopicItem.h"
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

static AVPlayer * player_;
static UIButton *lastPlayButton_;
static BSTopicItem *lastTopic_;

@interface BSTopicVoiceView ()<AVAudioPlayerDelegate>

/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 总共播放次数 */
@property (weak, nonatomic) IBOutlet UILabel *playCountLable;
/** 音频时长 */
@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;
/** 上一个模型 */
//@property (nonatomic,strong) BSTopicItem *lastTopic;
/** 上一个按钮 */
@property (weak, nonatomic) UIButton *lastPlayButton;
/** 播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playButton;


@end

@implementation BSTopicVoiceView

- (void)setTopic:(BSTopicItem *)topic{
    _topic = topic;
    if (self.topic.playcount > 10000) {
        self.playCountLable.text = [NSString stringWithFormat:@"%.1f万播放",self.topic.playcount/1000.0];
    }else{
        self.playCountLable.text = [NSString stringWithFormat:@"%zd播放",self.topic.playcount];
    }
    
    self.voiceTimeLabel.text  = [LYMTimeTool getFormatTimeWithTimeInterval:topic.voicetime];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image2]];
    
    // 设置按钮照片
//    [lastPlayButton_ setImage:[UIImage imageNamed:lastPlayButton_.isSelected ? @"playButtonPause":@"playButtonPlay"] forState:UIControlStateNormal];
//    [self.playButton setImage:[UIImage imageNamed:topic.voicePlaying ? @"playButtonPause":@"playButtonPlay"] forState:UIControlStateNormal];

    [self.playButton setImage:[UIImage imageNamed:topic.voicePlaying ? @"playButtonPause":@"playButtonPlay"] forState:UIControlStateNormal];
//    [lastPlayButton_ setImage:[UIImage imageNamed:lastTopic_.voicePlaying && topic.voicePlaying? @"playButtonPause":@"playButtonPlay"] forState:UIControlStateNormal];
    NSLog(@"top.voicePlaying = %d",topic.voicePlaying);

//    self.playButton.selected = topic.voicePlaying;
//    self.lastPlayButton.selected = self.topic.voicePlaying;
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化player
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.voiceuri]];
        player_ = [AVPlayer playerWithPlayerItem:playerItem];
    });
}


/** 点击按钮开始播放声音 */
- (IBAction)buttonDidClickPlaySound:(UIButton *)playButton {
    playButton.selected = !playButton.isSelected;
    lastPlayButton_.selected = !lastPlayButton_.isSelected;
    if (lastTopic_ != self.topic) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.voiceuri]];
        
        [player_ replaceCurrentItemWithPlayerItem:playerItem];
        [player_ play];
        lastTopic_.voicePlaying = NO;
        self.topic.voicePlaying = YES;
        
        [lastPlayButton_ setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
        
    }else{
        if(lastTopic_.voicePlaying){
            [player_ pause];
            self.topic.voicePlaying = NO;
            [playButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
        }else{
            [player_ play];
            self.topic.voicePlaying = YES;
            [playButton setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
        }
    }
    lastTopic_ = self.topic;
    lastPlayButton_ = playButton;
    
    
    
//    playButton.selected = !playButton.isSelected;
////    lastPlayButton_.selected = !lastPlayButton_.isSelected;
//    if (self.lastTopic != self.topic) {
//        if(!self.lastTopic.voicePlaying){
//            self.lastTopic.voicePlaying = NO;
//        }
//        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.voiceuri]];
//
//        [player_ replaceCurrentItemWithPlayerItem:playerItem];
//        [player_ play];
//        self.topic.voicePlaying = YES;
//
//        [lastPlayButton_ setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
//        [playButton setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
//        
//    }else{
//        if(self.lastTopic.voicePlaying){
//            [player_ pause];
//            self.topic.voicePlaying = NO;
//            [playButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
//        }else{
//            [player_ play];
//            self.topic.voicePlaying = YES;
//            [playButton setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
//        }
//    }
//    self.lastTopic = self.topic;
//    lastPlayButton_ = playButton;
    
//    self.playButton = playButton;


}

@end
