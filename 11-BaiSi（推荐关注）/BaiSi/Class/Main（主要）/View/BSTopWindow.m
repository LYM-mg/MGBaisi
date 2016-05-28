//
//  BSTopWindow.m
//  06-BaiSi
//
//  Created by ming on 15/12/29.
//  Copyright © 2015年 ming. All rights reserved.
/**
 *     这个实现方案修复了之前的BUG 能随着屏幕旋转，然后横屏的时候点击状态栏点击状态
 *  栏也可以实现回到顶部 (但是当前百思项目不支持横屏，所以无法判断)
 
 *  新问题： 
 *          此方案仍有问题，最新iOS9.0新特性，返回“之前的运用这个功能”如果使用自
 *  己自定义的window则会挡住该功能的实现
 
 *  思考：
 *
 */

#import "BSTopWindow.h"
#import "BSTopViewController.h"

static UIWindow *topWindow_;

@implementation BSTopWindow

/**
 *  事件传递（不能处理的事件，直接返回）
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    // 返回nil：代表这个窗口无法处理这个事件
    if (point.y > 20) return nil;
//    if (point.y<20 && point.x<30) return nil;
    // 返回部位nil：按系统默认做法处理
    return [super hitTest:point withEvent:event];
}

/**
 *  显示顶部窗口
 */
+ (void)show{
      /*
     1.窗口级别越高，就越显示在顶部
     2.如果窗口级别一样，那么后面出来的窗口会显示在顶部
     UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
     */
    /// 1.创建顶部窗口
    topWindow_ = [[self alloc] init];
    topWindow_.windowLevel = UIWindowLevelStatusBar;
//    topWindow_.frame = CGRectMake(0, 0, BSScreenW, 200);
//    topWindow_.alpha = 0.2;
//    topWindow_.backgroundColor = [UIColor orangeColor];
    topWindow_.frame = [UIScreen mainScreen].bounds;
    topWindow_.rootViewController = [[BSTopViewController alloc] init];
    topWindow_.backgroundColor = [UIColor clearColor];
    topWindow_.hidden = NO;
    
    // 只需要拉伸宽度即可  也拉伸高度的话就会出现问题(默认就是拉伸宽度和高度的)
    topWindow_.rootViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topWindow_.rootViewController.view.frame = CGRectMake(0, 0, BSScreenW, 20);
//    topWindow_.rootViewController.view.backgroundColor = [UIColor purpleColor];

    /// 2.添加点按手势
    [topWindow_ addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topWindowClick)]];
//    topWindow_.frame = [UIApplication sharedApplication].windows
}

/**
 *  监听手势tap的点击
 */
+ (void)topWindowClick{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self seekAllScrollViewInView:keyWindow];
}

/**
 *  寻找keyWindow下所有的ScrollView
 */
+ (void)seekAllScrollViewInView:(UIView *)view{
    // 递归 这样就可以获得所有的View
    for (UIView *subView in view.subviews) {
        [self seekAllScrollViewInView:subView];
    }
    
    // 是否是ScrollView    不是，直接返回
    if (![view isKindOfClass:[UIScrollView class]]) return;
    UIScrollView *scrollView = (UIScrollView *)view;
    
    // 判断ScrollView是否跟窗口有重叠  没有重叠，直接返回
    if(![scrollView intersectsOtherView:nil]) return;
    
    // 是ScrollView滚动到最前面（包括内边距）
    
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    /// 这样也可以滚动到最前面（指的是内容）
//    CGPoint offset = scrollView.contentOffset;
//    offset.y = -scrollView.contentInset.top;
//    scrollView.contentOffset = offset;
//    [scrollView setContentOffset:offset animated:YES];
}

@end
