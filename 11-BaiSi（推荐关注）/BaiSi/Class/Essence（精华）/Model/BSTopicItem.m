//
//  BSTopicItem.m
//  06-BaiSi
//
//  Created by ming on 13/11/23.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSTopicItem.h"
#import <MJExtension.h>
#import "BSComment.h"
#import "BSUser.h"

@implementation BSTopicItem

- (NSString *)created_at{
    // 1.日期格式化
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *creat = [fmt dateFromString:_created_at];
    
    // 2.判断
    if (creat.mg_isThisYear) {          // 今年
        if (creat.mg_isToday) {         // 今天
            NSDateComponents *coms = [[NSDate date] mg_deltaFrom:creat];
            if (coms.hour > 1) {        // 几小时前
                return [NSString stringWithFormat:@"%zd小时前",coms.hour];
            }else if (coms.minute > 1){ // 几分钟前
                return [NSString stringWithFormat:@"%zd分钟前",coms.minute];
            }else{                      // 刚刚
                return @"刚刚";
            }
        }else if (creat.mg_isYesterday){// 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:creat];
        }else{                          // 今年其他日子
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:creat];
        }
    }else{                              // 非今年
        return _create_time;
    }
}

/**
 *  计算每个cell的高度
 */
- (CGFloat)cellHeight{
    // 如果_cellHeight有值就返回（其实这就是懒加载，为性能着想）
    if (_cellHeight) return _cellHeight;
        
    /******************顶部高度************************/
    _cellHeight = BSTopicCellTopHeight + BSCommandMargin;

    /******************正文高度************************/
    CGFloat textMaxW = BSScreenW - 2 * BSCommandMargin;
    _cellHeight += [self.text boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.height + BSCommandMargin;
    
    /******************中间内容高度************************/
    if (self.type != BSTopicTypeWord) { // 中间至少要显示1张图片
        
        // 中间内容(比如图片)显示出来的宽度
        CGFloat centerW = textMaxW;
        // 中间内容(比如图片)示出来的高度
        CGFloat centerH = self.height*centerW/self.width;
        if(centerH > BSScreenW) {
            centerH = 200;
            self.bigPicture = YES;
        }
        // 中间内容的frame
        _centerF = CGRectMake(BSCommandMargin, _cellHeight, centerW, centerH);
        
        _cellHeight += centerH + BSCommandMargin;
    }
    
    /******************热门评论高度************************/
    if (self.top_cmt) { // 有评论
        // 标题
        _cellHeight += BSTopicCellHotHeight;
        
        NSString *content = self.top_cmt.content; // 评论内容
        if (self.top_cmt.voiceuri.length) { // 语音评论
            content = @"[语音评论]";
        }
        
        NSString *hotText = [NSString stringWithFormat:@"%@ : %@",self.top_cmt.user.username,content];
        
        _cellHeight += [hotText boundingRectWithSize:CGSizeMake(textMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height + BSCommandMargin;
    }
    
    /******************底部高度************************/
    _cellHeight += BSTopicCellBottomHeight + BSCommandMargin;
    
    return _cellHeight;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end
