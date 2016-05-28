//
//  BSTopicPictureView.m
//  06-BaiSi
//
//  Created by ming on 15/12/27.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSTopicPictureView.h"
#import "BSTopicItem.h"
#import <UIImageView+WebCache.h>
#import "BSSeeBigPicureViewController.h"

@interface BSTopicPictureView ()
/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** 左上角gif图片 */
@property (weak, nonatomic) IBOutlet UIButton *gifView;
/** 底部View */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation BSTopicPictureView

- (void)awakeFromNib{
    // 1.图片默认不能交互（所以要设置userInteractionEnabled = YES）
    self.imageView.userInteractionEnabled = YES;
    
    // 2.给图片添加点按手势
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClickSeeBigPicture)]];
}

- (void)setTopic:(BSTopicItem *)topic{
    _topic = topic;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1]];
    
    self.gifView.hidden = !topic.is_gif; // 取决于是否是gif图片
    
    self.bottomView.hidden = !topic.isBigPicture; // 取决于是否是大图图片
    
    // 根据是否大图设置图片模式
    if (topic.isBigPicture){
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    }else{
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = NO;
    }
}

#pragma mark - 操作
/*** 点击查看大图 **/
- (void)buttonClickSeeBigPicture{
    BSSeeBigPicureViewController *bigPictureVC = [[BSSeeBigPicureViewController alloc] init];
    bigPictureVC.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:bigPictureVC animated:NO completion:nil];
}

/** 点击查看大图 */
- (IBAction)buttonDidClickLookLagrPicture:(id)sender {
    
}


@end
