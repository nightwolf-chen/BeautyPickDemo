//
//  NFBeatyImageCell.m
//  BeautyDemo
//
//  Created by exitingchen on 14/12/24.
//  Copyright (c) 2014年 nirvawolf. All rights reserved.
//

#import "NFBeatyImageCell.h"

#define kTitleHeight 30
#define kDescHeight 50

static const CGFloat kMarginHorizontal = 10;
static const CGFloat kMarginVertical = 10;

@implementation NFBeatyImageCell

- (id)initWithTableView:(PSHorizontalTableView *)tableView width:(CGFloat)width
{
    if (self = [super initWithTableView:tableView width:width]) {
        
        self.backgroundColor = [UIColor grayColor];
        
        _imageViewMain = [[UIImageView alloc] initWithFrame:RECT(0, 0,self.width-2*kMarginHorizontal,self.height-2*kMarginVertical)];
        _imageViewMain.centerX = self.width / 2.0f;
        _imageViewMain.centerY = self.height / 2.0f;
        _imageViewMain.contentMode = UIViewContentModeScaleAspectFit;
        _imageViewMain.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,_imageViewMain.width,kTitleHeight)];
//        _titleLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               _imageViewMain.height-kDescHeight,
                                                               width,
                                                               kDescHeight)];
//        _descLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        
        
        [_imageViewMain addSubview:_titleLabel];
        [_imageViewMain addSubview:_descLabel];
        [self addSubview:_imageViewMain];
    }
    
    return self;
}

@end
