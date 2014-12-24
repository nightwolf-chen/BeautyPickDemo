//
//  NFBeatyImageCell.m
//  BeautyDemo
//
//  Created by exitingchen on 14/12/24.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import "NFBeatyImageCell.h"

#define kTitleHeight 30
#define kDescHeight 50

@implementation NFBeatyImageCell

- (id)initWithTableView:(PSHorizontalTableView *)tableView width:(CGFloat)width
{
    if (self = [super initWithTableView:tableView width:width]) {
        _imageViewMain = [[UIImageView alloc] initWithFrame:self.bounds];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width,kTitleHeight)];
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-kDescHeight, self.bounds.size.width, kDescHeight)];
        
        _titleLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        _descLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        
        [self addSubview:_imageViewMain];
        [self addSubview:_titleLabel];
        [self addSubview:_descLabel];
    }
    
    return self;
}

@end
