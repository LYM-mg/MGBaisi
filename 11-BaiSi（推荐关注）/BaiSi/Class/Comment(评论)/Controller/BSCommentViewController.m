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

@interface BSCommentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BSCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTable];
    
    // 头部View
    UIView *header = [[UIView alloc] init];
    BSTopicCell *topicCell = [BSTopicCell viewFromXib];
    [header addSubview:topicCell];
    self.tableView.tableHeaderView = header;
}

- (void)setUpTable{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDataSource 方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *const commentID = @"commentID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentID];
    }
    
    return cell;
}


@end
