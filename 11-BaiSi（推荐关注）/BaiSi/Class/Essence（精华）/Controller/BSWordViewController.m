//
//  BSWordViewController.m
//  04-BaiSi
//
//  Created by ming on 13/11/22.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSWordViewController.h"

@interface BSWordViewController ()

@end

@implementation BSWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(BSTitlesViewH+BSNavBarH, 0, BSTabBarH, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.title = @"段子";
}

- (BSTopicType)type{
    return BSTopicTypeWord;
}

//#pragma mark - Table view data source
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 30;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *ID = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@明明-%ld",self.class,indexPath.row];
//    
//    static UIColor *cellColor;
//    if (cellColor == nil) {
//        cellColor = BSRandomColor;
//    }
//    cell.backgroundColor = cellColor;
//    
//    return cell;
//}


@end
