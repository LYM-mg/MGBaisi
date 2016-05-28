//
//  BSTopicCell.m
//  06-BaiSi
//
//  Created by ming on 13/11/25.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSTopicCell.h"
#import "BSTopicItem.h"
#import <UIImageView+WebCache.h>
#import "BSTopicPictureView.h"
#import "BSTopicVoiceView.h"
#import "BSTopicVideoView.h"
#import <Social/Social.h>
#import "BSComment.h"
#import "BSUser.h"


@interface BSTopicCell ()
/*********************** 顶部 ****************************/
/** 用户的头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageVeiw;
/** 用户的名字 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 帖子的创建时间 */
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
/** 帖子正文 */
@property (weak, nonatomic) IBOutlet UILabel *text_Label;

/*********************** 最热评论 ****************************/
/** 最热评论—整体 */
@property (weak, nonatomic) IBOutlet UIView *hotCmtView;
/** 最热评论-内容 */
@property (weak, nonatomic) IBOutlet UILabel *hotCmtLabel;

/*********************** 中间内容 ****************************/
/** 中间内容（图片） */
@property (nonatomic,weak) BSTopicPictureView *pictureView;
/** 中间内容（声音） */
@property (nonatomic,weak) BSTopicVoiceView *voiceView;
/** 中间内容（视频） */
@property (nonatomic,weak) BSTopicVideoView *videoView;

/*********************** 底部 ****************************/
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 转发 */
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@end

@implementation BSTopicCell

#pragma mark - 懒加载
- (BSTopicPictureView *)pictureView{
    if (!_pictureView) {
        _pictureView = [BSTopicPictureView viewFromXib];
        
        [self.contentView addSubview:_pictureView];
    }
    return _pictureView;
}

- (BSTopicVoiceView *)voiceView{
    if (!_voiceView) {
        _voiceView = [BSTopicVoiceView viewFromXib];
        [self.contentView addSubview:_voiceView];
    }
    return _voiceView;
}

- (BSTopicVideoView *)videoView{
    if (!_videoView) {
        _videoView = [BSTopicVideoView viewFromXib];
        [self.contentView addSubview:_videoView];
    }
    return _videoView;
}

#pragma mark - 初始化
- (void)setFrame:(CGRect)frame{
    // 设置分割线
    frame.size.height -= BSCommandMargin;
    [super setFrame:frame];
}


