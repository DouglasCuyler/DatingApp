//
//  BaseViewController.m
//  BopSee
//
//  Created by John on 1/9/15.
//  Copyright (c) 2015 BopSee. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () 


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //QB session delegate
    [QBRTCClient.instance addDelegate:self];
    
    if(![commonUtils checkKeyInDic:@"user_id" inDic:appController.currentUser] || ![commonUtils checkKeyInDic:@"user_photo_url" inDic:appController.currentUser] || ![commonUtils checkKeyInDic:@"user_name" inDic:appController.currentUser]) {
        if([commonUtils getUserDefault:@"current_user_user_id"] != nil) {
            appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.isLoadingBase = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    return NO;
}

# pragma Top Menu Events
- (IBAction)menuClicked:(id)sender {
    if(self.isLoadingBase) return;
    
}

- (IBAction)menuBackClicked:(id)sender {
    if(self.isLoadingBase) return;
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - QBWebRTCChatDelegate

- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    
    if (self.currentSession) {
        
        [session rejectCall:@{@"reject" : @"busy"}];
        return;
    }
    
    self.currentSession = session;
    
    [QBRTCSoundRouter.instance initialize];
    
    //NSParameterAssert(!self.nav);
    
    IncomingCallViewController *incomingViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"IncomingCallViewController"];
    incomingViewController.delegate = self;
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:incomingViewController];
    
    incomingViewController.session = session;
    
    [self presentViewController:self.nav animated:NO completion:nil];
}

- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.currentSession ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
//            self.nav.view.userInteractionEnabled = NO;
//            [self.nav dismissViewControllerAnimated:YES completion:nil];
//            self.nav = nil;
            
            self.currentSession = nil;
            appController.nextsessionNumber++;
            
            ThinkViewController *thinkController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThinkVC"];
            self.nav.viewControllers = @[thinkController];
            thinkController.delegate = self;
            
        });
    }
}

- (void)incomingCallViewController:(IncomingCallViewController *)vc didAcceptSession:(QBRTCSession *)session {
    appController.incomingstate = @"1";
    MyCallViewController *callViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"MyCallViewController"];
    
    callViewController.session = session;
    self.nav.viewControllers = @[callViewController];
}

- (void)incomingCallViewController:(IncomingCallViewController *)vc didRejectSession:(QBRTCSession *)session{
    appController.incomingstate = @"0";
    [session rejectCall:nil];
    [self.nav dismissViewControllerAnimated:NO completion:nil];
    self.nav = nil;
}

- (void)thinkViewController:(ThinkViewController *)vc
{
    self.nav.view.userInteractionEnabled = NO;
    [self.nav dismissViewControllerAnimated:YES completion:nil];
    self.nav = nil;
    
}

@end
