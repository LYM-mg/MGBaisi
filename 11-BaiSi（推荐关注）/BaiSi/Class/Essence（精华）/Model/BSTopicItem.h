//
//  BSTopicItem.h
//  06-BaiSi
//
//  Created by ming on 13/11/23.
//  Copyright © 2015年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 习惯写法
//typedef NS_ENUM (NSInteger){
//    BSTopicTypeAll = 1,  // 全部
//    BSTopicTypePicture = 10, // 图片
//    BSTopicTypeWord  =  29,  // 段子
//    BSTopicTypeVoice = 31,   // 声音
//    BSTopicTypeVideo = 41    // 视频
//}BSTopicType;

/// 苹果官方写法
typedef NS_ENUM (NSInteger,BSTopicType){
    BSTopicTypeAll = 1,  // 全部
    BSTopicTypePicture = 10, // 图片
    BSTopicTypeWord  =  29,  // 段子
    BSTopicTypeVoice = 31,   // 声音
    BSTopicTypeVideo = 41    // 视频
};

@class BSComment;

@interface BSTopicItem : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;
/** 帖子创建的时间 */
@property (nonatomic, copy) NSString *create_time;
/** 中间图片的宽度 */
@property (nonatomic, assign) NSInteger width;
/** 中间图片的高度 */
@property (nonatomic, assign) NSInteger height;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;

/** 帖子类型 */
@property (nonatomic, assign) BSTopicType type;

/** 最热评论(数组里面存放着最热评论数据) */
@property (nonatomic, strong) BSComment *top_cmt;
/** 播放次数 */
@property (nonatomic,assign) NSInteger playcount;
/** 视频的时长 */
@property (nonatomic,assign) NSInteger videotime;
/** 音频的时长 */
@property (nonatomic,assign) NSInteger voicetime;
/** 视频播放的url地址 */
@property (nonatomic,copy) NSString *videouri;
/** 音频的时长 */
@property (nonatomic,copy) NSString *voiceuri;


/** 小图片 */
@property (nonatomic, copy) NSString *image0;
/** 大图片 */
@property (nonatomic, copy) NSString *image1;
/** 中图片 */
@property (nonatomic, copy) NSString *image2;
/** 是否是gif动画 */
@property (nonatomic,assign) BOOL is_gif;


/********************* 辅助属性*********************/

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 中间内容的Frame */
@property (nonatomic, assign) CGRect centerF;
/** 是否是gif动画 */
@property (nonatomic,assign,getter=isBigPicture) BOOL bigPicture;
/** 顶➕1 */
@property (nonatomic, assign,getter=is_dingAdd) BOOL dingAdd;
/** 踩➕1 */
@property (nonatomic, assign,getter=is_caiAdd) BOOL caiAdd;
/** 声音是否在播放 */
@property (nonatomic, assign,getter=is_voicePlaying) BOOL voicePlaying;

//- (NSString *)creatTime;

/*
        info =  {
                count = 2000;
                maxid = 1450860361;
                maxtime = 1450860361;
                page = 100;
                vendor = "six.jie.c";
            };
        list = (
                {
                bimageuri = "";
                bookmark = 182;
                "cache_version" = 2;
                cai = 123;
                "cdn_img" = "http://dimg.spriteapp.cn/ugc/2015/12/23/567981617c5e7.gif";
                comment = 29;
                "create_time" = "2015-12-23 00:59:13";
                "created_at" = "2015-12-23 19:12:36";
                ding = 996;
                favourite = 182;
                gifFistFrame = "http://dimg.spriteapp.cn/ugc/2015/12/23/567981617c5e7_a_1.jpg";
                hate = 123;
                height = 264
                id = 16638099;
                image0 = "http://ww2.sinaimg.cn/mw240/005OPWbujw1ez9gvdx42mg309s07c105.gif";
                image1 = "http://ww2.sinaimg.cn/large/005OPWbujw1ez9gvdx42mg309s07c105.gif";
                image2 = "http://ww2.sinaimg.cn/bmiddle/005OPWbujw1ez9gvdx42mg309s07c105.gif";
                "is_gif" = 1;
                love = 996;
                name = "\U7231\U662f\U6211\U7684\U5168\U90e8";
                "original_pid" = 0;
                passtime = "2015-12-23 19:12:36";
                "profile_image" = "http://qzapp.qlogo.cn/qzapp/100336987/D3B3AF444F7D7C8F7C3B10CC197DA1F7/100";
                repost = 199;
                "screen_name" = "\U7231\U662f\U6211\U7684\U5168\U90e8";
                status = 4;
                t = 1450869156;
                tag = "";
                text = "\U5f53\U6708\U5149\U6492\U5728\U6211\U7684\U8138\U4e0a\Uff0c\U8bf6\U54df\U5367\U69fd(*\Uff40\U3078\U00b4*)";
                "theme_id" = 0;
                "theme_name" = "";
                "theme_type" = 0;
                themes =             (
                );
                "top_cmt" =             (
                );
                type = 10;
                "user_id" = 7286832;
                videotime = 0;
                videouri = "";
                voicelength = 0;
                voicetime = 0;
                voiceuri = "";
                "weixin_url" = "http://a.f.winapp111.com.cn/budejie/land.php?pid=16638099&wx.qq.com&appname=";
                width = 352;
            }
            */

@end
