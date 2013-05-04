//
//  HKAppDelegate.m
//  hkutil2
//
//  Created by akwei on 13-4-22.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKAppDelegate.h"
#import "HKRSAUtil.h"
#import "HKViewController.h"

@implementation HKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.viewController = [[HKViewController alloc] initWithNibName:@"HKViewController" bundle:nil];
//    UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//    self.window.rootViewController = navCtrl;
//    [self.window makeKeyAndVisible];
    
    NSString* text = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBALcv2Tm/1ph2EgpsZlB6DdynFT1/F/cSq5kl0ZtpLj6++EtSYQXBqGkminhQ+W309iTBHwoToQzvbV1f1a1yKMEAZ1BWywe0OZWIq9V4Oe2Gr3GFwi36nBOMat7HUnQYkqRoWdYpsQM5+lNMrznYOXnc4D1bSXI210Z1XyXgLfNlAgMBAAECgYB+7m3DgTUOMYnwpQoEK36dbTzffsg5UDuNA9KIsEn1+leLwYou9fBe4/DAy8L5uOoxr4t1bQKENwb902D5LQgk/5iycN29XxV2hSD2HGuDNk8pBfT7dzhhSrd1srCEx++u8GWiGwAVXG3k3iakwlJWn9TFCf3ff3PBsRih73OQhQJBAN0sYkDmxOJ6b57xk/qlr25SH4gpyJoK+reR/231dLO1seFrTQVWcnwd7mrceW1Sm7GsUhn9c6WtObNRk6BcmucCQQDUCDXKQl7VIrwpziBVuBk3X6+k4pfUr9RHtHgsKsEkrEqq2Z49PeiQVmQxsOkrqTHqwmwCTha4sqpxTRIfOaHTAkEAvCXQo5Nss5kiMV0i3FtsJHY6GrQo0Vo7tEO/vgPLtkD/xFpqV/sVQx6XPlK1/VkD155W7YMdiTgWWMQxyH5eywJBANIpfR+IX7UEo9sQC67LNntTZaaaToIq8c9NCxxEGINAHxZvc1Aij+SZLOCwCL4VC3w0z5gNTKovtY9uI/s9Ra8CQQDMxk1QOaCbKm9+c6ArXjN2zSGJjrvFNZX6tzEeUwaR6knCQFs62f4b9EP8//UQzCbnq0d3em+VVkc0+x7jgkD8";
//    NSString* text =@"hello1234567890";
    NSData* textData = [text dataUsingEncoding:NSUTF8StringEncoding];
    HKRSAUtil* rsaUtil = [[HKRSAUtil alloc] init];
    rsaUtil.publicKeyData = [@"com.apple.sample.publickey222" dataUsingEncoding:NSUTF8StringEncoding];
    rsaUtil.privateKeyData = [@"com.apple.sample.privatekey111" dataUsingEncoding:NSUTF8StringEncoding];
    [rsaUtil buildKeyInfo];
    NSData* encData = [rsaUtil encryptData:textData usePublicKey:YES];
    NSData* deData = [rsaUtil decryptData:encData usePublicKey:NO];
    NSString* deText = [[NSString alloc] initWithData:deData encoding:NSUTF8StringEncoding];
    if ([text isEqualToString:deText]) {
        NSLog(@"encrypt and decrypt success");
    }
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
