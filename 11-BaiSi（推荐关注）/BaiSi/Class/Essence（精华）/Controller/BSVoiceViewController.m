//
//  BSVoiceViewController.m
//  04-BaiSi
//
//  Created by ming on 13/11/22.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSVoiceViewController.h"

@interface BSVoiceViewController ()

@end

@implementation BSVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // tableView的内边距
    self.tableView.contentInset = UIEdgeInsetsMake(BSTitlesViewH +BSNavBarH, 0, BSTabBarH, 0);
    // 滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor clearColor]; 
    self.title = @"声音";
}

// 返回类型
- (BSTopicType)type{
    return BSTopicTypeVoice;
}

//#pragma mark - Table view data source
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 30;
//}
//
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
//    static UIColor *cellColor ;
//    if (cellColor == nil) {
//        cellColor = BSRandomColor;
//    }
//    cell.backgroundColor = cellColor;
//    
//    return cell;
//}
@end
