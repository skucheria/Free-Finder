//
//  AppDelegate.m
//  Free-Finder
//
//  Created by Will Burford on 3/19/15.
//  Copyright (c) 2015 DDD Development. All rights reserved.
//



#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import <PFFacebookUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    
    // Initialize Parse.
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"sL3KqUdW7K6OEssVTEdsBa8euCmqPeCkNV3dxAqd"
                  clientKey:@"xU7DpogwB2QUUzfsfcd6CmJ8tB84EbXpvT2Ej9jF"];
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // ...
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // iOS 8
        
        //NSLog(@"calling register in iOS 8");
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 7 or iOS 6
        /*NSLog(@"calling register in iOS 7");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];*/
    }
    
    /* Create window */
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[LoginViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Logs 'install' and 'app activate' App Events.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    //NSLog(@"registering for Push");
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation addUniqueObject:@"global" forKey:@"channels"];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
        if (!error) {
            //NSLog(@"saved registering for global channel");
        }
        else {
            //NSLog(@"error in saving global channel: %@ %@",error,error.userInfo);
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
        //NSLog(@"userInfo from push = %@",userInfo);
    [PFPush handlePush:userInfo];
}
@end
