//
//  BaseViewController.h
//  BopSee
//
//  Created by John on 1/9/15.
//  Copyright (c) 2015 BopSee. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Quickblox/Quickblox.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>

//QB ViewControllers
#import "CallViewController.h"
#import "ChatManager.h"
#import "IncomingCallViewController.h"
#import "ThinkViewController.h"


@interface BaseViewController : UIViewController <QBRTCClientDelegate, IncomingCallViewControllerDelegate, ThinkViewControllerDelegate>

@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) QBRTCSession *currentSession;

@property (nonatomic, assign) BOOL isLoadingBase;
@property (strong, nonatomic) NSArray *users;

@property (nonatomic, strong) IBOutlet UIView *topNavBarView, *containerView, *noContentView;
@property (nonatomic, strong) IBOutlet UIImageView *dot;

- (IBAction)menuClicked:(id)sender;
- (IBAction)menuBackClicked:(id)sender;

@end
