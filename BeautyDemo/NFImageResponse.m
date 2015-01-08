//
//  NFImageResponse.m
//  BeautyDemo
//
//  Created by Qeye Wang on 12/23/14.
//  Copyright (c) 2014 nirvawolf. All rights reserved.
//

#import "NFImageResponse.h"
#import "NFImageInfo.h"

@implementation NFImageResponse

- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        _primaryTag = dic[@"tag1"];
        _subTag = dic[@"tag2"];
        _totalCount = [dic[@"totalNum"] integerValue];
        _startIndex = [dic[@"start_index"] integerValue];
        _imagesCount = [dic[@"return_number"] integerValue];
        
        NSArray *imagesData = dic[@"data"];
        NSMutableArray *imageInfos = [NSMutableArray array];
        
        for(NSDictionary *imageInfoDic in imagesData){
            if (!imageInfoDic) {
                continue;
            }
            NFImageInfo *imageInfo = [[NFImageInfo alloc] initWithDictionary:imageInfoDic];
            [imageInfos addObject:imageInfo];
        }
        
        _imageInfos = imageInfos;
    }
    
    return self;
}

@end
