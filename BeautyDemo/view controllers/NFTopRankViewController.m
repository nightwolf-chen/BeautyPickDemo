//
//  NFTopRankViewController.m
//  BeautyDemo
//
//  Created by exitingchen on 14/12/29.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import "NFTopRankViewController.h"
#import "NFCollectionCell.h"
#import "NFImageInfo.h"
#import "NFBeatyImageLoader.h"
#import "NFBeautyPagingLoader.h"

#import <CHTCollectionViewWaterfallLayout.h>
#import <SVPullToRefresh.h>

#define kSpace 5
#define kImageWidth (SCREEN_WIDTH/2.0f - 2*kSpace)

static NSString *const kCollectionCellReusableIdentifier = @"ImageCell";

@interface NFTopRankViewController ()

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *imageInfos;
@property (nonatomic,strong) NFBeautyPagingLoader *pagingLoader;

@end

@implementation NFTopRankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated
                                                                 tag:UITabBarSystemItemTopRated];
        CHTCollectionViewWaterfallLayout *collectionLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        collectionLayout.sectionInset = UIEdgeInsetsMake(kSpace, kSpace, kSpace, kSpace);
        collectionLayout.minimumColumnSpacing = kSpace;
        collectionLayout.minimumInteritemSpacing = kSpace;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:collectionLayout];
        
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[NFCollectionCell class]
            forCellWithReuseIdentifier:kCollectionCellReusableIdentifier];
        
        __weak id weakSelf = self;
        void (^refreshBlock)(void) = ^{
            [weakSelf loadMore];
        };
        
        [_collectionView addPullToRefreshWithActionHandler:refreshBlock
                                                  position:SVPullToRefreshPositionBottom];
        
        [self.view addSubview:_collectionView];
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadMore];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadMore
{
    if (!_pagingLoader) {
        self.pagingLoader = [NFBeautyPagingLoader loaderWithTagName:@"校花"];
    }
    
    [_pagingLoader loadMore:^(BOOL suc,id obj){
        if (suc && obj) {
            NFImageResponse *resp = obj;
            [self loadImageInfos:resp.imageInfos];
            [_collectionView.pullToRefreshView stopAnimating];
        }
    }];
}

- (void)loadImageInfos:(NSArray *)imageInfos
{
    if (!_imageInfos) {
        self.imageInfos = [NSMutableArray array];
    }
    
    NSMutableArray *processedInfos = [NSMutableArray array];
    for(NFImageInfo *aInfo in imageInfos){
        CGFloat originWidth = aInfo.thumbWidth;
        CGFloat originHeight = aInfo.thumbHeight;
        if (originWidth == 0 || originHeight == 0) {
            continue;
        }
        
        BOOL found = NO;
        for(NFImageInfo *existsInfo in _imageInfos){
            if ([existsInfo.imageId isEqual:aInfo.imageId]) {
                found = YES;
                break;
            }
        }
        
        if (found) {
            continue;
        }
        
        aInfo.thumbWidth = kImageWidth;
        aInfo.thumbHeight = (originHeight*kImageWidth)/originWidth;
        [processedInfos addObject:aInfo];
    }
    
    
    NSMutableArray *indexes = [NSMutableArray array];
    for(NSUInteger index=0 ; index < processedInfos.count ;index++){
        NSUInteger row = index + _imageInfos.count;
        NSIndexPath *aIndexPath = [NSIndexPath indexPathForItem:row inSection:0];
        [indexes addObject:aIndexPath];
    }
    
    [_imageInfos addObjectsFromArray:processedInfos];
    
    [_collectionView insertItemsAtIndexPaths:indexes];
    [_collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageInfos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellReusableIdentifier
                                                                           forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[NFCollectionCell alloc] init];
    }
    
    NFImageInfo *info = _imageInfos[indexPath.row];
    ((NFCollectionCell *)cell).imageInfo = info;
    
    
    NSLog(@"row:%d url:%@",indexPath.row, info.imageId);
    
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reusableView = nil;
//    
//    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                          withReuseIdentifier:HEADER_IDENTIFIER
//                                                                 forIndexPath:indexPath];
//    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                          withReuseIdentifier:FOOTER_IDENTIFIER
//                                                                 forIndexPath:indexPath];
//    }
//    
//    return reusableView;
//}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NFImageInfo *imageInfo = _imageInfos[indexPath.row];
    return CGSizeMake(imageInfo.thumbWidth, imageInfo.thumbHeight);
    
}


@end
