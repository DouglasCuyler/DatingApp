//
//  WaitingRoomViewController.m
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "WaitingRoomViewController.h"



@interface WaitingRoomViewController () 
{
    NSMutableArray *roomUsers, *roomAUsers, *userImages;
    NSMutableDictionary *date;
    NSString* user_qb_id;
    NSString *session_time, *dateNumber;
    NSString *date1Image, *date2Image, *date3Image, *date4Image, *date5Image, *date6Image;
    BOOL loopmin;
}

@end

@implementation WaitingRoomViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([appController.incomingstate isEqualToString:@"0"]){
        if (appController.nextsessionNumber > 5) {
            loopmin = YES;
            appController.nextsessionNumber = 0;
            _lblStartTime.text = @"your session is completed";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WrapViewController* wrapViewViewController =
            (WrapViewController*) [storyboard instantiateViewControllerWithIdentifier:@"WrapVC"];
            [self.navigationController pushViewController:wrapViewViewController animated:YES];
            
        }
        else if(appController.nextsessionNumber > 0){
            [self nextSession];
        }
    }
}

- (void) nextSession{
    _lblStartTime.text = @"your session will start in 1 minutes";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self getQBIDandOut:appController.nextsessionNumber];
    });
}

- (void) initData{
    roomAUsers = [[NSMutableArray alloc] init];
    roomUsers = [[NSMutableArray alloc] init];
    userImages = [[NSMutableArray alloc] init];
    if(_sm_id != nil && ![_sm_id isEqualToString:@""]){
        
        if(self.isLoadingBase) return;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
        [dic setObject:_sm_id forKey:@"sm_id"];
        
        self.isLoadingBase = YES;
        [JSWaiter ShowWaiter:self.view title:nil type:0];
        [NSThread detachNewThreadSelector:@selector(requestUsers:) toTarget:self withObject:dic];
    }
    
}

#pragma mark - request scheduled sessions
- (void) requestUsers:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_ROOM_USERS withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            roomAUsers = [result objectForKey:@"room_userAs"];
            roomUsers = [result objectForKey:@"room_users"];
            session_time = [result objectForKey:@"session_time"];
            [self initView];
            [self showRemainTime];
            loopmin = NO;
            [self loopMin];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Sorry, We can't found the session users";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}

- (void)loopMin{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"loop");
        [self showRemainTime];
        if(loopmin == NO){
            [self loopMin];
        }
    });
}

- (void)showRemainTime{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init]; 
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *sessiondate = [dateFormat dateFromString:session_time];
    
    NSTimeInterval secondsBetween = [sessiondate timeIntervalSinceDate:[NSDate date]];
    int numberOfMins = secondsBetween / 60;
    //int numberOfSecs = (int)secondsBetween % 60;
    _lblStartTime.text = [NSString stringWithFormat:@"your session will start in %d minutes", numberOfMins];
    //_lblStartTime.text = [NSString stringWithFormat:@"%d minutes %d s", numberOfMins, numberOfSecs];
    
    if(numberOfMins <= 0 && numberOfMins > -2){
        appController.nextsessionNumber = 0;
        loopmin = YES;
        [self getQBIDandOut:0];
    }

}

- (void) initView{
    
    [self showRemainTime];
    
    if([[[appController.currentUser objectForKey:@"user_preference"] objectForKey:@"user_settings_gender"]isEqualToString:@"1"]){
        [_imgDate1 setImage:[UIImage imageNamed:@"person1"]];
        [_imgDate2 setImage:[UIImage imageNamed:@"person2"]];
        [_imgDate3 setImage:[UIImage imageNamed:@"person3"]];
        [_imgDate4 setImage:[UIImage imageNamed:@"person2"]];
        [_imgDate5 setImage:[UIImage imageNamed:@"person3"]];
        [_imgDate6 setImage:[UIImage imageNamed:@"person1"]];
    }
    else{
        [_imgDate1 setImage:[UIImage imageNamed:@"person4"]];
        [_imgDate2 setImage:[UIImage imageNamed:@"person5"]];
        [_imgDate3 setImage:[UIImage imageNamed:@"person6"]];
        [_imgDate4 setImage:[UIImage imageNamed:@"person5"]];
        [_imgDate5 setImage:[UIImage imageNamed:@"person6"]];
        [_imgDate6 setImage:[UIImage imageNamed:@"person4"]];
    }
    
//    for(NSMutableDictionary* user in roomUsers){
//        [userImages addObject:[user objectForKey:@"user_photo_url"]];
//    }
//    
    [commonUtils setCircleViewImage:_viewDate1 imageview:_imgDate1 borderWidth:1.0f borderColor:[UIColor lightGrayColor]];
//    if ([[userImages objectAtIndex:0] isEqual:[NSNull null]]){
//        [_imgDate1 setImage:[UIImage imageNamed:@"person1"]];
//    }else{
//        [commonUtils setImageViewAFNetworking:_imgDate1 withImageUrl:[userImages objectAtIndex:0] withPlaceholderImage:[UIImage imageNamed:@"person1"]];
//    }
    
    [commonUtils setCircleViewImage:_viewDate2 imageview:_imgDate2 borderWidth:1.0f borderColor:[UIColor lightGrayColor]];
//    if ([[userImages objectAtIndex:1] isEqual:[NSNull null]]){
//        [_imgDate2 setImage:[UIImage imageNamed:@"person2"]];
//    }else{
//        [commonUtils setImageViewAFNetworking:_imgDate2 withImageUrl:[userImages objectAtIndex:1] withPlaceholderImage:[UIImage imageNamed:@"person2"]];
//    }
    
    [commonUtils setCircleViewImage:_viewDate3 imageview:_imgDate3 borderWidth:1.0f borderColor:[UIColor lightGrayColor]];
//    if ([[userImages objectAtIndex:2] isEqual:[NSNull null]]){
//        [_imgDate3 setImage:[UIImage imageNamed:@"person3"]];
//    }else{
//        [commonUtils setImageViewAFNetworking:_imgDate3 withImageUrl:[userImages objectAtIndex:2] withPlaceholderImage:[UIImage imageNamed:@"person3"]];
//    }
    
    [commonUtils setCircleViewImage:_viewDate4 imageview:_imgDate4 borderWidth:1.0f borderColor:[UIColor lightGrayColor]];
//    if ([[userImages objectAtIndex:3] isEqual:[NSNull null]]){
//        [_imgDate4 setImage:[UIImage imageNamed:@"person4"]];
//    }else{
//        [commonUtils setImageViewAFNetworking:_imgDate4 withImageUrl:[userImages objectAtIndex:3] withPlaceholderImage:[UIImage imageNamed:@"person4"]];
//    }
    
    [commonUtils setCircleViewImage:_viewDate5 imageview:_imgDate5 borderWidth:1.0f borderColor:[UIColor lightGrayColor]];
//    if ([[userImages objectAtIndex:4] isEqual:[NSNull null]]){
//        [_imgDate5 setImage:[UIImage imageNamed:@"person5"]];
//    }else{
//        [commonUtils setImageViewAFNetworking:_imgDate5 withImageUrl:[userImages objectAtIndex:4] withPlaceholderImage:[UIImage imageNamed:@"person5"]];
//    }
    
    [commonUtils setCircleViewImage:_viewDate6 imageview:_imgDate6 borderWidth:1.0f borderColor:[UIColor lightGrayColor]];
//    if ([[userImages objectAtIndex:5] isEqual:[NSNull null]]){
//        [_imgDate6 setImage:[UIImage imageNamed:@"person6"]];
//    }else{
//        [commonUtils setImageViewAFNetworking:_imgDate6 withImageUrl:[userImages objectAtIndex:5] withPlaceholderImage:[UIImage imageNamed:@"person6"]];
//    }
}