- (void)awakeFromNib {
    // 设置背景（既然美工提供了图片就要用）
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setTopic:(BSTopicItem *)topic {
    _topic = topic;
    /*********************** 顶部 ****************************/
    [self.profileImageVeiw mg_setHeader:topic.profile_image];
    self.nameLabel.text = topic.name;
    self.createdAtLabel.text = [topic created_at];
    
    /*********************** 帖子正文 ****************************/
    self.text_Label.text = topic.text;
    
    /*********************** 中间内容 ****************************/
    if (topic.type == BSTopicTypePicture) { // 图片
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }else if (topic.type == BSTopicTypeVoice){ // 声音
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.videoView.hidden = YES;
    }else if (topic.type == BSTopicTypeVideo){ // 视频
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
    }else{ // 为什么要做这一步呢？？？ 防止循环利用
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    
    /*********************** 最热评论 ****************************/
    if (topic.top_cmt) { // 有评论
        self.hotCmtView.hidden = NO;
        
        NSString *username = topic.top_cmt.user.username; // 用户名
//        BSLog(@"%@-- %@--%@",topic.top_cmt,topic.top_cmt.user,topic.top_cmt.user.username);
        NSString *content = topic.top_cmt.content; // 评论内容
        if (topic.top_cmt.voiceuri.length) {
            content = @"[语音评论]";
        }
        self.hotCmtLabel.text = [NSString stringWithFormat:@"%@ : %@",username,content];
    } else { // 没有最热评论
        self.hotCmtView.hidden = YES;
    }
    
    /*********************** 底部 ****************************/
    [self setUpButtonTitle:_dingButton count:topic.ding placeholder:@"顶"];
    [self setUpButtonTitle:_caiButton count:topic.cai placeholder:@"踩"];
    [self setUpButtonTitle:_repostButton count:topic.repost placeholder:@"转发"];
    [self setUpButtonTitle:_commentButton count:topic.comment placeholder:@"评论"];

    // 点赞按钮
    [self.dingButton setImage:[UIImage imageNamed:topic.is_dingAdd ? @"mainCellDingClick" : @"mainCellDing"] forState:UIControlStateNormal];
    [self.dingButton setTitleColor:topic.is_dingAdd ? [UIColor redColor]:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    // 点踩按钮
    [self.caiButton setImage:[UIImage imageNamed:topic.is_caiAdd ? @"mainCellCaiClick":@"mainCellCai"] forState:UIControlStateNormal];
    [self.caiButton setTitleColor:topic.is_caiAdd ? [UIColor redColor]:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

/**
 * 设置底部View的文字
 */
- (void)setUpButtonTitle:(UIButton *)btn count:(NSInteger)count placeholder:(NSString *)placeholder{
    if (count > 10000) {
        [btn setTitle:[NSString stringWithFormat:@"%.1f万",count/10000.0] forState:UIControlStateNormal];
    }else if (count > 1){
        [btn setTitle:[NSString stringWithFormat:@"%zd",count] forState:UIControlStateNormal];
    }else{
        [btn setTitle:placeholder forState:UIControlStateNormal];
    }
}

/**
 * 布局子控件
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    BSTopicItem *topic = self.topic;
    if (topic.type == BSTopicTypePicture) {
        self.pictureView.frame = topic.centerF;
    }else if (topic.type == BSTopicTypeVoice){
        self.voiceView.frame = topic.centerF;
    }else if (topic.type == BSTopicTypeVideo){
        self.videoView.frame = topic.centerF;
    }
}

#pragma mark - 操作
// 更多
- (IBAction)moreButtonDidClick {
    // 1.创建UIAlertController
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 2.收藏按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showInfoWithStatus:@"收藏成功"];
    }]];
    
    // 3.举报按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showInfoWithStatus:@"举报成功"];
    }]];
    
    // 4.取消按钮
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    // 5.弹框
    [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

/**
 *  点赞
 */
- (IBAction)dingClick:(UIButton *)dingButtton {
    if (!self.topic.is_dingAdd && !self.topic.is_caiAdd)
    {
        self.topic.ding += 1;
        self.topic.dingAdd = YES;
        [dingButtton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [dingButtton setImage:[UIImage imageNamed:@"mainCellDingClick"] forState:UIControlStateNormal];
        [dingButtton setTitle:[NSString stringWithFormat:@"%zd",self.topic.ding] forState:UIControlStateNormal];
        
        // 添加点击按钮+1的动画
        [self addOneOnButtonWhenClick:dingButtton];
    }
    // 发送到服务器 （以后需要做）
    
}

/**
 * 点踩
 */
- (IBAction)caiClick:(UIButton *)caiButton {
    if (!self.topic.is_dingAdd && !self.topic.is_caiAdd)
    {
        self.topic.cai += 1;
        self.topic.caiAdd = YES;
        [caiButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [caiButton setImage:[UIImage imageNamed:@"mainCellCaiClick"] forState:UIControlStateNormal];
         [caiButton setTitle:[NSString stringWithFormat:@"%zd",self.topic.cai] forState:UIControlStateNormal];
        
//        UILabel *addLabel = [[UILabel alloc] init];
//        addLabel.x = caiButton.width*0.5 + 10;
//        addLabel.y = caiButton.height*0.5;
//        addLabel.font = [UIFont systemFontOfSize:30];
//        addLabel.textColor = [UIColor redColor];
//        addLabel.text = @"+1";
//        [addLabel sizeToFit];
//        [caiButton addSubview:addLabel];
//        BSLog(@"%@",NSStringFromCGRect(addLabel.frame));
//        // 添加一个点赞的动画
//        [UIView animateWithDuration:0.5 animations:^{
//            // 产生平移和缩放效果
//            addLabel.transform = CGAffineTransformMakeTranslation(caiButton.width*0.5+20, caiButton.height*0.5-50);
//            BSLog(@"%@",NSStringFromCGRect(addLabel.frame));
//            
//            addLabel.transform = CGAffineTransformScale(addLabel.transform, 1.5, 1.5);
//        } completion:^(BOOL finished) {
//            // 从父控件移除addLabel
//            [addLabel removeFromSuperview];
//        }];

        // 添加点击按钮【+1】的动画
        [self addOneOnButtonWhenClick:caiButton];
    }
}

/**
 * 点赞或点踩的【+1】操作
 * button：你要给哪个按钮 +1
 */
- (void)addOneOnButtonWhenClick:(UIButton *)button{
    // 创建一个Label
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.x = button.width*0.5;
    addLabel.y = button.height*0.3;
    addLabel.font = [UIFont systemFontOfSize:30];
    addLabel.textColor = [UIColor redColor];
    addLabel.text = @"+1";
    [addLabel sizeToFit];
    [button addSubview:addLabel];
    // 添加一个点赞的动画
    [UIView animateWithDuration:1.0 animations:^{
        // 产生平移和缩放效果
        addLabel.transform = CGAffineTransformScale(addLabel.transform, 0.5,0.5);
        addLabel.transform = CGAffineTransformTranslate(addLabel.transform,20, -20);

    } completion:^(BOOL finished) {
        // 动画完成之后要从父控件移除addLabel
        [addLabel removeFromSuperview];
    }];
}


// 转发到微博 (暂时利用系统的分享框架转发)
- (IBAction)repostButtonClick {
    // 1.首先判断新浪分享是否可用
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        return;
    }
    // 2.创建控制器，并设置ServiceType
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    
    // 3.要分享的照片
    [composeVC addImage:[UIImage imageNamed:self.topic.image1]];
    
    // 4.要分享的文字
    [composeVC setInitialText:self.topic.text];
    
    // 5.添加要分享的url
    if (self.topic.type == BSTopicTypeVideo) {
        [composeVC addURL:[NSURL URLWithString:self.topic.videouri]];
    }else if (self.topic.type == BSTopicTypeVoice){
         [composeVC addURL:[NSURL URLWithString:self.topic.voiceuri]];
    }
    
    // 6.弹出分享控制器
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:composeVC animated:YES completion:nil];
    
    // 7.监听用户点击事件
    composeVC.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultDone) {
            BSLog(@"点击了发送");
        }else{
            BSLog(@"点击了取消");
        }
    };
    
    // 首先判断SLServiceTypeFacebook分享是否可用
//    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        BSLog(@"facebook不能使用");
//        return;
//    }
    
//    // 创建分享控制器
//    SLComposeViewController *slVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//    
//    // 设置分享内容
//    [slVC setTitle:self.topic.text];
//    
//    // 弹出控制器
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:slVC animated:YES completion:nil];
//    
//    // 监听是否分享成功
//    slVC.completionHandler = ^(SLComposeViewControllerResult result){
//        if (result == SLComposeViewControllerResultDone) {
//            BSLog(@"分享成功");
//        }else if(result == SLComposeViewControllerResultCancelled){
//            BSLog(@"取消分享");
//        }
//    };
}

// 跳转到评论
- (IBAction)commentButtonClick {
    
}

@end
