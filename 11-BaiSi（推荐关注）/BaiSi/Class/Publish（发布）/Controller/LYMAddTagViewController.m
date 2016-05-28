//
//  LYMAddTagViewController.m
//  04-百思不得姐-发布
//
//  Created by ming on 15/12/10.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "LYMAddTagViewController.h"
#import "LYMAddTagButton.h"
#import "SVProgressHUD.h"
#import "LYMTextField.h"

@interface LYMAddTagViewController ()<UITextFieldDelegate>
#pragma mark ========== 属性 ==========
/** 输入框 */
@property (nonatomic,weak) LYMTextField *textField;
/** 占位View */
@property (nonatomic,weak) UIView *contentView;
/** 标签提示按钮 */
@property (nonatomic,weak) UIButton *tipBtn;
/** 标签数组 */
@property (nonatomic,strong) NSMutableArray *tagButtons;

@end

@implementation LYMAddTagViewController
#pragma mark ========== 懒加载 ==========
// 标签数组
- (NSMutableArray *)tagButtons{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}
// 标签提示按钮
- (UIButton *)tipBtn{
    if (!_tipBtn) {
        // 创建提示按钮
        UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // 监听按钮的点击
        [tipBtn addTarget:self action:@selector(tipClick) forControlEvents:UIControlEventTouchUpInside];
        tipBtn.x = 0;
        tipBtn.backgroundColor = [UIColor blueColor];
        tipBtn.titleLabel.font = [UIFont systemFontOfSize:16];

        // 此句代码不起作用
//        tipBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        tipBtn.contentHorizontalAlignment = NSTextAlignmentLeft;
        tipBtn.contentEdgeInsets = UIEdgeInsetsMake(0, BSCommandMargin, 0, 0);
        tipBtn.width = self.contentView.width;
        tipBtn.height = BSTagHight;
        [self.contentView addSubview:tipBtn];
        _tipBtn = tipBtn;
    }
    return _tipBtn;
}

#pragma mark ========== 初始化操作 ==========
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 1.初始化导航栏
    [self setupNav];
    
    // 2.初始化占位视图
    [self setupContentView];
    
    // 3.初始化textField
    [self setupTextField];
}

// 1.初始化导航栏
- (void)setupNav{
    self.title = @"添加标签";
    // 初始化导航栏左边的的Item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    // 初始化导航栏右边的的Item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

// 2.初始化占位视图
- (void)setupContentView{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = BSCommandMargin;
    contentView.y = BSSmallCommandMargin + BSNavBarH;
    contentView.height = BSScreenH - BSNavBarH;
    contentView.width = BSScreenW - 2 * BSSmallCommandMargin;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

// 3.初始化textField
- (void)setupTextField{
    LYMTextField *textField = [[LYMTextField alloc] init];
    textField.x = BSSmallCommandMargin;
    textField.y = BSSmallCommandMargin;
    textField.height = BSTagHight;
    textField.width = BSScreenW - 2 * BSSmallCommandMargin;
//    [textField sizeToFit];
    textField.placeholder = @"多个标签用逗号或者换行隔开";
    [textField setValue:[UIColor redColor] forKeyPath:@"placeholderLabel.textColor"];
    
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:textField];
    self.textField = textField;
    textField.delegate = self;
    [self.textField becomeFirstResponder];
    
    // 强制刷新的前提：控件已经被加到父控件
//    [textField layoutIfNeeded];
    
    // 设置点击删除需要执行的操作
    LYMWeakSelf;
    textField.deleteBackwardOperation = ^{
        // 判断有木有输入文字
        if (weakSelf.textField.hasText) return;
        if (weakSelf.tagButtons.count > 0) {
            // 删除 相当于点击了最后一个标签按钮
            [weakSelf remove:self.tagButtons.lastObject];
        }
    };
}

#pragma mark ========== 监听 =========
/// 监听输入框的改变
- (void)textDidChange{
    if (self.textField.hasText) { // 输入框不为空，显示提示按钮
        self.tipBtn.hidden = NO;
        
        // 设置textField的位置
        [self setupTextFieldFrame];
        NSString *title = [NSString stringWithFormat:@"添加标签：%@",self.textField.text];
        [self.tipBtn setTitle:title forState:UIControlStateNormal];
        if ([self.textField.text containsString:@","] || [self.textField.text containsString:@"，"]) {
            [self tipClick];
        }
    }else {  // 输入框为空，隐藏提示按钮
        self.tipBtn.hidden = YES;
    }
}

// 监听新增标签按钮点击
- (void)tipClick{
    // 0.如果没有输入文字就不能添加标签
    if (!self.textField.hasText) return;
    
    // 1.控制标签数
    if (self.tagButtons.count >= 5) {
        [SVProgressHUD showInfoWithStatus:@"你只能添加五个标签，不能再继续添加了"];
       return;
    }
    
    // 2.创建一个标签按钮
    LYMAddTagButton *newTagBtn = [[LYMAddTagButton alloc] init];
    [newTagBtn setTitle:self.textField.text forState:UIControlStateNormal]; // 重写了setTitle:forState:方法
    newTagBtn.backgroundColor = [UIColor blueColor];
    
    // 3.监听标签按钮的点击
    [newTagBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:newTagBtn];
    
    // 4.取得最后一个按钮
    LYMAddTagButton *refreceTagButton = self.tagButtons.lastObject;
    
    // 5.设置标签的位置
    [self setupTagButtonFrame:newTagBtn refreceTagButton:refreceTagButton];
    
    // 6.添加标签按钮到数组
    [self.tagButtons addObject:newTagBtn];
    
    self.textField.text = nil;
    // 7.设置textField的位置
    [self setupTextFieldFrame];
    
    // 8.隐藏提示按钮
    self.tipBtn.hidden = YES;
}

#pragma mark ========== 操作 =========
/** 设置textField的尺寸 */
- (void)setupTextFieldFrame{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName:self.textField.font}].width;
    textW = MAX(100, textW);
    // 取得最后一个按钮
    LYMAddTagButton *lastTagButton = self.tagButtons.lastObject;
    // 左边的宽度
    CGFloat LeftWidth = CGRectGetMaxX(lastTagButton.frame) + BSSmallCommandMargin;
    // 右边剩下的宽度
    CGFloat rightWidth = self.contentView.width - LeftWidth;
    
    if (rightWidth > textW) { // 右边还可以继续放标签
        self.textField.x = LeftWidth;
        self.textField.y = lastTagButton.y;
    }else{  // 下一行
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + BSSmallCommandMargin;
    }
    
    // 提示按钮的位置跟随者textField变化
    self.tipBtn.y = CGRectGetMaxY(self.textField.frame) + BSSmallCommandMargin;
}

