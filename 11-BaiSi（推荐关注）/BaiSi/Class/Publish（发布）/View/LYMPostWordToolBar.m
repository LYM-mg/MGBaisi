//
//  LYMPostWordToolBar.m
//  04-百思不得姐-发布
//
//  Created by ming on 15/12/10.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "LYMPostWordToolBar.h"
#import "LYMAddTagViewController.h"
#import "BSNavigationController.h"

@interface LYMPostWordToolBar ()
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation LYMPostWordToolBar

+ (instancetype)toolbar{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    plusBtn.y = 2;
    plusBtn.width = 30;
    plusBtn.height = 30;
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [plusBtn addTarget:self action:@selector(plusBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:plusBtn];
}

// 监听“+“好按钮的点击
- (void)plusBtnClcik{
    /**
        modal: A --> B
        A.presentedViewController = B
        B.presentingViewController = A
    */
    
    LYMAddTagViewController *addTagVC = [[LYMAddTagViewController alloc] init];
    BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:addTagVC];
    
    // 拿出“窗口控制器”modal出来的发表文字所在的导航控制器
    BSNavigationController *vc = (BSNavigationController *)self.window.rootViewController;
    [vc.childViewControllers.firstObject presentViewController:nav animated:YES completion:nil];
    
//    UIViewController *vc = self.window.rootViewController.presentedViewController;
//    [vc presentViewController:nav animated:YES completion:nil];
//    YMLog(@"%@--%@",vc,vc.childViewControllers);
    
//    UIViewController *vc = self.window.rootViewController.presentedViewController;
//    UIViewController *vc1 = self.window.rootViewController.presentingViewController;
//    YMLog(@"%@--%@",vc,vc1);
}

@end
