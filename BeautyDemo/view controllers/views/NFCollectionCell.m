//
//  NFCollectionCell.m
//  EverydayBeauty
//
//  Created by exitingchen on 15/1/4.
//  Copyright (c) 2015年 nirvawolf. All rights reserved.
//

#import "NFCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "NFImageInfo.h"
#import "Colours.h"

static const CGFloat kBorderWidth = 4;
static const CGFloat kTitleHeight = 24;

@interface NFCollectionCell ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation NFCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _backgroundImageView = [[UIImageView alloc] init];
        
        UIImage *image = [[UIImage imageNamed:@"PhotoBorder"] stretchableImageWithLeftCapWidth:4
                                                                                  topCapHeight:4];
        
        _backgroundImageView.image = image;
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [_imageView addSubview:_titleLabel];
        
        [_backgroundImageView addSubview:_imageView];
        [self addSubview:_backgroundImageView];
    }
    
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)setImageInfo:(NFImageInfo *)imageInfo
{
    _imageInfo = imageInfo;
    
   
    
//    self.backgroundColor = [UIColor blueColor];
    
    NSURL *url = [NSURL URLWithString:imageInfo.imageUrl];
    
    _imageView.image = nil;
    [_imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image,NSError *err,SDImageCacheType cacheType,NSURL *url){
        if (err) {
            NSLog(@"%@",[err localizedDescription]);
        }
        [self setNeedsLayout];
    }];
}

- (void)layoutSubviews
{
    self.width = _imageInfo.thumbWidth;
    self.height = _imageInfo.thumbHeight;
    
    self.backgroundImageView.width = _imageInfo.thumbWidth;
    self.backgroundImageView.height = _imageInfo.thumbHeight;
    
    self.imageView.width = _imageInfo.thumbWidth - 2*kBorderWidth;
    self.imageView.height = _imageInfo.thumbHeight - 2*kBorderWidth;
    self.imageView.centerX = _imageInfo.thumbWidth / 2.0f;
    self.imageView.centerY = _imageInfo.thumbHeight / 2.0f;
    
    if (!_imageInfo.desc || [_imageInfo.desc isEqualToString:@""]) {
        self.titleLabel.frame = CGRectZero;
    }else{
        self.titleLabel.frame = RECT(0, _imageView.height-kTitleHeight, _imageView.width, kTitleHeight);
        self.titleLabel.text = _imageInfo.desc;
    }
}

@end
