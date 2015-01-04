//
//  NFBeautyPagingLoader.m
//  EverydayBeauty
//
//  Created by exitingchen on 15/1/4.
//  Copyright (c) 2015年 nirvawolf. All rights reserved.
//

#import "NFBeautyPagingLoader.h"

@interface NFBeautyPagingLoader ()
@property (nonatomic,copy,readwrite) NSString *tagName;
@property (nonatomic,assign,readwrite) NSUInteger currentPageNum;
@end

@implementation NFBeautyPagingLoader

- (id)initWithTagName:(NSString *)tagName
{
    if (self = [super init]) {
        _tagName = tagName;
        _currentPageNum = 1;
    }
    
    return self;
}

+ (id)loaderWithTagName:(NSString *)tagName
{
    return [[NFBeautyPagingLoader alloc] initWithTagName:tagName];
}

- (void)loadMore:(FLBeatyImageLoaderCompletion)completionBlock
{
    FLBeatyImageLoaderCompletion aComletionBlock = ^(BOOL suc,id obj){
        if (suc && obj) {
            self.currentPageNum = _currentPageNum + 1;
        }
        
        completionBlock(suc,obj);
    };
    
    [[NFBeatyImageLoader shareInstance] loadImages:_tagName
                                              page:_currentPageNum
                                        completion:aComletionBlock];
}

@end
