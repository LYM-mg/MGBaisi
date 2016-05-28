//
//  BSTableController.m
//  06-BaiSi
//
//  Created by ming on 16/5/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "BSTableController.h"

@interface BSTableController ()

@end

@implementation BSTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 50;
}

static NSString *cellIdentifie = @"cellIdentifie";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifie];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifie];
        cell.backgroundColor = [UIColor greenColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"这是第%li行",(long)indexPath.row];
    
    return  cell;
}

#pragma mark - UITableViewDelegate
-  (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        [UIView animateWithDuration:1.0 animations:^{
            cell.layer.transform  = CATransform3DIdentity;
        }];
    }];
}

@end
