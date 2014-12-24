//
//  NFImageShowController.m
//  BeautyDemo
//
//  Created by exitingchen on 14/12/24.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import "NFImageShowController.h"
#import "PSHorizontalTableView.h"
#import "NFBeatyImageCell.h"

#define kTableViewHeight  300
#define kTableViewOriginY (SCREEN_HEIGHT*0.2)
#define kTableCellWidth SCREEN_WIDTH

@interface NFImageShowController ()

@property (nonatomic,strong) PSHorizontalTableView *tableView;
@property (nonatomic,strong) NSArray *imageInfos;

@end

@implementation NFImageShowController

#pragma mark - Setup views
- (void)setupViews
{
    [self setupTableView];
}

- (void)setupTableView
{
    self.tableView = [[PSHorizontalTableView alloc] initWithFrame:CGRectMake(0,kTableViewOriginY,SCREEN_WIDTH,kTableViewHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pageEnabled = YES;
    
    
    [self.view addSubview:_tableView];
    
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Tableview delegate datasource

- (CGFloat)ps_tableViewWidthForColum:(PSHorizontalTableView *)tableView
{
    return kTableCellWidth;
}

- (NSUInteger)numberOfColums:(PSHorizontalTableView *)tableView
{
#ifdef DEBUG
    return 3;
#endif
    return _imageInfos.count;
}

- (PSHorizontalTableCell *)ps_tableView:(PSHorizontalTableView *)tableView columForIndexPath:(NSUInteger)index
{
    PSHorizontalTableCell *cell = [tableView dequeueReusableCell];
    if (!cell) {
        cell = [[NFBeatyImageCell alloc] initWithTableView:tableView width:kTableCellWidth];
    }
    return cell;
}

@end
