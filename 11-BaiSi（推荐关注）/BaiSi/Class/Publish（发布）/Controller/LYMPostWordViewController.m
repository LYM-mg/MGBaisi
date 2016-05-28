//
//  LYMPostWordViewController.m
//  03-百思不得姐-我的
//
//  Created by ming on 15/12/8.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "LYMPostWordViewController.h"
#import "LYMTextView.h"
#import "LYMPostWordToolBar.h"
#import "BSTabBarController.h"
#import "BSNavigationController.h"

@interface LYMPostWordViewController ()<UITextViewDelegate>
/** 文本输入框 */
@property (nonatomic,weak) LYMTextView *textView;
/** 键盘顶部工具View */
@property (nonatomic,weak)  LYMPostWordToolBar *toolbar;
@end

@implementation LYMPostWordViewController
#pragma mark ========= 初始化 方法 ==========
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setupNav];
    
    // 初始化文本框
    [self setupTextView];
    
    // 初始化 “+” 按钮
    [self setupToolbar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

// 初始化导航栏
- (void)setupNav{
    self.title = @"发表文字";
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化导航栏左边的的Item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    // 初始化导航栏右边的的Item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(issue)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // 强制刷新（马上回到现在的状态）
    //    [self.navigationController.navigationBar layoutIfNeeded];
}

/** 添加文本输入框 */
- (void)setupTextView{
    LYMTextView *textView = [[LYMTextView alloc] init];
    textView.frame = self.view.bounds;
    
    // 不管内容有多小度可以滚动（这是UIScrollView的一个属性）
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.placeholder = @"把好玩的图片,好笑的段子发到这里,接收千粉丝的膜拜吧。发布违反法律内容的,我们将依法提交给有关部门处理";
    
//    textView.placeholderColor = LYMRandomColor;
//    textView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:textView];
    self.textView = textView;
}

/** 添加标签View */
- (void)setupToolbar{
    // 1.创建toolbar
    LYMPostWordToolBar *toolbar = [LYMPostWordToolBar toolbar];
    toolbar.x = 0;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.width = BSScreenW;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
    // 2.通知键盘尺寸的改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

// 监听通知
- (void)keyboardDidChangeFrame:(NSNotification *)note{
    // 动画时间
    CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 位移高度
    CGFloat transformY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y - BSScreenH;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durtion * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, transformY);
    });
    [self.textView layoutSubviews];
}

#pragma mark ========= 操作 方法 ==========
// 监听导航栏左边的取消按钮
- (void)cancel{
    // 回到精华控制器
    [UIApplication sharedApplication].keyWindow.rootViewController = [[BSTabBarController alloc] init];
}
// 监听导航栏右边的取消按钮
- (void)issue{
    BSLog(@"明哥");
}

#pragma mark =========== UITextViewDelegate 方法 ============
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

@end
