//
//  CallViewController.h
//  Bopsee
//
//  Created by John on 7/11/16.
//  Copyright © 2015 . All rights reserved.
//

#import "QBBaseViewController.h"

@class QBRTCSession;

@interface CallViewController : QBBaseViewController

@property (strong, nonatomic) QBRTCSession *session;

@end
