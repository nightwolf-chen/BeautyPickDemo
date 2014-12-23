//
//  NFImageInfo.h
//  BeautyDemo
//
//  Created by extingchen on 12/23/14.
//  Copyright (c) 2014 icephone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFImageInfo : NSObject

@property (nonatomic,copy) NSString *imageId;
@property (nonatomic,assign) NSUInteger pageNumber;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,strong) NSArray *tags;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,copy) NSString *date;

@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,assign) CGFloat imageWidth;
@property (nonatomic,assign) CGFloat imageHeight;

@property (nonatomic,copy) NSString *thumbUrl;
@property (nonatomic,assign) CGFloat thumbWidth;
@property (nonatomic,assign) CGFloat thumbHeight;

@property (nonatomic,copy) NSString *largeThumbUrl;
@property (nonatomic,assign) CGFloat largeThumbWidth;
@property (nonatomic,assign) CGFloat largeThumbHeight;

@property (nonatomic,copy) NSString *siteUrl;
@property (nonatomic,copy) NSString *fromUrl;


- (id)initWithDictionary:(NSDictionary *)dic;

@end
