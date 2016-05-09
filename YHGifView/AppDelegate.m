//
//  AppDelegate.m
//  YHGifView
//
//  Created by 邱弘宇 on 16/4/5.
//  Copyright © 2016年 YH. All rights reserved.
//

#import "AppDelegate.h"
#import "YHGifView.h"

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //Pre Loading Has a certain memory limit, please priority to load a larger picture, otherwise may cause some pictures unable to load the BUG
    [YHGifView sharedInstance].style = YHGifViewStyleBlue;
    [YHGifView viewWithGIFNamed:@"gif1"];
    [YHGifView viewWithGIFNamed:@"gif2"];
    [YHGifView viewWithGIFNamed:@"gif3"];
    [YHGifView viewWithGIFNamed:@"gif4"];
    [YHGifView viewWithGIFNamed:@"gif5"];
    [YHGifView viewWIthURL:@"http://img5q.duitang.com/uploads/item/201411/22/20141122124903_tYYds.gif"];
    [YHGifView viewWIthURL:@"http://pic30.nipic.com/20130618/13006969_043837967000_2.gif"];
    [YHGifView sharedInstance].cornerRadius = 5;
    __weak typeof(self) weakSelf = self;
    [YHGifView sharedInstance].didTapMaskTypeViewBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return ;
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"隐藏提示框" message:nil delegate:strongSelf cancelButtonTitle:@"cancel" otherButtonTitles:@"determine", nil];
        [alert show];
    };
    [YHGifView sharedInstance].didTapGifViewBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return ;
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Dismiss GifView" message:nil delegate:strongSelf cancelButtonTitle:@"cancel" otherButtonTitles:@"determine", nil];
        [alert show];
    };
    // Override point for customization after application launch.
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }
    [YHGifView dismiss];
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
