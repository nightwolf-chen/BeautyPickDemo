//
//  NFBeatyImageLoader.h
//  BeautyDemo
//
//  Created by  exitingchen on 12/23/14.
//  Copyright (c) 2014 icephone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FLBeatyImageLoaderCompletion)(BOOL succ,id obj);

@interface NFBeatyImageLoader : NSObject

+ (instancetype)shareInstance;

- (void)loadImages:(NSString *)categoryName
              page:(NSUInteger)pageNum
        completion:(FLBeatyImageLoaderCompletion)block;

@end
