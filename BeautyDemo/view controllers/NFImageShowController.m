//
//  NFImageShowController.m
//  BeautyDemo
//
//  Created by exitingchen on 14/12/24.
//  Copyright (c) 2014年 nirvawolf. All rights reserved.
//

#import "NFImageShowController.h"
#import "PSHorizontalTableView.h"
#import "NFBeatyImageCell.h"
#import "NFBeatyImageLoader.h"
#import "UIImageView+WebCache.h"


#define kTableCellWidth SCREEN_WIDTH

@interface NFImageShowController ()

@property (nonatomic,strong) PSHorizontalTableView *tableView;
@property (nonatomic,strong) NSArray *imageInfos;

@end

@implementation NFImageShowController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites
                                                                     tag:UITabBarSystemItemFavorites];
    }
    
    return self;
}

#pragma mark - Setup views
- (void)setupViews
{
    [self setupNavigationBar];
    [self setupTableView];
}


- (void)setupNavigationBar
{
    self.navigationItem.title = @"每日美女";
}

- (void)setupTableView
{
    CGFloat kTableViewHeight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
    self.tableView = [[PSHorizontalTableView alloc] initWithFrame:CGRectMake(0,
                                                                             self.navigationController.navigationBar.frame.size.height,
                                                                             kTableCellWidth,
                                                                             kTableViewHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.pageEnabled = YES;
    _tableView.scrollView.directionalLockEnabled = YES;
    _tableView.backgroundColor = RGBCOLOR(232, 184, 204);
    [self.view addSubview:_tableView];
    
    [[NFBeatyImageLoader shareInstance] loadImages:@"性感" page:10 completion:^(BOOL suc,id obj){
        if (suc) {
            NFImageResponse *resp = obj;
            self.imageInfos = resp.imageInfos;
            [_tableView reloadData];
        }else{
            NSLog(@"load images falied!");
        }
    }];
    
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
    return _imageInfos.count;
}

- (PSHorizontalTableCell *)ps_tableView:(PSHorizontalTableView *)tableView columForIndexPath:(NSUInteger)index
{
    PSHorizontalTableCell *cell = [tableView dequeueReusableCell];
    if (!cell) {
        cell = [[NFBeatyImageCell alloc] initWithTableView:tableView width:kTableCellWidth];
    }
    
    NFImageInfo *imageInfo = _imageInfos[index];
    NFBeatyImageCell *beatyCell = (NFBeatyImageCell *)cell;
    [beatyCell.imageViewMain sd_setImageWithURL:[NSURL URLWithString:imageInfo.imageUrl]];
    
    return cell;
}

@end
