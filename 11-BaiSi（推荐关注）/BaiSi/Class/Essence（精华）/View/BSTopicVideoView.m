//
//  BSTopicVideoView.m
//  06-BaiSi
//
//  Created by ming on 15/12/27.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSTopicVideoView.h"
#import <UIImageView+WebCache.h>
#import "BSTopicItem.h"
//#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AFNetworkReachabilityManager.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BSTabBarController.h"

@interface BSTopicVideoView ()
/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 总共播放次数 */
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
/** 视频时长 */
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;

@end

@implementation BSTopicVideoView


- (void)setTopic:(BSTopicItem *)topic{
    //    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    //    if (mgr.reachableViaWiFi) { // WIFI
    //        [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1]];
    //    } else if (mgr.reachableViaWWAN) { // 手机自带网络
    //        [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image0]];
    //    } else { // 上不了网
    //        self.imageView.image = nil; // 清空循环利用过来的图片
    //    }
    
    _topic = topic;
    if (self.topic.playcount > 10000) {
        self.playCountLabel.text = [NSString stringWithFormat:@"%.1f万播放",self.topic.playcount/10000.0];
    }else{
        self.playCountLabel.text = [NSString stringWithFormat:@"%zd",self.topic.playcount];
    }
    
    self.videoTimeLabel.text = [LYMTimeTool getFormatTimeWithTimeInterval:self.topic.videotime];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image2]];

}

/** 点击按钮开始播放视频 */
- (IBAction)butttonDidClickPlay:(id)sender {
    /// iOS9的做法
//    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:self.topic.videouri]];
//    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
//    playerVC.player = player;
////    [playerVC.player play];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVC animated:YES completion:nil];
    
    /// IOS9之前的做法
    MPMoviePlayerViewController *movieVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.topic.videouri]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentMoviePlayerViewControllerAnimated:movieVC];
}

//- (void)dealloc{
//    BSLogFunc
//}


@end
