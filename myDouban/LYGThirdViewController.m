//
//  LYGThirdViewController.m
//  myDouban
//
//  Created by qianfeng on 13-12-19.
//  Copyright (c) 2013年 UIday3_layer. All rights reserved.
//

#import "LYGThirdViewController.h"

@interface LYGThirdViewController ()

@end

@implementation LYGThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"归档 解码 操作数据";
	self.tabBarItem.title = @"NSCoding";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
