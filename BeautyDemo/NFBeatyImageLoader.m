//
//  NFBeatyImageLoader.m
//  BeautyDemo
//
//  Created by exitingchen on 12/23/14.
//  Copyright (c) 2014 icephone. All rights reserved.
//

#import <AFNetworking.h>
#import "NFBeatyImageLoader.h"
#import "NFImageResponse.h"

static NSString *(^imageUrl)(NSString*,NSUInteger,NSUInteger) = ^(NSString *categoryName,NSUInteger pageNum,NSUInteger resultCount){
    NSString* urlString = [NSString stringWithFormat:@"http://image.baidu.com/channel/listjson?pn=%lu&rn=%d&tag1=美女&tag2=%@", (unsigned long)pageNum,resultCount,categoryName];
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
};

@interface NFBeatyImageLoader ()

@property (nonatomic,strong) AFHTTPRequestOperationManager *networkManager;

@end

@implementation NFBeatyImageLoader

+ (instancetype)shareInstance
{
    static id s_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[[self class] alloc] init];
    });
    
    return s_instance;
}

- (id)init
{
    if (self = [super init]) {
        _networkManager = [AFHTTPRequestOperationManager manager];
        _networkManager.responseSerializer.acceptableContentTypes = [NSMutableSet setWithArray:@[@"text/html"]];
    }
    
    return self;
}

- (void)loadImages:(NSString *)categoryName
              page:(NSUInteger)pageNum
       resultCount:(NSUInteger)count
        completion:(FLBeatyImageLoaderCompletion)block
{
    NSString *requestUrl = imageUrl(categoryName,pageNum,count);
    
    void (^successBlock)(AFHTTPRequestOperation *,id) = ^(AFHTTPRequestOperation *op,id obj){
        NFImageResponse *imageResp = [[NFImageResponse alloc] initWithDictionary:obj];
        [self notifyBlock:block
                  success:YES
                      obj:imageResp];
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *,NSError *) = ^(AFHTTPRequestOperation *op,NSError * err){
        [self notifyBlock:block
                  success:NO
                      obj:err];
    };
    
    [_networkManager GET:requestUrl
              parameters:nil
                 success:successBlock
                 failure:failureBlock];
}

- (void)loadImages:(NSString *)categoryName
              page:(NSUInteger)pageNum
        completion:(FLBeatyImageLoaderCompletion)block
{
    [self loadImages:categoryName page:pageNum resultCount:10 completion:block];
}

- (void)notifyBlock:(FLBeatyImageLoaderCompletion)block success:(BOOL)suc obj:(id)obj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block(suc,obj);
    });
}

@end
