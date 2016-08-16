//
//  AppDelegate.m
//  BopSee
//
//  Created by John on 06.22.16.
//  Copyright (c) 2016 BopSee Team. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AGPushNoteView.h"
#import "Config.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

const CGFloat kQBRingThickness = 1.f;
const NSTimeInterval kQBAnswerTimeInterval = 60.f;
const NSTimeInterval kQBRTCDisconnectTimeInterval = 30.f;
const NSTimeInterval kQBDialingTimeInterval = 5.f;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window.backgroundColor = [UIColor whiteColor];
    
    //SVProgressHUD preferences
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setRingThickness:kQBRingThickness];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
   
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        [[UINavigationBar appearance] setTranslucent:YES];
    }

    [QBSettings setLogLevel:QBLogLevelNothing];
	[QBSettings setAutoReconnectEnabled:YES];
    //QuickbloxWebRTC preferences
    
    [QBRTCConfig setAnswerTimeInterval:kQBAnswerTimeInterval];
    [QBRTCConfig setDisconnectTimeInterval:kQBRTCDisconnectTimeInterval];
    [QBRTCConfig setDialingTimeInterval:kQBDialingTimeInterval];
    [QBRTCClient initializeRTC];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    //BopSee
    [self updateLocationManager];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    if(launchOptions != nil && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        appController.apnsMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"info"];
        [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"1"];
    }

    return YES;
}

+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)updateLocationManager {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager setDistanceFilter:804.17f]; // Distance Filter as 0.5 mile (1 mile = 1609.34m)
    
    if(IS_OS_8_OR_LATER) {
        [_locationManager requestAlwaysAuthorization];
    }
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [_locationManager stopUpdatingLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [_locationManager startUpdatingLocation];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    [_locationManager startUpdatingLocation];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [commonUtils setUserDefault:@"user_apns_id" withFormat:newToken];
    NSLog(@"My saved token is: %@", [commonUtils getUserDefault:@"user_apns_id"]);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    appController.apnsMessage = [[NSMutableDictionary alloc] init];
    appController.apnsMessage = [[commonUtils removeNilValue:[userInfo objectForKey:@"info"]] mutableCopy];
    
    NSLog(@"APNS Info Fetched : %@", userInfo);
    NSLog(@"My Received Message : %@", appController.apnsMessage);
    
    NSString* alertMessage = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    [AGPushNoteView showWithNotificationMessage:alertMessage];
    [AGPushNoteView setMessageAction:^(NSString *message) {
        // Do something...
    }];
    
    [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"1"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:APP_DidReceivePush
                                                        object:self];
    
    
    [application setApplicationIconBadgeNumber:[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue]];
    
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError(Location): %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        BOOL locationChanged = NO;
        if(![commonUtils getUserDefault:@"currentLatitude"] || ![commonUtils getUserDefault:@"currentLongitude"]) {
            locationChanged = YES;
        } else if(![[commonUtils getUserDefault:@"currentLatitude"] isEqualToString:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]] || ![[commonUtils getUserDefault:@"currentLongitude"] isEqualToString:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]]) {
            locationChanged = YES;
        }
        if(locationChanged) {
//                        [commonUtils setUserDefault:@"currentLatitude" withFormat:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]];
//                        [commonUtils setUserDefault:@"currentLongitude" withFormat:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]];
            
            [commonUtils setUserDefault:@"currentLatitude" withFormat:[NSString stringWithFormat:@"39.53823001"]];
            [commonUtils setUserDefault:@"currentLongitude" withFormat:[NSString stringWithFormat:@"-104.92765594"]];
            
            
            
        }
    }
    
}

- (void)updateUserLocation {  //for update user's coordinate automatically
    NSString *msg = [NSString stringWithFormat:@"%@:%@", [commonUtils getUserDefault:@"currentLatitude"], [commonUtils getUserDefault:@"currentLongitude"]];
    [commonUtils showAlert:@"Location Updated" withMessage:msg];
}


@end


