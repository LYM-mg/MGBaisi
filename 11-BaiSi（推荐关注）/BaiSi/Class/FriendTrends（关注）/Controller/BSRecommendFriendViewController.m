//
//  BSRecommendFriendViewController.m
//  06-BaiSi
//
//  Created by ming on 16/1/6.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "BSRecommendFriendViewController.h"
#import "BSCategoryCell.h"
#import "BSCategory.h"
#import "BSUserCell.h"
#import "BSFollowUser.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>


@interface BSRecommendFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
/** 请求管理者 */
@property (nonatomic,weak) AFHTTPSessionManager *manager;

/** 左边tableView 👈⬅️ */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 存放数据的数组 */
@property (nonatomic,strong) NSArray *categorys;
/** 右边tableView 👉➡️ */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;



@end

@implementation BSRecommendFriendViewController

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置tableView
    [self setUpTableView];
    
    // 2.加载category数据
    [self loadCategorys];
    
    // 3.
    [self setUpRefresh];
}

static NSString *BSCategoryID = @"category";
static NSString *BSUserID = @"user";

// tableView的初始化
- (void)setUpTableView{
    self.title = @"推荐关注";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIEdgeInsets insets = UIEdgeInsetsMake(BSNavBarH, 0, 0, 0);
    
    // 左边tableView 👈⬅️
    self.categoryTableView.contentInset = insets;
    self.categoryTableView.scrollIndicatorInsets = insets;
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSCategoryCell class]) bundle:nil] forCellReuseIdentifier:BSCategoryID];
    
    // 右边tableView 👉➡️
    self.userTableView.rowHeight = 60;
    self.userTableView.contentInset = insets;
    self.userTableView.scrollIndicatorInsets = insets;
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSUserCell class]) bundle:nil] forCellReuseIdentifier:BSUserID];

}

#pragma mark - 请求数据
- (void)setUpRefresh{
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.userTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/**
 *  加载user最新数据
 */
- (void)loadNewData{
    // 取消之前的任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 左边当前的Category
    BSCategory *selectCategory = self.categorys[self.categoryTableView.indexPathForSelectedRow.row];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"category_id"] = selectCategory.ID;
    
    [self.manager GET:BSUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) { // 请求成功

        // 取得数据
        selectCategory.users = [BSFollowUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.userTableView reloadData];
        
        // 重置页码
        selectCategory.page = 1;
        
        
        selectCategory.total = [responseObject[@"total"] integerValue];
        
        if (selectCategory.users.count >= selectCategory.total){
            self.userTableView.mj_footer.hidden = YES;
        }
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) { // 请求失败
        BSLog(@"%@",error);
        // 结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];
}

/**
 *  加载user更多数据
 */
- (void)loadMoreData{
    // 取消之前的任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 左边当前的Category
    BSCategory *selectCategory = self.categorys[self.categoryTableView.indexPathForSelectedRow.row];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"category_id"] = selectCategory.ID;
    parameters[@"page"] = @(selectCategory.page);
    
    [self.manager GET:BSUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) { // 请求成功
        // 请求成功 页码加1
        selectCategory.page ++;
        
        // 取得数据
        NSArray *users = [BSFollowUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [selectCategory.users addObjectsFromArray:users];
        
        // 刷新表格
        [self.userTableView reloadData];
        
        selectCategory.total = [responseObject[@"total"] integerValue];
        
        if (selectCategory.users.count >= selectCategory.total){
            self.userTableView.mj_footer.hidden = YES;
        }
        // 结束刷新
        [self.userTableView.mj_footer endRefreshing];

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) { // 请求失败
        BSLog(@"%@",error);
        // 结束刷新
        [self.userTableView.mj_footer endRefreshing];
    }];
}

/**
 *  加载category数据
 */
- (void)loadCategorys{
    [SVProgressHUD showInfoWithStatus:@"明哥正在帮你加载..."];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"category";
    parameters[@"c"] = @"subscribe";
    [self.manager GET:BSUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        // 赋值数据
        self.categorys = [BSCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新把表格
        [self.categoryTableView reloadData];
        
        // 选中左边第一个
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // 让右边表格刷新
        [self.userTableView.mj_header beginRefreshing];
        
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        BSLog(@"%@",error);
        // 隐藏指示器
        [SVProgressHUD dismiss];
    }];
}

- (void)dealloc{
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    [self.manager invalidateSessionCancelingTasks:NO];
    [SVProgressHUD dismiss];
}

#pragma mark - UITableViewDataSource 方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{  // 左边tableView 👈⬅️
    if (tableView == self.categoryTableView) {
        return self.categorys.count;
    }else{  // 左边tableView 👉➡️
        BSCategory *selectCategory = self.categorys[self.categoryTableView.indexPathForSelectedRow.row];
        return selectCategory.users.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) { // 左边tableView 👈⬅️
        BSCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCategoryID];
        cell.category = self.categorys[indexPath.row];
        return cell;
    }else { // 左边tableView 👉➡️
        BSUserCell *cell = [tableView dequeueReusableCellWithIdentifier:BSUserID];
        
        // 左边当前的Category
        BSCategory *selectCategory = self.categorys[self.categoryTableView.indexPathForSelectedRow.row];
        cell.user = selectCategory.users[indexPath.row];
        return cell;
    }

}


#pragma mark - UITableViewDelegate 方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (tableView == self.categoryTableView) {
        // 刷新右边数据
        [self.userTableView reloadData];
        
         BSCategory *selectCategory = self.categorys[self.categoryTableView.indexPathForSelectedRow.row];
        
        if (selectCategory.users.count >= selectCategory.total){
            self.userTableView.mj_footer.hidden = YES;
        }
        
        // 左边数组数据为空的时候,刷新加载数据
        if (selectCategory.users.count == 0){
            [self.userTableView.mj_header beginRefreshing];
        }
    }else{
        BSLog(@"%zd",indexPath.row);
    }
}


@end
