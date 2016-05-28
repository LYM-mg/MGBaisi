//
//  BSFriendTrendsController.m
//  BaiSi
//
//  Created by ming on 13/12/17.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSFriendTrendsController.h"
#import "BSLoginController.h"
#import "BSRecommendFriendViewController.h"


@interface BSFriendTrendsController ()
@property (weak, nonatomic) IBOutlet UITextField *ceshiText;

@end

@implementation BSFriendTrendsController

- (void)viewDidLoad {
    
    self.ceshiText.placeholderColor = [UIColor redColor];
    self.ceshiText.placeholder = @"明哥威武";
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithBackgroundImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(leftItemClick)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - 操作
// 导航条左边点击
- (void)leftItemClick{
    BSRecommendFriendViewController *recommendFriendVC = [[BSRecommendFriendViewController alloc] init];
    [self.navigationController pushViewController:recommendFriendVC animated:YES];
}

// 导航条右边点击
- (void)rightItemClick{
    
}

// 登录注册按钮的点击
- (IBAction)loginDidClick {
    BSLoginController *loginVC = [[BSLoginController alloc] init];
    
    [self presentViewController:loginVC animated:YES completion:nil];
}


@end
