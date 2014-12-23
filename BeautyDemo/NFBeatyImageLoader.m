//
//  NFBeatyImageLoader.m
//  BeautyDemo
//
//  Created by extingchen on 12/23/14.
//  Copyright (c) 2014 icephone. All rights reserved.
//

#import "NFBeatyImageLoader.h"
#import <AFNetworking.h>

static NSString *(^imageUrl)(NSString*,NSUInteger) = ^(NSString *categoryName,NSUInteger pageNum){
    NSString* urlString = [NSString stringWithFormat:@"http://image.baidu.com/channel/listjson?pn=%lu&rn=10&tag1=美女&tag2=%@", (unsigned long)pageNum,categoryName];
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

- (void)loadImages:(NSString *)categoryName page:(NSUInteger)pageNum completion:(FLBeatyImageLoaderCompletion)block
{
    NSString *requestUrl = imageUrl(categoryName,pageNum);
    
    void (^successBlock)(AFHTTPRequestOperation *,id) = ^(AFHTTPRequestOperation *op,id obj){
        block(YES,obj);
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *,NSError *) = ^(AFHTTPRequestOperation *op,NSError * err){
        block(NO,err);
    };
    
    
    [_networkManager GET:requestUrl parameters:nil success:successBlock failure:failureBlock];
}

@end
