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

@interface NFHomeController ()

@end

@implementation NFHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = @[[[NFTopRankViewController alloc] initWithNibName:nil bundle:nil],
                             [[NFImageShowController alloc] initWithNibName:nil bundle:nil],
                             [[NFUserCenterController alloc] initWithNibName:nil bundle:nil]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
