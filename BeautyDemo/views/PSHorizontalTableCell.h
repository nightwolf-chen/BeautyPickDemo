//
//  PSHorizontalTableCell.h
//
//  Created by exitingchen on 14/11/18.
//
//

#import <UIKit/UIKit.h>

@class PSHorizontalTableView;

//////////////////////////////////////////////////////////////////////////////
//PSHorizontalTableCell

@interface PSHorizontalTableCell : UIView

@property (nonatomic,assign) NSUInteger columIndex;

- (id)initWithTableView:(PSHorizontalTableView *)tableView;

- (id)initWithTableView:(PSHorizontalTableView *)tableView width:(CGFloat)width;

@end


