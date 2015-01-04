//
//  NFCollectionCell.m
//  EverydayBeauty
//
//  Created by exitingchen on 15/1/4.
//  Copyright (c) 2015年 icephone. All rights reserved.
//

#import "NFCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "NFImageInfo.h"

@interface NFCollectionCell ()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation NFCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
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
    
    self.width = imageInfo.thumbWidth;
    self.height = imageInfo.thumbHeight;
    
//    self.backgroundColor = [UIColor blueColor];
    
    NSURL *url = [NSURL URLWithString:imageInfo.imageUrl];
    
    _imageView.image = nil;
    [_imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image,NSError *err,SDImageCacheType cacheType,NSURL *url){
        if (err) {
            NSLog(@"%@",[err localizedDescription]);
        }
        self.imageView.width = imageInfo.thumbWidth;
        self.imageView.height = imageInfo.thumbHeight;
    }];
    
    
}

@end
