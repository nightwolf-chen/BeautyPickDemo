//
//  NFHomeController.m
//  BeautyDemo
//
//  Created by exitingchen on 14/12/29.
//  Copyright (c) 2014年 icephone. All rights reserved.
//

#import "NFHomeController.h"
#import "NFImageShowController.h"
#import "NFTopRankViewController.h"
#import "NFUserCenterController.h"
#import "picVC.h"

@interface NFHomeController ()

@end

@implementation NFHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *viewControllers = @[[[NFTopRankViewController alloc] initWithNibName:nil bundle:nil],
                                 [[NFImageShowController alloc] initWithNibName:nil bundle:nil],
                                 [[NFUserCenterController alloc] initWithNibName:nil bundle:nil]];
    
    NSArray *tmpControllers = @[[[picVC alloc] initWithNibName:nil bundle:nil],
                                 [[NFImageShowController alloc] initWithNibName:nil bundle:nil],
                                 [[NFUserCenterController alloc] initWithNibName:nil bundle:nil]];
    
#ifdef DEBUG
    tmpControllers = viewControllers;
#endif
    
    self.viewControllers = tmpControllers;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
