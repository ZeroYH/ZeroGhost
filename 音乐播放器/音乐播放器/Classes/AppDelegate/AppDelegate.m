//
//  AppDelegate.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yrh.com. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    /**
     *  友盟统计分析
     */
    // iOS平台数据发送策略包括 BATCH（启动时发送）和 SEND_INTERVAL（按间隔发送）两种,友盟默认使用启动时发送（更省流量）
    
    [MobClick startWithAppkey:@"563bf755e0f55aa32e00479b" reportPolicy:BATCH   channelId:@"Web"];
    
    // version(版本)标识
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    // 当用户使用自有账号登录时，可以这样统计：
    [MobClick profileSignInWithPUID:@"playerID"];
    // 当用户使用第三方账号（如新浪微博）登录时，可以这样统计
    // [MobClick profileSignInWithPUID:@"playerID" provider:@"WB"];
    
    /** 设置是否对日志信息进行加密, 默认NO(不加密). */
    // + (void)setEncryptEnabled:(BOOL)value;
    [MobClick setEncryptEnabled:YES];
    /** 设置是否开启background模式, 默认YES. */
    //+ (void)setBackgroundTaskEnabled:(BOOL)value;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
