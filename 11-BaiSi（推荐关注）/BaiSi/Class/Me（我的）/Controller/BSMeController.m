//
//  BSMeController.m
//  BaiSi
//
//  Created by ming on 13/12/17.
//  Copyright © 2013年 ming. All rights reserved.
//

#import "BSMeController.h"
#import "BSSettingController.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFNetworking.h>
#import "BSSquareCell.h"
#import "BSSquareItem.h"
#import "BSWebViewController.h"

//#import <SafariServices/SafariServices.h>

/** Cell循环利用的标识符 */
static NSString *const ID = @"square";
/** 行号 */
static NSInteger const col = 4;
/** Cell之间的间距 */
static CGFloat const padding = 1;
/** Cell的高度 */
#define cellWH ((BSScreenW-((col-1)*padding))/col);

@interface BSMeController ()<UICollectionViewDataSource,UICollectionViewDelegate>
#pragma mark - 属性
/** collectionVeiw */
@property (nonatomic,strong) UICollectionView *collectionView;
/** 模型数组 */
@property (nonatomic,strong) NSMutableArray *squareArr;

@end

@implementation BSMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.设置导航条
    [self setupNavBar];
    
    // 2.设置footView
    [self setupFootView];
    
    // 3.设置背景
    self.tableView.backgroundColor = BSColor(216, 216, 216);
    
    // 4.加载数据
    [self loadSquareData];
    
    // 5.设置Cell与导航条的间距
    [self setupTable];
}

// 5.设置Cell与导航条的间距
- (void)setupTable{
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
//    NSLog(@"%@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
    self.tableView.contentInset = UIEdgeInsetsMake(BSCommandMargin - 35, 0, 0, 0);
}

#pragma mark - 加载数据 
// 加载数据
- (void)loadSquareData{
    // 1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 1.1设置超时
    manager.requestSerializer.timeoutInterval = 10.0;
    
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    // 3.发送GET请求
    [manager GET:BSUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {    // 成功
        if (responseObject == nil) return ;
        // 3.1赋值数组 数据模型
        _squareArr = [BSSquareItem mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
        
        // 3.2补充缺口数据
        [self resoveData];
        
        // 3.3-collectionView刷新表格
        [self.collectionView reloadData];
        
        // 3.4计算collectionView的高度
        NSInteger row = (_squareArr.count-1) /col + 1;
        self.collectionView.height = row * cellWH;
        self.tableView.tableFooterView = self.collectionView;
        
        // 3.5解决tableView底部有空余的间距的操作
        [self.tableView reloadData];

//        BSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {   // 失败
        BSLog(@"%@",error);
    }];
}

/** 补充缺口数据 */
- (void)resoveData{
    NSInteger extre = self.squareArr.count%col;
    extre = col - extre;
    for (int i = 0; i<extre; i++) {
        BSSquareItem *item = [[BSSquareItem alloc] init];
        
        [self.squareArr addObject:item];
    }
}

#pragma mark - 设置tableVeiwFootView 
// 设置footView
- (void)setupFootView{
    // 1.设置flowLayout布局
    UICollectionViewFlowLayout *flowLayout = ({
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 1.1设置flowLayout的属性
        CGFloat width = cellWH;
        CGFloat height = cellWH;
        flowLayout.itemSize =CGSizeMake(width, height);
        flowLayout.minimumInteritemSpacing = padding;
        flowLayout.minimumLineSpacing = padding;
        flowLayout;
    });
    // 2.创建UICollectionView
    UICollectionView *collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, BSScreenW, 0) collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollEnabled = NO;
        collectionView.backgroundColor = self.tableView.backgroundColor;
        collectionView;
    });
    _collectionView = collectionView;
    // 3.设置collectionView为tableView的footView
    // 设置tableView的footView,高度由我们自己决定,宽度,位置都是控制不了
    self.tableView.tableFooterView = collectionView;
    // 4.注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BSSquareCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - UICollectionViewDataSource 方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.squareArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BSSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor greenColor];
    cell.squareItem = self.squareArr[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate 方法
// 监听cell的点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BSSquareItem *item = self.squareArr[indexPath.row];
    if ([item.url hasPrefix:@"http://"]) {
        BSWebViewController *webView = [[BSWebViewController alloc] init];
        webView.squareItem = item;
        [self.navigationController pushViewController:webView animated:YES];
        
//        SFSafariViewController *html = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:item.url]];
//      
//        [self.navigationController pushViewController:html animated:YES];
    }
}

#pragma mark - 设置导航条
// 设置导航条
- (void)setupNavBar{
    // 标题
    self.title = @"明哥";
//    self.navigationController.title = @"明哥";
//    self.navigationItem.title = @"明哥";
    // 右边
    UIBarButtonItem *rightItem1 = [UIBarButtonItem itemWithBackgroundImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click"@"mine-setting-icon-click" target:self action:@selector(settingItemClick)];
    UIButton *btn = [UIBarButtonItem itemWithBackgroundImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" selectImage:@"mine-sun-icon" selHighImage:@"mine-sun-icon-click" target:self action:@selector(nightItemClick:)];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItems = @[rightItem1,settingItem];
}

// 导航条右边点击 (跳转到设置控制器)
- (void)settingItemClick{
    BSSettingController *settingVC = [[BSSettingController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

// 夜间模式的切换
- (void)nightItemClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    BSLogFunc
}

#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BSLog(@"%@",NSStringFromCGRect(cell.frame));
}


@end
