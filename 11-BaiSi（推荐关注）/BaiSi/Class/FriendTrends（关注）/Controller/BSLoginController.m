//
//  BSLoginController.m
//  02-BaiSi
//
//  Created by ming on 13/12/19.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSLoginController.h"
#import "BSLoginVeiw.h"
#import "BSThirdView.h"

@interface BSLoginController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingMargin;
@property (weak, nonatomic) IBOutlet UIView *middleVeiw;
@property (weak, nonatomic) IBOutlet UIView *bottomVeiw;

/** 登录View */
@property (nonatomic,strong) BSLoginVeiw *loginView;
/** 注册View */
@property (nonatomic,strong) BSLoginVeiw *registerView;
/** 第三方登录View */
@property (nonatomic,strong) BSThirdView *thirdView;

@end

@implementation BSLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化所有的View
    [self setupAllChildView];
}

// 初始化所有的View
- (void)setupAllChildView{
    _loginView = [BSLoginVeiw loginViewWithXib];
    _registerView = [BSLoginVeiw registerViewWithXib];
    _thirdView = [BSThirdView viewFromXib];
    
    [self.middleVeiw addSubview:_loginView];
    [self.middleVeiw addSubview:_registerView];
    [self.bottomVeiw addSubview:_thirdView];
}

// 设置所有的View的尺寸
- (void)viewDidLayoutSubviews{
    _loginView.frame = CGRectMake(0, 0, self.middleVeiw.width * 0.5, self.middleVeiw.height);
    _registerView.frame = CGRectMake( self.middleVeiw.width * 0.5, 0,  self.middleVeiw.width * 0.5,  self.middleVeiw.height);
    _thirdView.frame = CGRectMake(0, 0,  self.bottomVeiw.width,  self.bottomVeiw.height);
    
}

// 返回按钮（dismiss）
- (IBAction)backDidClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginOrRegisterButtonClick:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    _leadingMargin.constant = _leadingMargin.constant == 0 ? (-BSScreenW) : 0;

    // 画面切换太突然，最好加个动画
    [UIView animateWithDuration:0.28 animations:^{
        // 强制刷新
        [self.view layoutIfNeeded];
    }];
}



@end
