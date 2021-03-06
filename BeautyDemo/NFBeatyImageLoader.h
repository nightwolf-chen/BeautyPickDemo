//
//  NFBeatyImageLoader.h
//  BeautyDemo
//
//  Created by  exitingchen on 12/23/14.
//  Copyright (c) 2014 nirvawolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NFImageResponse.h"
#import "NFImageInfo.h"

typedef void (^FLBeatyImageLoaderCompletion)(BOOL succ,id obj);

@interface NFBeatyImageLoader : NSObject

+ (instancetype)shareInstance;

- (void)loadImages:(NSString *)categoryName
              page:(NSUInteger)pageNum
        completion:(FLBeatyImageLoaderCompletion)block;

- (void)loadImages:(NSString *)categoryName
              page:(NSUInteger)pageNum
       resultCount:(NSUInteger)count
        completion:(FLBeatyImageLoaderCompletion)block;

@end
