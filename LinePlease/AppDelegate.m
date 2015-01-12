//
//  AppDelegate.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "Line.h"
#import "Script.h"

#import "TestFlight.h"
#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  //ensure you register the subclass
  [User registerSubclass];
  [Line registerSubclass];
  [Script registerSubclass];

  [Parse setApplicationId:@"x" clientKey:@"x"];
  [PFFacebookUtils initializeFacebook];
  //    [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor colorWithRed:195/255.0f green:182/255.0f blue:217/255.0f alpha:1.0];
  [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor redColor];

  [TestFlight takeOff:@"x"];

  [Appirater setAppId:@"x"];
  [Appirater setDaysUntilPrompt:3];
  [Appirater setUsesUntilPrompt:5];
  [Appirater setSignificantEventsUntilPrompt:1];
  [Appirater setTimeBeforeReminding:2];

  return YES;

  //471665690
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [PFFacebookUtils handleOpenURL:url];
}

@end
