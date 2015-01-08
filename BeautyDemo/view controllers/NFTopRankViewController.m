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
#import "LMDropdownView.h"
#import "NFTopRankMenu.h"

#import <CHTCollectionViewWaterfallLayout.h>
#import <SVPullToRefresh.h>
#import <MWPhotoBrowser.h>

#define kSpace 5
#define kImageWidth (SCREEN_WIDTH/2.0f - 2*kSpace)

static NSString *const kCollectionCellReusableIdentifier = @"ImageCell";
static NSString *const kCollectionHeaderReusableIdentifier = @"ImageHeader";

@interface NFTopRankViewController ()

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) LMDropdownView *menuView;

@property (nonatomic,strong) NSMutableArray *imageInfos;
@property (nonatomic,strong) NFBeautyPagingLoader *pagingLoader;
@property (nonatomic,strong) NSMutableDictionary *cachedImageInfos;

@property (nonatomic,strong) NSArray *displayingPhotos;
@property (nonatomic,strong) NSString *displayingTitle;

@property (nonatomic,assign) CGFloat lastContentOffset;
@end

@implementation NFTopRankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        
//        self.automaticallyAdjustsScrollViewInsets = YES;
        
        _cachedImageInfos = [[NSMutableDictionary alloc] init];
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated
                                                                 tag:UITabBarSystemItemTopRated];
        CHTCollectionViewWaterfallLayout *collectionLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        collectionLayout.minimumColumnSpacing = kSpace;
        collectionLayout.minimumInteritemSpacing = kSpace;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:collectionLayout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor grayColor];
        [_collectionView registerClass:[NFCollectionCell class]
            forCellWithReuseIdentifier:kCollectionCellReusableIdentifier];
        
        __weak id weakSelf = self;
        void (^refreshBlock)(void) = ^{
            [weakSelf loadMore];
        };
        [_collectionView addPullToRefreshWithActionHandler:refreshBlock
                                                  position:SVPullToRefreshPositionBottom];
        
        
        
        [self.view addSubview:_collectionView];
        
        _menuView = [[LMDropdownView alloc] init];
        _menuView.menuContentView = [[NFTopRankMenu alloc] init];
        
        self.navigationItem.title = @"最新图片";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_menuView showInView:self.view withFrame:self.view.bounds];
    
    [self loadMore];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadMore
{
    if (!_pagingLoader) {
        self.pagingLoader = [NFBeautyPagingLoader loaderWithTagName:@"性感"];
    }
    
    [_pagingLoader loadMore:^(BOOL suc,id obj){
        if (suc && obj) {
            NFImageResponse *resp = obj;
            [self loadImageInfos:resp.imageInfos];
            [_collectionView.pullToRefreshView stopAnimating];
            [self viewDidLayoutSubviews];
        }
    }];
}

- (void)viewDidLayoutSubviews
{
    CGFloat naviHeight = self.navigationController.navigationBar.height;
    CGFloat tabHeight = self.tabBarController.tabBar.height;
//    _collectionView.frame = CGRectMake(0,naviHeight,SCREEN_WIDTH,self.view.height-tabHeight);
    _collectionView.contentInset = UIEdgeInsetsMake(naviHeight, 0, tabHeight, 0);
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
        
        if (!_cachedImageInfos[aInfo.imageId]) {
            aInfo.thumbWidth = kImageWidth;
            aInfo.thumbHeight = (originHeight*kImageWidth)/originWidth;
            [processedInfos addObject:aInfo];
            _cachedImageInfos[aInfo.imageId] = aInfo;
        }
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
    
    
//    NSLog(@"row:%d url:%@",indexPath.row, info.imageId);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NFImageInfo *info = _imageInfos[indexPath.row];
    
    self.displayingPhotos = @[[MWPhoto photoWithURL:[NSURL URLWithString:info.imageUrl]]];
    self.displayingTitle = info.desc;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = YES; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = YES; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:1];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:browser];
    // Present
    [self presentViewController:navigationController animated:YES completion:^{}];

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:kCollectionHeaderReusableIdentifier
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NFImageInfo *imageInfo = _imageInfos[indexPath.row];
    return CGSizeMake(imageInfo.thumbWidth, imageInfo.thumbHeight);
    
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _displayingPhotos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _displayingPhotos.count){
        return _displayingPhotos[index];
    }
    return nil;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index
{
    return _displayingTitle;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index
{
//    [photoBrowser dismissViewControllerAnimated:YES
//                                     completion:^{}];
    //TODO:
}



@end
