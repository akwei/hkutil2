//
//  HKAppDelegate.m
//  hkutil2
//
//  Created by akwei on 13-4-22.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKAppDelegate.h"
#import "HKViewController.h"
#import "HKEncUtil.h"
#import "HKRSAUtil.h"
#import "HKAFHTTPClient.h"

@implementation HKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.viewController = [[HKViewController alloc] initWithNibName:@"HKViewController" bundle:nil];
//    UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//    self.window.rootViewController = navCtrl;
//    [self.window makeKeyAndVisible];
    
    [self testHTTP];
    return YES;
}

-(void)testHTTP{
    for (int i=0; i<10; i++) {
        HKAFHTTPClient* client = [[HKAFHTTPClient alloc] init];
        client.timeout = 10;
        client.baseUrl = @"http://www.yibao.com";
        client.subUrl = @"showdemo/consult";
        [client addString:@"vJkREBr9WUvf4ucPGP5v8bPz2eYlmy4fz3BqQ3jZe3k=" forKey:@"data"];
        [client doPost];
//        NSLog(@"count=%d",i+1);
//        NSLog(@"%@",[client description]);
        NSLog(@"responseString:%@",client.responseString);
//        for (NSHTTPCookie* cookie in client.responseCookies) {
//            NSLog(@"cookie name=%@ value=%@",cookie.name,cookie.value);
//        }
        if (client.error) {
            NSLog(@"%@",[client.error description]);
        }
    }
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
