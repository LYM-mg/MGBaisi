//
//  BSWebViewController.m
//  04-BaiSi
//
//  Created by ming on 13/12/21.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSWebViewController.h"
#import <WebKit/WebKit.h>
#import "BSSquareItem.h"

#pragma mark - Key
static NSString *const BScanGoBackKey = @"canGoBack";
static NSString *const BScanGoForwardKey = @"canGoForward";
static NSString *const BSestimatedProgressKey = @"estimatedProgress";
static NSString *const BSURLKey = @"URL";


@interface BSWebViewController ()<UISearchBarDelegate>
#pragma mark - 属性
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForword;

@property (weak, nonatomic) IBOutlet UIView *topView;
/** 显示网页的View */
@property (nonatomic,weak) WKWebView *webView;
/** 进度条 */
@property (nonatomic,weak) UIProgressView *progress;
/** searchBar */
@property (nonatomic,strong)UISearchBar *searchBar;
@end

@implementation BSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 0.设置标题
    self.title = _squareItem.name;
    
    // 1.创建webView,加载数据请求
    [self loadData];
    
    // 2.KVO
    [self setButton];
    
    // 3.进度条
    [self setupProgress];
    
    // 4.UISearchBar(URL)
    [self setupSearchBar];
}

#pragma mark - setupSearchBar
- (void)setupSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    _searchBar = searchBar;
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

#pragma mark - progress
- (void)setupProgress{
    CGFloat y = self.navigationController ? 64:0 ;
    UIProgressView *progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, y, BSScreenW, 2)];
    // 属性
    progress.progress = 0.0;
    progress.progressTintColor = [UIColor orangeColor];
    
    _progress = progress;
    [self.webView addSubview:progress];
    [self.webView addObserver:self forKeyPath:BSestimatedProgressKey options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - KVO
- (void)setButton{
    [self.webView addObserver:self forKeyPath:BScanGoBackKey options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:BScanGoForwardKey options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:BSURLKey options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    self.goBack.enabled = self.webView.canGoBack;
    self.goForword.enabled = self.webView.canGoForward;
    self.progress.progress = self.webView.estimatedProgress;
    if (self.progress.progress == 1) {
        self.progress.hidden = YES;
    }
    self.searchBar.text = [NSString stringWithContentsOfURL:self.webView.URL encoding:NSUTF8StringEncoding error:nil];
}

// 移除观察者
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:BScanGoBackKey];
    [self.webView removeObserver:self forKeyPath:BScanGoForwardKey];
    [self.webView removeObserver:self forKeyPath:BSestimatedProgressKey];
    [self.webView removeObserver:self forKeyPath:BSURLKey];
}

#pragma mark - 操作
// 后退
- (IBAction)gobackDidClick:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

// 前进
- (IBAction)goForwordDidClcik:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

// 刷新
- (IBAction)reloadDidClick:(UIBarButtonItem *)sender {
    [self.webView reload];
}


#pragma mark - loadData 
- (void)loadData{
    WKWebView *webView = [[WKWebView alloc] init];
    _webView = webView;
    [self.topView addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:_squareItem.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.webView.frame = self.topView.frame;
}

#pragma mark - UISearchBarDelegate
// 开始编辑
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
}

// 结束编辑
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

@end
