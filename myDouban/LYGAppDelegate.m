//
//  LYGAppDelegate.m
//  myDouban
//
//  Created by qianfeng on 13-12-17.
//  Copyright (c) 2013年 UIday3_layer. All rights reserved.
//

#import "LYGAppDelegate.h"

#import "LYGViewController.h"
#import "LYGSecondViewController.h"
#import "LYGThirdViewController.h"
#import "LYGFourthViewController.h"

@implementation LYGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[LYGViewController alloc] initWithNibName:@"LYGViewController" bundle:nil];
    UINavigationController *fnv = [[UINavigationController alloc]initWithRootViewController:self.viewController];
    fnv.title = @"Json";
    LYGSecondViewController *svc = [[LYGSecondViewController alloc]init];
    UINavigationController *snv = [[UINavigationController alloc]initWithRootViewController:svc];
    snv.title = @"DataBase";
    
    LYGThirdViewController *tvc = [[LYGThirdViewController alloc]init];
    UINavigationController *tnv = [[UINavigationController alloc]initWithRootViewController:tvc];
    tnv.title = @"NSCoding";
    
    LYGFourthViewController *forvc = [[LYGFourthViewController alloc]init];
    UINavigationController *fornv = [[UINavigationController alloc]initWithRootViewController:forvc];
    fornv.title = @"tableViewController";
    
    UITabBarController * myTabbar = [[UITabBarController alloc]init];
    
    myTabbar.viewControllers = @[fnv,snv,tnv,fornv];
    
    self.window.rootViewController = myTabbar;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