/** 设置标签按钮的的位置和尺寸 */
- (void)setupTagButtonFrame:(LYMAddTagButton *)tagButton refreceTagButton:(LYMAddTagButton *)refreceTagButton{
    /// 1.没有参照按钮（第一个标签按钮）
    if (refreceTagButton == nil) {
        tagButton.x = 0;
        tagButton.y = 0;
        return;
    }
    
    /// 2.有参照按钮
    // 左边的宽度
    CGFloat LeftWidth = CGRectGetMaxX(refreceTagButton.frame) + BSSmallCommandMargin;
    // 右边剩下的宽度
    CGFloat rightWidth = self.contentView.width - LeftWidth;
    
    if (rightWidth > tagButton.width) { // 右边还可以继续放标签
        tagButton.x = LeftWidth;
        tagButton.y = refreceTagButton.y;
    }else{  // 下一行
        tagButton.x = 0;
        tagButton.y = CGRectGetMaxY(refreceTagButton.frame) + BSSmallCommandMargin;
    }
}

// 监听标签按钮的点击。删除当前标签
- (void)remove:(LYMAddTagButton *)clickedTagButton{
    NSUInteger index = [self.tagButtons indexOfObject:clickedTagButton];
    [clickedTagButton removeFromSuperview];
    [self.tagButtons removeObjectAtIndex:index];
    
    for (NSUInteger i = index;i < self.tagButtons.count; i++) {
        LYMAddTagButton *tagButtton = self.tagButtons[i];
        LYMAddTagButton *previousTagButton = (i==0)? nil : self.tagButtons[i-1];
        [self setupTagButtonFrame:tagButtton refreceTagButton: previousTagButton];
        //        if (i>0) { // 删除的是其他
        //            LYMAddTagButton *previousTagButton = self.tagButtons[i-1];
        //            [self setupTagButtonFrame:tagButtton refreceTagButton:previousTagButton];
        //        }else{ // 删除的是第一个
        //            [self setupTagButtonFrame:tagButtton refreceTagButton:nil];
//        }
    }

    // 设置textField的位置
    [self setupTextFieldFrame];
}

// 监听导航栏左边的取消按钮
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 监听导航栏右边的完成按钮
- (void)done{
   
}

#pragma mark ========== UITextFieldDelegate ========
/**
 *  点击右下角的换行按钮就会调用该方法
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self tipClick];
    return YES;
}

@end
