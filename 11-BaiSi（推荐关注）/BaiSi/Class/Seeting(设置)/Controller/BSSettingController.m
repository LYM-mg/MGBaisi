//
//  BSSettingController.m
//  02-BaiSi
//
//  Created by ming on 13/12/18.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSSettingController.h"
#import "NSObject+FileManager.h"
#import <SVProgressHUD.h>


@interface BSSettingController ()
/** 缓存尺寸*/
@property(nonatomic ,assign) NSInteger total;
@end

@implementation BSSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"正在计算缓存尺寸..."];

    // 获取cachePath文件缓存
    [self getFileSizeWithFileName:self.cachesPath completion:^(NSInteger total) {
        
        _total = total;
        
        // 计算完成就会调用
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        
    }];


}

#pragma mark == Table view data source 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [self getSize];
 
    return cell;
}

// 计算size
- (NSString *)getSize{
    float unit = 1000.0;
    NSString *text = @"清除缓存";
    NSString *str = nil;
    if (_total > unit * unit * unit) {
        str = [NSString stringWithFormat:@"%.1fGB",_total/unit / unit / unit];
    }else if (_total > unit * unit){
        str = [NSString stringWithFormat:@"%.1fMB",_total/unit / unit];
    }else if (_total > unit){
        str = [NSString stringWithFormat:@"%.1fKB",_total/unit];
    }else{
        str = [NSString stringWithFormat:@"%.1zdB",_total];
    }
    return [NSString stringWithFormat:@"%@(%@)",text,str];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [SVProgressHUD showWithStatus:@"正在删除.."];
    // 清空缓存,就是把Cache文件夹直接删掉
    // 删除比较耗时
    [self removeCachesWithCompletion:^{
        _total = 0;
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

@end
