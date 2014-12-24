//
//  PSHorizontalTableView.m
//  QQMSFContact
//
//  Created by exitingchen on 14/11/18.
//
//

#import "PSHorizontalTableView.h"
#import "PSHorizontalTableCell.h"

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

typedef enum PSTemplateContainerScrollDirection{
    PSTemplateContainerScrollDirectionLeft,
    PSTemplateContainerScrollDirectionRight,
    PSTemplateContainerScrollDirectionStill
}PSTemplateContainerScrollDirection;

static void *kKVOContext = &kKVOContext;
static const CGFloat kDefaultColumWidth = 100;

NSUInteger (^indexForOffsetX)(CGFloat,CGFloat) = ^NSUInteger (CGFloat x,CGFloat columWidth){
    if((NSInteger)x < 0) return 0;
    return (NSUInteger)(x / columWidth);
};

NSString* (^stringIndex)(NSInteger) = ^NSString* (NSInteger x){
    return [NSString stringWithFormat:@"%ld",x];
};


//////////////////////////////////////////////////////////////////////////////
//PSHorizontalTableView
@interface PSHorizontalTableView ()
@property (nonatomic,strong) NSArray *columModels;
@property (nonatomic,strong) NSMutableDictionary *activeColums;
@property (nonatomic,strong) NSMutableSet *resuableColumes;
@property (nonatomic,assign) NSUInteger visibleCount;
@end


@implementation PSHorizontalTableView

- (void)dealloc
{
    [_scrollView removeObserver:self
                     forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_scrollView];
        
        _resuableColumes = [[NSMutableSet alloc] init];
        
        [_scrollView addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(contentOffset))
                         options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                         context:kKVOContext];
        
        _activeColums = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (CGFloat)getColumWidth
{
    if ([_delegate respondsToSelector:@selector(ps_tableViewWidthForColum:)]) {
        return [_delegate ps_tableViewWidthForColum:self];
    }
    return kDefaultColumWidth;
}

- (CGSize)getContenSize
{
    return CGSizeMake([self getColumWidth] * [self getColumCount], self.frame.size.height);
}

- (NSUInteger)getColumCount
{
    if ([_dataSource respondsToSelector:@selector(numberOfColums:)]) {
        return [_dataSource numberOfColums:self];
    }
    
    return _visibleCount;
}

- (void)reloadData
{
    [self collectAllCells];
    [self loadData];
}


- (void)loadData
{
    [self preprocessColums];
    
    _scrollView.contentSize = [self getContenSize];
    //触发KVO
    _scrollView.contentOffset = _scrollView.contentOffset;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == kKVOContext
        && [keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        
        CGPoint oldOffSet = [change[NSKeyValueChangeOldKey] CGPointValue];
        CGPoint newOffSet = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        PSTemplateContainerScrollDirection dir=PSTemplateContainerScrollDirectionStill;
        
        if(newOffSet.x>oldOffSet.x){
            dir = PSTemplateContainerScrollDirectionLeft;
        }else{
            dir = PSTemplateContainerScrollDirectionRight;
        }
        
        [self displayVisibleColums:indexForOffsetX(newOffSet.x,[self getColumWidth])
                         direction:dir];
        
    }
}

- (void)displayVisibleColums:(NSUInteger)idx direction:(PSTemplateContainerScrollDirection)dir
{
    if (idx >= _columModels.count) {
        return;
    }
    
    BOOL changed = NO;
    
    for(int i=0 ; i < _visibleCount && idx + i < _columModels.count ; i++){
        
        if (_activeColums[stringIndex(idx+i)]) {
            continue;
        }
        
        changed = YES;
        
        PSHorizontalTableCell *cell = [self.dataSource ps_tableView:self
                                                       columForIndexPath:idx+i];
        
        cell.frame = [(PSHorizontalTableCellModel *)_columModels[idx+i] columFrame];
        cell.columIndex = idx+i;
        
        [_scrollView addSubview:cell];
        _activeColums[stringIndex(idx+i)] = cell;
    }
    
    if (changed) {
        [self collectInvisibleColumForIndex:idx scrollDirection:dir];
    }
}


- (void)collectAllCells
{
    NSArray *keys = [_activeColums allKeys];
    for(NSString *key in keys){
        [self collectInvisibleColumForIndex:[key integerValue]];
    }
}

- (void)collectInvisibleColumForIndex:(NSUInteger)idx
                      scrollDirection:(PSTemplateContainerScrollDirection)dir
{
    if (dir == PSTemplateContainerScrollDirectionLeft) {
        [self collectInvisibleColumForIndex:idx - 1];
    }else if(dir == PSTemplateContainerScrollDirectionRight){
        [self collectInvisibleColumForIndex:idx + _visibleCount];
    }
}

- (void)collectInvisibleColumForIndex:(NSUInteger)idx
{
    UIView *view = _activeColums[stringIndex(idx)];
    
    if (view) {
        [_resuableColumes addObject:view];
        [view removeFromSuperview];
        [_activeColums removeObjectForKey:stringIndex(idx)];
    }
}


- (void)preprocessColums
{
    _visibleCount = (NSInteger)(SCREEN_WIDTH / [self getColumWidth]) + 2;
    NSMutableArray *models = [NSMutableArray array];
    NSInteger columCount = [self getColumCount];
    
    PSHorizontalTableCellModel *aModel = nil;
    CGRect columFrame = CGRectMake(0, 0, [self getColumWidth], self.frame.size.height);
    for(int idx = 0 ; idx < columCount; idx++){
        aModel = [[PSHorizontalTableCellModel alloc] init];
        aModel.columIndex = idx;
        aModel.columFrame = columFrame;
        [models addObject:aModel];
        columFrame.origin.x += [self getColumWidth];
    }
    
    self.columModels = models;
}


- (PSHorizontalTableCell *)dequeueReusableCell;
{
    id tmp = [[_resuableColumes allObjects] lastObject];
    
    if (tmp) {
        [_resuableColumes removeObject:tmp];
        return tmp;
    }
    
    return nil;
}

- (BOOL)pageEnabled
{
    return _scrollView.pagingEnabled;
}

- (void)setPageEnabled:(BOOL)pageEnabled
{
    _scrollView.pagingEnabled = pageEnabled;
}

@end




//////////////////////////////////////////////////////////////////////////////
//PSHorizontalTableCellModel
@implementation PSHorizontalTableCellModel

@end
