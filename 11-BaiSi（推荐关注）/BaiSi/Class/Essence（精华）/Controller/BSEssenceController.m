//
//  BSEssenceController.m
//  BaiSi
//
//  Created by ming on 13/12/17.
//  Copyright © 2015年 ming. All rights reserved.
// MainTitle

#import "BSEssenceController.h"
#import "BSAllViewController.h"
#import "BSVideoViewController.h"
#import "BSVoiceViewController.h"
#import "BSPictureViewController.h"
#import "BSWordViewController.h"
#import "BSTitleButton.h"
#import "BSTagController.h"
#import "BSTableController.h"

/** 放大系数 */
static CGFloat const maxScale = 1.3;

@interface BSEssenceController ()<UIScrollViewDelegate>
#pragma mark - 属性
/** 全局滚动的内容的UIscrollView */
@property (nonatomic,weak) UIScrollView *scrollVeiw;
/** 存放按钮的titlesVeiw */
@property (nonatomic,weak) UIView *titlesVeiw;
/** 标题栏 */
@property (nonatomic,weak) UIView *underLineView;
/** 选中按钮 */
@property (nonatomic,strong) BSTitleButton *selTitleButton;

@end

@implementation BSEssenceController

#pragma mark - 初始化方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BSGlobalBgColor;
    // 不需要系统自动添加的间距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 1.设置导航栏
    [self setupNav];
    
    // 2.加载所有的子控制器
    [self setUpAllChildVcs];
    
    
    // 3.创建 ScrollView
    [self setUpScrollView];
    
    // 4.创建 titlesView
    [self setUpTitleView];

    
    // 5.默认加载第一个控制器的View
    [self addChildVeiwControllerViewToScrollView];
}

/**
 *  加载所有的子控制器
 */
- (void)setUpAllChildVcs{
    [self addChildViewController:[[BSAllViewController alloc] init]];
    [self addChildViewController:[[BSVideoViewController alloc] init]];
    [self addChildViewController:[[BSVoiceViewController alloc] init]];
    [self addChildViewController:[[BSPictureViewController alloc] init]];
    [self addChildViewController:[[BSWordViewController alloc] init]];
}

/**
 *  创建 ScrollView
 */
- (void)setUpScrollView{
    UIScrollView *scrollVeiw = [[UIScrollView alloc] init];
//    scrollVeiw.y = self.navigationController ? BSNavBarH : 0;
//    scrollVeiw.width = BSScreenW;
//    scrollVeiw.height = BSScreenH;
    scrollVeiw.frame = self.view.bounds;
    // 设置分页
    scrollVeiw.pagingEnabled = YES;
    // 设置代理
    scrollVeiw.delegate = self;
    _scrollVeiw = scrollVeiw;
    scrollVeiw.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollVeiw];
    NSInteger count = self.childViewControllers.count;
    
    // 设置滚动范围
    scrollVeiw.contentSize = CGSizeMake(count * scrollVeiw.width, 0);
}

/**
 *  创建 titlesView
 */
- (void)setUpTitleView{
    // 1.创建
    UIView *titlesView = [[UIView alloc] init];
    titlesView.y = self.navigationController ? BSNavBarH : 0;
    titlesView.width = BSScreenW;
    titlesView.height = BSTitlesViewH;
    
    _titlesVeiw = titlesView;
    [self.view addSubview:titlesView];
    titlesView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    // 添加 titleButton
    [self setUpTitleButton];
    
    // 添加 下划线
    [self setUpUnderLineView];
    
}

/**
 *  创建 titleButton
 */
- (void)setUpTitleButton{
    NSArray *titleArray = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    NSInteger count = self.childViewControllers.count;
    // 设置titleButton的尺寸
    CGFloat titleButtonW = self.titlesVeiw.width/count;
    CGFloat titleButtonH = self.titlesVeiw.height;
    CGFloat titleButtonX = 0;
    // 添加按钮
    for (int i = 0; i < count; i++) {
        BSTitleButton *titleButton = [[BSTitleButton alloc] init];
        titleButtonX = i * titleButtonW;
        titleButton.frame = CGRectMake(titleButtonX, 0, titleButtonW, titleButtonH);
        
        // 设置titleButton的文字
        [titleButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesVeiw addSubview:titleButton];
    }
}

/**
 *  创建 underLineView(下划线)
 */
- (void)setUpUnderLineView{
    // 取得第一个按钮
    BSTitleButton *firstButton = self.titlesVeiw.subviews.firstObject;
    
    // 标题栏
    UIView *underLineView = [[UIView alloc] init];
    underLineView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    underLineView.height = 2;
    underLineView.y = self.titlesVeiw.height - underLineView.height;
    
    // 让第一个按钮为选中状态
    [self titleButtonClick:firstButton];
//    firstButton.selected = YES;
//    self.selTitleButton = firstButton;

    
    // 下划线的宽度 == 按钮的文字的宽度
//    [firstButton.titleLabel sizeToFit];
//
//    // 先计算宽度后计算中心点
//    underLineView.width = firstButton.titleLabel.width + BSCommandMargin;
//    underLineView.centerX = firstButton.centerX;
    
    _underLineView = underLineView;
    [self.titlesVeiw addSubview:underLineView];
}


