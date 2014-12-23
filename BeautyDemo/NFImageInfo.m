//
//  NFImageInfo.m
//  BeautyDemo
//
//  Created by exitingchen on 12/23/14.
//  Copyright (c) 2014 icephone. All rights reserved.
//

#import "NFImageInfo.h"
#import "ImageInfo.h"

@implementation NFImageInfo

- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        _imageId = dic[@"id"];
        _pageNumber = [dic[@"pn"] integerValue];
        _desc = dic[@"desc"];
        _tags = dic[@"tags"];
        _tag = dic[@"tag"];
        _date = dic[@"date"];
        
        _imageUrl = dic[@"image_url"];
        _imageWidth = [dic[@"image_width"] floatValue];
        _imageHeight = [dic[@"image_height"] floatValue];
        
        _thumbUrl = dic[@"thumbnail_url"];
        _thumbWidth = [dic[@"thumbnail_width"] floatValue];
        _thumbHeight = [dic[@"thumbnail_height"] floatValue];
        
        _largeThumbUrl = dic[@"thumb_large_url"];
        _largeThumbWidth = [dic[@"thumb_large_width"] floatValue];
        _largeThumbHeight = [dic[@"thumb_large_height"] floatValue];
        
        _siteUrl = dic[@"site_url"];
        _fromUrl = dic[@"from_url"];
    }
    
    return self;
}

- (ImageInfo *)imageInfo
{
    ImageInfo *info = [[ImageInfo alloc] init];
    info.width = _imageWidth;
    info.height = _imageHeight;
    info.thumbURL = _imageUrl;
    info.title = _desc;
    
    return info;
}


@end
