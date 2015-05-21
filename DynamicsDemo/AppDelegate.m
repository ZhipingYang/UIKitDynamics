
//
//  AppDelegate.m
//  DynamicsDemo
//
//  Created by XcodeYang on 4/2/15.
//  Copyright (c) 2015 XcodeYang. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    RootViewController *root = [[RootViewController alloc]init];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:root];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}

@end
