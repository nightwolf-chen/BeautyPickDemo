//
//  PSHorizontalTableCell.m
//
//  Created by exitingchen on 14/11/18.
//
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "PSHorizontalTableCell.h"
#import "PSHorizontalTableView.h"

static const CGFloat kDefaultCellWidth = 80;


//////////////////////////////////////////////////////////////////////////////
//PSHorizontalTableCell
@implementation PSHorizontalTableCell


- (id)initWithTableView:(PSHorizontalTableView *)tableView
{
    CGRect frame = CGRectMake(0, 0, kDefaultCellWidth, tableView.frame.size.height);
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (id)initWithTableView:(PSHorizontalTableView *)tableView width:(CGFloat)width
{
    CGRect frame = CGRectMake(0, 0, width, tableView.frame.size.height);
    if (self = [super initWithFrame:frame]) {
        
    }

    return self;
}



@end









