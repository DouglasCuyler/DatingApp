//
//  AppDelegate.h
//  BopSee
//
//  Created by John on 06.22.16.
//  Copyright (c) 2016 BopSee Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, retain) CLLocationManager *locationManager;

- (void)updateLocationManager;

+(AppDelegate *)sharedAppDelegate;

@end

