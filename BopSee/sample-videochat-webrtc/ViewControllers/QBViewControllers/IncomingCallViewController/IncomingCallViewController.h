//
//  IncomingCallViewController.h
//  Bopsee
//
//  Created by John on 7/11/16.
//  Copyright © 2015 . All rights reserved.
//

#import "QBBaseViewController.h"

@protocol IncomingCallViewControllerDelegate;

@interface IncomingCallViewController : QBBaseViewController

@property (weak, nonatomic) id <IncomingCallViewControllerDelegate> delegate;

@property (strong, nonatomic) QBRTCSession *session;

@end

@protocol IncomingCallViewControllerDelegate <NSObject>

- (void)incomingCallViewController:(IncomingCallViewController *)vc didAcceptSession:(QBRTCSession *)session;
- (void)incomingCallViewController:(IncomingCallViewController *)vc didRejectSession:(QBRTCSession *)session;

@end
