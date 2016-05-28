//
//  BSCommentViewController.m
//  06-BaiSi
//
//  Created by ming on 15/12/28.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSCommentViewController.h"
#import "BSTopicItem.h"
#import "BSTopicCell.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MJExtension.h>
#import "BSHeader.h"
#import "BSFooter.h"
#import "BSComment.h"
#import "BSCommentCell.h"
#import "BSCommentHeaderFooterView.h"

@interface BSCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 任务管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/** 最热评论数据 */
@property (nonatomic, strong) NSArray<BSComment *> *hotestComments;

/** 最新评论数据 */
@property (nonatomic, strong) NSMutableArray<BSComment *> *latestComments;


/** 最热评论 */
@property (nonatomic, strong) BSComment *savedTopCmt;

@end

static NSString *const BSCommentID = @"comment";
static NSString *const BSCommentHeaderID = @"commentHeader";

@implementation BSCommentViewController
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置TableView
    [self setUpTable];
    
    // 2.设置header
    [self setUpHeader];
    
    // 3.刷新
    [self setUpRefresh];
    
}

- (void)setUpTable{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = BSGlobalBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册comment
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSCommentCell class]) bundle:nil] forCellReuseIdentifier:BSCommentID];
    [self.tableView registerClass:[BSCommentHeaderFooterView class] forHeaderFooterViewReuseIdentifier:BSCommentHeaderID];
    
    // 每一组头部控件的高度
    self.tableView.sectionHeaderHeight = BSCommentSectionHeaderFont.lineHeight + BSCommandMargin;
    
    // 自动计算高度  估算高度为44
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

- (void)setUpHeader{
    // 处理模型数据
    self.savedTopCmt = self.topic.top_cmt;
    self.topic.top_cmt = nil;
    self.topic.cellHeight = 0;
    
    
    // 头部View
    UIView *header = [[UIView alloc] init];
    BSTopicCell *cell = [BSTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.topic.cellHeight);
    [header addSubview:cell];
    
     header.height = cell.height + BSCommandMargin;
    self.tableView.tableHeaderView = header;
}

#pragma mark - 数据处理
/**
 * 集成刷新控件
 */
- (void)setUpRefresh{
    self.tableView.mj_header = [BSHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [BSFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}

/**
 * 加载最新的帖子数据
 */
- (void)loadNewComments{
    // 取消所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @1; // @"1";
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager GET:BSUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 没有任何评论数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            // 让[刷新控件]结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
            return;
        }
//        [responseObject writeToFile:@"/Users/ming/Desktop/com.plist" atomically:YES];
        // 字典数组 -> 模型数组
        weakSelf.latestComments = [BSComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        weakSelf.hotestComments = [BSComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
        int total = [responseObject[@"total"] intValue];
        if (weakSelf.latestComments.count == total) { // 全部加载完毕
            // 隐藏
            weakSelf.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

/**
 * 加载最新的帖子数据
 */
- (void)loadMoreComments{
    // 取消所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 取消所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"lastcid"] = self.latestComments.lastObject.ID;
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager GET:BSUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            [weakSelf.tableView.mj_footer endRefreshing];
            return;
        }
        
        // 字典数组 -> 模型数组
        NSArray *moreComments = [BSComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [weakSelf.latestComments addObjectsFromArray:moreComments];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        int total = [responseObject[@"total"] intValue];
        if (weakSelf.latestComments.count == total) { // 全部加载完毕
            // 提示用户:没有更多数据
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//            weakSelf.tableView.mj_footer.hidden = YES;
        } else { // 还没有加载完全
            // 结束刷新
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 结束刷新
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.topic.top_cmt = self.savedTopCmt;
    self.topic.cellHeight = 0;
}

#pragma mark - UITableViewDataSource 方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // 有最热评论 + 最新评论数据
    if (self.hotestComments.count) return 2;
    
    // 没有最热评论数据, 有最新评论数据
    if (self.latestComments.count) return 1;
    
    // 没有最热评论数据, 没有最新评论数据
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 第0组 && 有最热评论数据
    if (section == 0 && self.hotestComments.count) {
        return self.hotestComments.count;
    }
    
    // 其他情况
    return self.latestComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCommentID];
    
    if (indexPath.section == 0 && self.hotestComments.count) {
        cell.comment = self.hotestComments[indexPath.row];
    } else {
        cell.comment = self.latestComments[indexPath.row];
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BSCommentHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BSCommentHeaderID];
    
    // 第0组 && 有最热评论数据
    if (section == 0 && self.hotestComments.count) {
        header.textLabel.text = @"最热评论";
    } else { // 其他情况
        header.textLabel.text = @"最新评论";
    }
    
    return header;
}

/**
 *  当用户开始拖拽scrollView就会调用一次
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