- (IBAction)onBackClicked:(id)sender {
    loopmin = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDate1Clicked:(id)sender {
    [self getQBIDandOut:0];
}

- (IBAction)onDate2Clicked:(id)sender {
    [self getQBIDandOut:1];
}

- (IBAction)onDate3Clicked:(id)sender {
    [self getQBIDandOut:2];
}

- (IBAction)onDate4Clicked:(id)sender {
    [self getQBIDandOut:3];
}

- (IBAction)onDate5Clicked:(id)sender {
    [self getQBIDandOut:4];
}

- (IBAction)onDate6Clicked:(id)sender {
    [self getQBIDandOut:5];
}

- (void)getQBIDandOut:(int)index{
    
    if([roomUsers count] > index){
        user_qb_id = [[roomUsers objectAtIndex:index] objectForKey:@"user_qb_id"];
        //get Call User
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:user_qb_id forKey:@"user_qb_id"];
        
        [JSWaiter ShowWaiter:self.view title:nil type:0];
        [NSThread detachNewThreadSelector:@selector(requestUser:) toTarget:self withObject:dic];
        
    }
    else{
        [commonUtils showAlert:@"Warning" withMessage:@"It is not enough the user for chat. Please check session users"];
    }
}

#pragma mark - request call user
- (void) requestUser:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_QB_GETUSER withJSON:params];
    
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            NSMutableDictionary *callerUser = [[NSMutableDictionary alloc] init];
            callerUser = [result objectForKey:@"get_user"];
            appController.callUser = callerUser;
            NSNumber *user_id = [NSNumber numberWithUnsignedInteger:user_qb_id.integerValue];
            [self outgoing:user_id];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"We can't found the scheduled sessions";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}

- (void)outgoing:(NSNumber*)user_id{
    
    if([[commonUtils getUserDefault:@"QBLogin"] isEqualToString:@"1"]){
        loopmin = YES;
        if(!self.currentSession){
            [self callWithConferenceType:QBRTCConferenceTypeVideo userID:user_id];
        }
    }
    else{
        [commonUtils showAlert:@"Warning" withMessage:@"You should login to use chat API. Session hasn’t been created. Please wait a moment."];
        //restart
    }
}

- (void)callWithConferenceType:(QBRTCConferenceType)conferenceType userID:(NSNumber*) user_id{
    
    NSParameterAssert(!self.currentSession);
    NSParameterAssert(!self.nav);
    
    NSMutableArray *ids = [[NSMutableArray alloc] init];
    [ids addObject:user_id];
    NSArray *opponentsIDs = ids;
    //Create new session
    QBRTCSession *session = [QBRTCClient.instance createNewSessionWithOpponents:opponentsIDs withConferenceType:conferenceType];
    
    if (session) {
        
        appController.incomingstate = @"0";
        self.currentSession = session;
        MyCallViewController *callViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCallViewController"];
        callViewController.session = self.currentSession;
        
        self.nav = [[UINavigationController alloc] initWithRootViewController:callViewController];
        [self presentViewController:self.nav animated:NO completion:nil];
    }
    else {
        
        [commonUtils showAlert:@"Warning" withMessage:@"You should login to use chat API. Session hasn’t been created. Please try to relogin the chat."];
    }
}


@end
