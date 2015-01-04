//
//  NFBeautyPagingLoader.h
//  EverydayBeauty
//
//  Created by exitingchen on 15/1/4.
//  Copyright (c) 2015年 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFBeatyImageLoader.h"

@interface NFBeautyPagingLoader : NSObject
@property (nonatomic,copy,readonly) NSString *tagName;

- (id)initWithTagName:(NSString *)tagName;

+ (id)loaderWithTagName:(NSString *)tagName;

- (void)loadMore:(FLBeatyImageLoaderCompletion)completionBlock;

@end
