//
//  BStopicViewController.m
//  06-BaiSi
//
//  Created by ming on 15/12/29.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BStopicViewController.h"
#import "BSCommentViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import "BSTopicItem.h"
#import "BSTopicCell.h"
#import "BSHeader.h"
#import "BSFooter.h"
#import "BSNewController.h"

@interface BStopicViewController ()
/** 会话管理职 */
@property (nonatomic,weak) AFHTTPSessionManager *manager;
/** 话题数组 */
@property (nonatomic,strong) NSMutableArray *topics;
/** maxtime */
@property (nonatomic,copy) NSString *maxtime;
/** 决定返回的是【list】还是【newlist】 */
- (NSString *)aParam;

@end

@implementation BStopicViewController

- (BSTopicType)type{
    return 0;
}

- (NSString *)aParam{
    if ([self.parentViewController isKindOfClass:NSClassFromString(@"BSNewController")]) return @"newlist";
    return @"list";
}

#pragma mark - 懒加载
- (NSMutableArray *)topics{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

static NSString *const topicCellID = @"topic";

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.设置TableView
    [self setupTable];
    
    // 2.刷新
    [self setUpRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidClick) name:BSTabBarButtonRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidClick) name:BSTitleButtonRepeatClickNotification object:nil];
}

#pragma mark - 监听
- (void)titleButtonDidClick{
    [self tabBarButtonDidClick];
}

- (void)tabBarButtonDidClick{
    // 如果View不在窗口上，立即返回
    if (self.view.window == nil) return;
    
    // 如果与窗口没有重叠，直接返回
    if (![self.view intersectsOtherView:nil]) return;
    
    // 进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

/**
 * 设置TableView
 */
- (void)setupTable{
    self.tableView.contentInset = UIEdgeInsetsMake(BSNavBarH + BSTitlesViewH, 0, BSTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSTopicCell class]) bundle:nil] forCellReuseIdentifier:topicCellID];
}

#pragma mark - 数据处理
/**
 * 集成刷新控件
 */
- (void)setUpRefresh{
    self.tableView.mj_header = [BSHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopicData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [BSFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopicData)];
}

/**
 * 加载最新的帖子数据
 */
- (void)loadNewTopicData{
    // 1.取消之前的任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.aParam;
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);//BSTopicTypeAll
    // 设置请求超时为10秒
    self.manager.requestSerializer.timeoutInterval = 10.0;
    
    [self.manager GET:BSUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject == nil) return ;
        
        // 给话题数组赋值数据
        self.topics = [BSTopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 记录上一页最后一个模型的ID
        self.maxtime = responseObject[@"info"][@"maxtime"];
        // 刷新数据
        [self.tableView reloadData];
        
        // 刷新完毕
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        BSLog(@"%@",error);
        // 刷新完毕
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTopicData{
    // 1.取消之前的任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = self.aParam;
    parameters[@"c"] = @"data";
    parameters[@"maxtime"] = self.maxtime;
    parameters[@"type"] = @(self.type);
    
    [self.manager GET:BSUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject == nil) return ;
        // 给话题数组赋值数据
        NSArray *moreTopics = [BSTopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        [self.topics addObjectsFromArray:moreTopics];
        // 刷新数据
        [self.tableView reloadData];
        
        // 刷新完毕
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        BSLog(@"%@",error);
        // 刷新完毕
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


#pragma mark - Tableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建 cell
    BSTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:topicCellID];
    
    // 2.给cell的模型赋值当前的模型
    cell.topic = self.topics[indexPath.row];
    
    // 3.返回cell
    return cell;
}

#pragma mark - TbaleVeiwDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取得当前模型
    return [self.topics[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSCommentViewController *commentVC = [[BSCommentViewController alloc] init];
    commentVC.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:commentVC animated:YES];
}


@end
