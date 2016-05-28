//
//  LYMPublishViewController.m
//  04-百思不得姐-发布
//
//  Created by ming on 15/12/8.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "LYMPublishViewController.h"
#import "LYMPublishButton.h"
#import <POP.h>
#import "LYMPostWordViewController.h"
#import "BSLoginController.h"
#import "BSNavigationController.h"

/**  每一行的列数 */
#define lYMCol 3
/**  有关弹性的系数 */
#define LYMspring 10

@interface LYMPublishViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/** 时间数组 */
@property (nonatomic,strong) NSArray *times;
/** 按钮数组 */
@property (nonatomic,strong) NSMutableArray *buttons;

/** 标语 */
@property (nonatomic,weak) UIImageView *sloganView;
@end

@implementation LYMPublishViewController
#pragma mark ========= 懒加载 方法 ==========
- (NSArray *)times{
    if (!_times) {
        _times = [NSArray array];
        CGFloat interVal = 0.01;
        _times = @[ @(4*interVal), @(5*interVal),@(6*interVal),@(3*interVal),@(2*interVal),@(1*interVal),@(7*interVal)];
    }
    return _times;
}

- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

#pragma mark ========= viewDidLoad 方法 ==========
- (void)viewDidLoad {
    [super viewDidLoad];
    // 0.禁止用户交互
    self.view.userInteractionEnabled = NO;
    
    // 1.添加标语
    [self addSloganView];
    
    // 2.添加按钮
    [self addBtn];
}

#pragma mark ========= 添加子控件的 方法 ==========
/** 添加标语 */
- (void)addSloganView{
    CGFloat sloganY = BSScreenH * 0.20;
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
     sloganView.y = sloganY - BSScreenH;
     sloganView.centerX = BSScreenW * 0.5;
    [self.view addSubview:sloganView];
    self.sloganView = sloganView;
    
    // 添加动画
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    springAnimation.fromValue = @(sloganY - BSScreenH);
    springAnimation.toValue = @(sloganY);
    springAnimation.springBounciness = LYMspring;
    springAnimation.springSpeed = LYMspring;
    springAnimation.beginTime = CACurrentMediaTime() + [[self.times lastObject] doubleValue];
    // 5.给标语添加动画
    [sloganView.layer pop_addAnimation:springAnimation forKey:nil];
}

/** 添加按钮 */
- (void)addBtn{
    NSArray *imageArr = @[@"publish-video",@"publish-picture",@"publish-text",@"publish-audio",@"publish-review",@"publish-offline"];
    NSArray *titleArr = @[@"发视频",@"发图片",@"发段子",@"发声音",@"审帖",@"离线下载"];
    
    // 设置按钮尺寸
    CGFloat btnW = BSScreenW / lYMCol;
    CGFloat btnH = btnW * 1.1;
    for (int i = 0; i < imageArr.count; i++) {
        
        // 0.创建按钮
        LYMPublishButton *btn = [[LYMPublishButton alloc] init];
        
        // 1.设置位置
        CGFloat btnX = (i%lYMCol) * btnW;
        CGFloat btnY = (i/lYMCol) * btnH + BSScreenH * 0.28;
        btn.width = -1;
//        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        // 2.设置按钮内部图片和文字
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        
        // 3.给按钮帮绑定标记 并监听按钮的点击
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 4.添加到父控件上
        [self.view addSubview:btn];
        
        // 5.把按钮添加到数组
        [self.buttons addObject:btn];

        // 把耗时操作放在子线程中
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 添加弹簧动画
            // 1.创建弹簧动画
            POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
            
            // 2.设置弹簧的fromValue 和 toValue
            springAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(btnX, btnY-BSScreenH, btnW, btnH)];
            springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(btnX, btnY, btnW, btnH)];
            
            // 3.设置弹性速度 和 弹性系数
            springAnimation.springBounciness = LYMspring;
            springAnimation.springSpeed = LYMspring;
            
            // 4.CACurrentMediaTime() 取得当前时间
            springAnimation.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
            
            // 5.给按钮添加动画
            [btn pop_addAnimation:springAnimation forKey:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 6.允许用户交互
                self.view.userInteractionEnabled = YES;
            });
        });
    }
}


#pragma mark ========= 操作 方法 ==========
/** 退出动画方法的封装 */
- (void)exitWithBolock:(void(^)())oparation{
    /// 0.禁止用户交互
    self.view.userInteractionEnabled = NO;
    
    /// 1.开启子线程
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        NSInteger count = self.buttons.count;
        
        // 0.取得每一个按钮 (遍历)
        for (int i = 0; i < count; i++) {
            LYMPublishButton *btn = self.buttons[i];
            // 1.创建按钮弹簧动画
            POPBasicAnimation *btnAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
            // 2.设置弹簧的toValue
            btnAnimation.toValue = @(btn.y + BSScreenH);
            // 3.CACurrentMediaTime() 取得当前时间
            btnAnimation.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
            // 4.给按钮添加动画
            [btn.layer pop_addAnimation:btnAnimation forKey:nil];
            
            /// 缩放动画
            /*
             POPBasicAnimation *btnAnimation1 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
             // 2.设置弹簧的toValue
             btnAnimation1.toValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
             // 3.CACurrentMediaTime() 取得当前时间
             btnAnimation1.beginTime = CACurrentMediaTime() + [self.times[i] doubleValue];
             // 4.给按钮添加动画
             [btn.layer pop_addAnimation:btnAnimation1 forKey:nil]; */
        }
        
        // 1.创建标语弹簧动画
        POPBasicAnimation *sloganAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        // 2.设置弹簧的toValue
        sloganAnimation.toValue = @(self.sloganView.y + BSScreenH);
        // 3.CACurrentMediaTime() 取得当前时间
        sloganAnimation.beginTime = CACurrentMediaTime() + [[self.times lastObject] doubleValue];
        // 4.给按钮添加动画
        [self.sloganView.layer pop_addAnimation:sloganAnimation forKey:nil];
        
        // 动画执行完之后
        [sloganAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            /// 回到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // 退出当前控制器
                [self dismissViewControllerAnimated:NO completion:nil];
                // 判断有木有其他操作
                if(oparation){
                    oparation();
                }
            }];
        }];
    }];
   
}

/** 监听点击按钮的方法 */
- (void)buttonClick:(LYMPublishButton *)btn{
        [self exitWithBolock:^{
            switch (btn.tag) {
                case 0:{ // 发视频
                    
                    break;
                }
                case 1: { // 发图片
                    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
                    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePC.delegate = self;
                    imagePC.editing = YES;
                    [UIApplication sharedApplication].keyWindow.rootViewController = imagePC;
                    break;
                }
                case 2: { // 发段子
                    LYMPostWordViewController *postWordVC = [[LYMPostWordViewController alloc] init];
                    self.view.window.rootViewController = [[BSNavigationController alloc] initWithRootViewController:postWordVC];
                    break;
                }
                case 3: { // 发声音
                    
                    break;
                }
                case 4: { // 审帖
                    BSLoginController *loginVC = [[BSLoginController alloc] init];
                    [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
                    break;
                }
                case 5: { // 离线下载
                    
                    break;
                }
                    
                default:
                    break;
            }
        }];

}

/** 点击了取消按钮（退出当前控制器）*/
- (IBAction)cancelClick {
    [self exitWithBolock:nil];
}

/** 点击屏幕退出当前控制器 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self exitWithBolock:nil];
}

#pragma mark ========= 操UIImagePickerControllerDelegate 方法 ==========
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    BSLog(@"%@",image);
    // 退出当前照片控制器
}

@end
