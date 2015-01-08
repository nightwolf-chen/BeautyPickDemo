//
//  NFTopRankMenu.m
//  EverydayBeauty
//
//  Created by exitingchen on 15/1/8.
//  Copyright (c) 2015年 nirvawolf. All rights reserved.
//

#import "NFTopRankMenu.h"

CGFloat kMenuHeight = 300;

@interface NFTopRankMenu ()

@property(nonatomic,strong) UITextField *keywordTextField;
@property(nonatomic,strong) UITableView *selectionTableView;
@property(nonatomic,strong) NSArray *selections;

@end

@implementation NFTopRankMenu

+ (CGFloat)menuHeight
{
    return kMenuHeight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _selections = @[@"校花",@"可爱",@"萝莉",@"性感",@"清纯",@"小清新",@"甜素纯"];
        
        _selectionTableView = [[UITableView alloc] initWithFrame:self.bounds
                                                           style:UITableViewStylePlain];
        [self addSubview:_selectionTableView];
        
        _selectionTableView.delegate = self;
        _selectionTableView.dataSource = self;
    }
    
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,kMenuHeight)];
}

#pragma mark - UITableView,delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const kReusableIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReusableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kReusableIdentifier];
    }
    
    cell.textLabel.text = _selections[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selections.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


@end
