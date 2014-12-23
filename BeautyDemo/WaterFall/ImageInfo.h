//
//  ImageInfo.h
//  hlrenTest
//
//  Created by blue on 13-4-23.
//  Copyright (c) 2013年 blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NFImageInfo;

@interface ImageInfo : NSObject

@property float width;
@property float height;
@property (nonatomic,strong)NSString *thumbURL;
@property (nonatomic,strong)NSString *title;

-(id)initWithDictionary:(NSDictionary*)dictionary;
@end
