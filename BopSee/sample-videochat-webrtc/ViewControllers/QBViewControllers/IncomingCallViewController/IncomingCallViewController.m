//
//  IncomingCallViewController.m
//  Bopsee
//
//  Created by John on 7/11/16.
//  Copyright © 2015 . All rights reserved.
//

#import "IncomingCallViewController.h"
#import "ChatManager.h"
#import "CornerView.h"
#import "QBButton.h"
#import "QMSoundManager.h"
#import "UsersDataSource.h"
#import "QBToolBar.h"
#import "QBButtonsFactory.h"
#import "QBUUser+IndexAndColor.h"

@interface IncomingCallViewController () <QBRTCClientDelegate>{
    NSString *callerUserName, *callerImage;
}

@property (weak, nonatomic) IBOutlet UILabel *callStatusLabel;
@property (weak, nonatomic) IBOutlet UITextView *callInfoTextView;
@property (weak, nonatomic) IBOutlet QBToolBar *toolbar;
@property (weak, nonatomic) IBOutlet CornerView *colorMarker;
@property (weak, nonatomic) IBOutlet UIView *viewDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgDate;

@property (weak, nonatomic) NSTimer *dialignTimer;
@end

@implementation IncomingCallViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [QBRTCClient.instance addDelegate:self];
    
    callerUserName = @"Caller";
    [QMSoundManager playRingtoneSound];
    [self defaultToolbarConfiguration];
    
    [commonUtils setCircleViewImage:_viewDate imageview:_imgDate borderWidth:1.0f borderColor:[UIColor lightGrayColor]];
    [_imgDate setImage:[UIImage imageNamed:@"person1"]];
    
    self.users = [UsersDataSource.instance usersWithIDS:self.session.opponentsIDs];
    QBUUser *caller = [UsersDataSource.instance userWithID:self.session.initiatorID];
    NSString *callerID = [NSString stringWithFormat:@"%lu", (unsigned long)caller.ID];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:callerID forKey:@"user_qb_id"];

    //[JSWaiter ShowWaiter:self.view title:nil type:0];
    [NSThread detachNewThreadSelector:@selector(requestUser:) toTarget:self withObject:dic];
}

#pragma mark - request caller user
- (void) requestUser:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_QB_GETUSER withJSON:params];

    //[JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            NSMutableDictionary *callerUser = [[NSMutableDictionary alloc] init];
            callerUser = [result objectForKey:@"get_user"];
            appController.callUser = callerUser;
            callerUserName = [callerUser objectForKey:@"user_full_name"];
            callerImage = [callerUser objectForKey:@"user_photo_url"];
            [self updateOfferInfo];
            
            self.dialignTimer =
            [NSTimer scheduledTimerWithTimeInterval:[QBRTCConfig dialingTimeInterval]
                                             target:self
                                           selector:@selector(dialing:)
                                           userInfo:nil
                                            repeats:YES];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"We can't found the scheduled sessions";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}


- (void)dialing:(NSTimer *)timer {
    [QMSoundManager playRingtoneSound];
}

- (void)defaultToolbarConfiguration {
    
    self.toolbar.backgroundColor = [UIColor clearColor];
    __weak __typeof(self)weakSelf = self;
    
    [self.toolbar addButton:[QBButtonsFactory circleDecline] action: ^(UIButton *sender) {
        
        [weakSelf cleanUp];
        [weakSelf.delegate incomingCallViewController:weakSelf didRejectSession:weakSelf.session];
    }];
    
    [self.toolbar addButton:[QBButtonsFactory answer] action: ^(UIButton *sender) {
        
        [weakSelf cleanUp];
        [weakSelf.delegate incomingCallViewController:weakSelf didAcceptSession:weakSelf.session];
    }];
    
    
    [self.toolbar updateItems];
}

- (void)updateOfferInfo {
    
    self.colorMarker.bgColor = [UIColor colorWithRed:0.039 green:0.376 blue:1.000 alpha:1.000];
    self.colorMarker.title = callerUserName;
    self.colorMarker.fontSize = 20.f;
    
    if ([callerImage isEqual:[NSNull null]]){
        [_imgDate setImage:[UIImage imageNamed:@"person1"]];
    }else{
        [commonUtils setImageViewAFNetworking:_imgDate withImageUrl:callerImage withPlaceholderImage:[UIImage imageNamed:@"person1"]];
    }
    
}

#pragma mark - Actions

- (void)cleanUp {
    
    [self.dialignTimer invalidate];
    self.dialignTimer = nil;
    
    [QBRTCClient.instance removeDelegate:self];
	[QBRTCSoundRouter.instance deinitialize];
    [QMSysPlayer stopAllSounds];
}

- (void)sessionDidClose:(QBRTCSession *)session {
    
      [self cleanUp];
}

@end
