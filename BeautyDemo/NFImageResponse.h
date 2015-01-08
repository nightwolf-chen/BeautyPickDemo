//
//  NFImageResponse.h
//  BeautyDemo
//
//  Created by Qeye Wang on 12/23/14.
//  Copyright (c) 2014 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFImageResponse : NSObject

@property (nonatomic,copy) NSString *primaryTag;
@property (nonatomic,copy) NSString *subTag;
@property (nonatomic,assign) NSUInteger totalCount;
@property (nonatomic,assign) NSUInteger startIndex;
@property (nonatomic,assign) NSUInteger imagesCount;
@property (nonatomic,strong) NSArray *imageInfos;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
