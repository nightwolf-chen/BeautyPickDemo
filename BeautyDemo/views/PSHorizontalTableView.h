//
//  PSHorizontalTableView.h
//  QQMSFContact
//
//  Created by exitingchen on 14/11/18.
//
//

#import <UIKit/UIKit.h>
#import "PSHorizontalTableCell.h"

//////////////////////////////////////////////////////////////////////////////
//PSHorizontalTableView
@protocol PSHorizontalTableViewDataSource;
@protocol PSHorizontalTableViewDelegate;

@interface PSHorizontalTableView : UIView
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,weak) id<PSHorizontalTableViewDelegate> delegate;
@property (nonatomic,weak) id<PSHorizontalTableViewDataSource> dataSource;
@property (nonatomic,assign) BOOL pageEnabled;

- (PSHorizontalTableCell *)dequeueReusableCell;
- (void)reloadData;
@end


//////////////////////////////////////////////////////////////////////////////
//PSHorizontalTableCellModel
@interface PSHorizontalTableCellModel : NSObject
@property (nonatomic,assign) CGRect columFrame;
@property (nonatomic,assign) NSUInteger columIndex;
@end



//////////////////////////////////////////////////////////////////////////////
//PSHorizontalTableViewDelegate
@protocol PSHorizontalTableViewDelegate <NSObject>
@required
- (CGFloat)ps_tableViewWidthForColum:(PSHorizontalTableView *)tableView;
@end



//////////////////////////////////////////////////////////////////////////////
//PSHorizontalTableViewDataSource
@protocol PSHorizontalTableViewDataSource <NSObject>
@required
- (PSHorizontalTableCell *)ps_tableView:(PSHorizontalTableView *)tableView columForIndexPath:(NSUInteger)index;
- (NSUInteger)numberOfColums:(PSHorizontalTableView *)tableView;
@end