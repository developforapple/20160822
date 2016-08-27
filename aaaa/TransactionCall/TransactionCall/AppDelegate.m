//
//  AppDelegate.m
//  TransactionCall
//
//  Created by wwwbbat on 16/8/2.
//  Copyright © 2016年 wwwbbat. All rights reserved.
//

#import "AppDelegate.h"
#import "SPMacro.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBarTintColor:AppBarColor];
    [[UINavigationBar appearance] setTintColor:MainTintColor];
    [[UIBarButtonItem appearance] setTintColor:MainTintColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:MainTintColor} forState:UIControlStateNormal];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [NSThread sleepForTimeInterval:1.5f];
    
    return YES;
}

@end