/**
 *  设置 导航栏
 */
- (void)setupNav{
    // 设置标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置左边按钮图片
    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithBackgroundImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(leftItemClick)];
    
    // 设置右边按钮图片
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithBackgroundImage:@"navigationButtonRandom" highImage:@"navigationButtonRandomClick" target:self action:@selector(rightItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}


#pragma mark - 操作
/**
 *  titleButton的点击，选中按钮并切换对应的控制器的View
 */
- (void)titleButtonClick:(BSTitleButton *)btn{
    /// 注意顺序
    if (self.selTitleButton == btn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BSTitleButtonRepeatClickNotification object:nil];
    }
    
    self.selTitleButton.selected = NO;
    // 让之前选中的恢复原样
    self.selTitleButton.transform = CGAffineTransformIdentity;
    btn.selected = YES;
    // 让选中按钮放大
    btn.transform = CGAffineTransformMakeScale(maxScale, maxScale);
    self.selTitleButton = btn;
    
    // 取得当前按钮下标
    NSInteger index = [self.titlesVeiw.subviews indexOfObject:btn];
    
    [UIView animateWithDuration:0.25 animations:^{
        // 1.标题栏选中状态
        [btn.titleLabel sizeToFit];
        _underLineView.width = btn.titleLabel.width + BSCommandMargin;
        _underLineView.centerX = btn.centerX;
        
        CGPoint offset = self.scrollVeiw.contentOffset;
        offset.x = index * self.scrollVeiw.width;
        self.scrollVeiw.contentOffset = offset;
    }completion:^(BOOL finished) {
        [self addChildVeiwControllerViewToScrollView];
    }];

}

/**
 *  去加载控制器(加载并且切换控制器)
 */
- (void)addChildVeiwControllerViewToScrollView{
    NSInteger index = self.scrollVeiw.contentOffset.x/self.scrollVeiw.width;
    // 2.加载控制器
    UIViewController *childVC = self.childViewControllers[index];
    
    // 如果加载过了就不必再次加载了
    if (childVC.isViewLoaded) return;
//    if (childVC.view.window) return;
//    if (childVC.view.superclass) return;
//    if (self.scrollVeiw.subviews containsObject:childVC.view) return;
    
    childVC.view.frame = self.scrollVeiw.bounds;
    [self.scrollVeiw addSubview:childVC.view];
}


// 导航条左边点击 (跳转到关注标签界面)
- (void)leftItemClick{
    BSTagController *tagVC = [[BSTagController alloc] init];
    
    [self.navigationController pushViewController:tagVC animated:YES];
}

- (void)rightItemClick{
    BSTableController *tableVC = [[BSTableController alloc] init];
    [self.navigationController pushViewController:tableVC animated:true];
}

#pragma mark - UIScrollViewDelegate方法
/**
 *  拖拽切换控制器的View并且对应的按钮变为选中状态
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 获取索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    // 滑动切换控制器
    [self titleButtonClick:self.titlesVeiw.subviews[index]];
}

/**
 *  拖拽切换控制器的View，对应的按钮变为选中状态以及按钮的文字会有缩放效果还有
 *  颜色的渐变效果
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 获取索引
    NSInteger indexL = scrollView.contentOffset.x/scrollView.width;
    NSInteger indexR = indexL + 1;
    BSTitleButton *leftBtn = self.titlesVeiw.subviews[indexL];
    BSTitleButton *rightBtn;
    if (indexR < self.titlesVeiw.subviews.count - 1) {
        rightBtn = self.titlesVeiw.subviews[indexR];
    }
    
    // 缩放比例
    CGFloat scaleR = (scrollView.contentOffset.x/scrollView.width) - indexL;
    CGFloat scaleL = (1 - scaleR);
    BSLog(@"%f",scaleR);
    CGFloat scale = maxScale - 1;
    leftBtn.transform = CGAffineTransformMakeScale(scale*scaleL+1, scale*scaleL+1);
    rightBtn.transform = CGAffineTransformMakeScale(scale*scaleR+1, scale*scaleR+1);
//
//    // 先计算宽度后计算中心点
//    if (indexL == 1) {
//        [UIView animateWithDuration:0.25 animations:^{
//            [rightBtn.titleLabel sizeToFit];
//            _underLineView.width = leftBtn.titleLabel.width + BSCommandMargin;
//            _underLineView.centerX = leftBtn.centerX;
//        }];
//    }
//   
//   
    // 改变颜色
//    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1.0];
//    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
//    
//    UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1.0];
//    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
}

@end
