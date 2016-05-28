//
//  XMGExtensionConfig.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/20.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGExtensionConfig.h"
#import <MJExtension.h>
#import "BSTopicItem.h"
#import "BSComment.h"
#import "BSCategory.h"

@implementation XMGExtensionConfig

+ (void)load
{
    [BSTopicItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"top_cmt" : @"top_cmt[0]",
                 @"small_image" : @"image0",
                 @"middle_image" : @"image2",
                 @"large_image" : @"image1"};
    }];
    
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
    
    [BSCategory mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id"};
    }];
}

@end
