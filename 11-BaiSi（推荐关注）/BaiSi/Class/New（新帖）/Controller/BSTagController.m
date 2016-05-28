//
//  BSTagController.m
//  02-BaiSi
//
//  Created by ming on 13/12/18.
//  Copyright © 2015年 ming. All rights reserved.
//
/*
    请求：http://api.budejie.com/api/api_open.php
    参数：
    a	true	string	tag_recommend
    action	true	string	sub
    c	true	string	topic
 */

#import "BSTagController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJExtension/MJExtension.h>
#import "BSTagItem.h"
#import "BSTagCell.h"

@interface BSTagController ()
#pragma mark - 定义属性 
/** 会话管理者 */
@property (nonatomic,weak) AFHTTPSessionManager *manager;
/** 标签数组 */
@property (nonatomic,strong) NSMutableArray *tags;

@end

static NSString *const tagCell = @"tag";

@implementation BSTagController
#pragma mark - 懒加载
- (NSMutableArray *)tags{
    if (!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐标签";
    self.tableView.rowHeight = 80;
    
    // 1.请求关注数据
    [self loadData];
    
    // 2.注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSTagCell class]) bundle:nil] forCellReuseIdentifier:tagCell];
    
    // 3.显示指示器
    [SVProgressHUD showWithStatus:@"正在加载..."];
}

#pragma mark - 请求数据
- (void)loadData{
    // 1.创建会话管理者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    self.manager = manager;
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    
    // 3.发送GET请求
    [self.manager GET:BSUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) { // 请求成功
        if (responseObject == nil) return;
        
        // 给标签数组赋值数据
        self.tags = [BSTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [self.tableView reloadData];
//        BSLog(@"%@",responseObject);
        
        // 隐藏指示器
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) { // 请求失败
        // 隐藏指示器
        [SVProgressHUD dismiss];
        BSLog(@"%@",error);
    }];
}

/// 界面消失的时候调用
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 1.取消所有任务
    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.移除会话管理者 invalidateSessionCancelingTasks:是否需要任务完成后再取消，这里填NO
    [self.manager invalidateSessionCancelingTasks:NO];
    
    // 3.取消指示器
    [SVProgressHUD dismiss];
}

#pragma mark - Tableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    BSTagCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCell forIndexPath:indexPath];
   
    // 2.给cell赋值
    cell.tagItem = self.tags[indexPath.row];
    
    return cell;
}

@end
