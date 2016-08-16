//
//  LoginViewController.m
//  Bopsee
//
//  Created by admin on 4/6/16.
//  Copyright © 2016 John. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UIScrollViewDelegate> {
    
    IBOutlet UIScrollView *introScrollView;
    IBOutlet UIView *introScrollContent1View;
    IBOutlet UIView *introScrollContent2View;
    IBOutlet UIView *introScrollContent3View;
    IBOutlet UIView *introScrollContent4View;
    IBOutlet UIView *introScrollContent5View;
    
    IBOutlet UIPageControl *introPageControl;
    int introIndex;
    
}

@property (strong, nonatomic) Settings *settings;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateQBID:)
                                                 name:APP_QBSignUPSuccess
                                               object:nil];
    [self initView];
}

#pragma mark - Did Receive Unread Message
- (void)updateQBID:(NSNotification*) noti {
    [self requestQBID];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APP_QBSignUPSuccess object:nil];
}

- (void) initView {
    
    _termsView.hidden = YES;
    [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bopsee.com/privacy.html"]]];
    [_termsView.layer setZPosition:100];
    
    [introPageControl.layer setZPosition:10];
    
    NSInteger pageCount = 5;
    
    introScrollView.contentSize = CGSizeMake(introScrollView.frame.size.width * pageCount, introScrollView.frame.size.height);
    introScrollView.pagingEnabled = YES;
    [commonUtils removeAllSubViews:introScrollView];
    
    CGRect frame1 = introScrollContent1View.frame;
    frame1.origin.x = 0;
    [introScrollContent1View setFrame:frame1];
    
    CGRect frame2 = introScrollContent2View.frame;
    frame2.origin.x = introScrollView.frame.size.width;
    [introScrollContent2View setFrame:frame2];
    
    CGRect frame3 = introScrollContent3View.frame;
    frame3.origin.x = introScrollView.frame.size.width * 2;
    [introScrollContent3View setFrame:frame3];
    
    CGRect frame4 = introScrollContent4View.frame;
    frame4.origin.x = introScrollView.frame.size.width * 3;
    [introScrollContent4View setFrame:frame4];

    CGRect frame5 = introScrollContent5View.frame;
    frame5.origin.x = introScrollView.frame.size.width * 4;
    [introScrollContent5View setFrame:frame5];

    
    [introScrollView addSubview:introScrollContent1View];
    [introScrollView addSubview:introScrollContent2View];
    [introScrollView addSubview:introScrollContent3View];
    [introScrollView addSubview:introScrollContent4View];
    [introScrollView addSubview:introScrollContent5View];
    
    introScrollView.pagingEnabled = YES;
    introIndex = 0;
    
    [self setIntro];
}

- (IBAction)onClickedTerms:(id)sender {
    
    _termsView.hidden = NO;
}
- (IBAction)onClickedTermsCancel:(id)sender {
    _termsView.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.2];
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    introIndex = (introScrollView.contentOffset.x / introScrollView.frame.size.width);
    [self setIntro];
}
- (void)setIntro {
    introPageControl.currentPage = introIndex;
}


- (IBAction)onFBSignInClicked:(id)sender {
    if(self.isLoadingUserBase) return;
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_birthday", @"user_photos"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in with token : @%@", result.token);
             if ([result.grantedPermissions containsObject:@"email"]) {
                 NSLog(@"result is:%@",result);
                 [self fetchUserInfo];
             }
         }
     }];

}

- (void)fetchUserInfo {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken] tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, gender, bio, education, location, friends, hometown, friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"facebook fetched info : %@", result);
                 
                 NSDictionary *temp = (NSDictionary *)result;
                 NSMutableDictionary *userFBInfo = [[NSMutableDictionary alloc] init];

                 [userFBInfo setObject:[temp objectForKey:@"id"] forKey:@"user_facebook_id"];
                 [userFBInfo setObject:[temp objectForKey:@"email"] forKey:@"user_email"];
                 
                 if([commonUtils checkKeyInDic:@"name" inDic:[temp mutableCopy]]) {
                     [userFBInfo setObject:[temp objectForKey:@"name"] forKey:@"user_full_name"];
                 }
                 
                 NSString *gender = @"1";
                 if([commonUtils checkKeyInDic:@"gender" inDic:[temp mutableCopy]]) {
                     if([[temp objectForKey:@"gender"] isEqualToString:@"female"]) gender = @"2";
                 }
                 [userFBInfo setObject:gender forKey:@"user_gender"];
                 
                 NSString *age = @"27";
                 
                 if([commonUtils checkKeyInDic:@"birthday" inDic:[temp mutableCopy]]) {
                     
                     NSArray *array = [[temp objectForKey:@"birthday"] componentsSeparatedByString:@"/"];
                     if([[array objectAtIndex:2] isEqualToString:@"0000"]){
                         age = @"30";
                     }
                     else{
                         age = [commonUtils ageCount:[array objectAtIndex:2]];
                         NSLog(@"-----Age:%@", age);
                     }

                 }
                 [userFBInfo setObject:age forKey:@"user_age"];
                 
                 NSString *fbProfilePhoto = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [temp objectForKey:@"id"]];
                 [userFBInfo setObject:fbProfilePhoto forKey:@"user_photo_url"];
                 
                 [userFBInfo setObject:@"Yale University" forKey:@"user_school"];
                 
//                 if([commonUtils getUserDefault:@"currentLatitude"] && [commonUtils getUserDefault:@"currentLongitude"]) {
//                     [userFBInfo setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_location_latitude"];
//                     [userFBInfo setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"user_location_longitude"];
//                 }
                 
                 if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
                     [userFBInfo setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
                     
                     self.isLoadingUserBase = YES;
                     [JSWaiter ShowWaiter:self.view title:@"Log in..." type:0];
                     [self requestData:userFBInfo];
                     
                 } else {
                     [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new activities." duration:1.0f done:^(DoAlertView *alertView) {
                         
                         self.isLoadingUserBase = YES;
                         [JSWaiter ShowWaiter:self.view title:@"Login..." type:0];
                         [self requestData:userFBInfo];
                     }];
                 }
                 
             } else {
                 NSLog(@"Error %@",error);
             }
         }];
    }
    
}


#pragma mark - API Request - User Signup After FB Login
- (void) requestData:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_FBLOGIN withJSON:(NSMutableDictionary *) params];
    
    self.isLoadingUserBase = NO;
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            [commonUtils setUserDefault:@"current_user_user_id" withFormat:[appController.currentUser objectForKey:@"user_id"]];
            [self QBcheckandSignin:appController.currentUser];

        } else {
            [JSWaiter HideWaiter];
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Warning" body:msg duration:1.4];
            
        }
    }else {
        [JSWaiter HideWaiter];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
    
}

- (void) QBcheckandSignin:(NSDictionary*)currentUser{
    if([[currentUser objectForKey:@"user_qb_id"] isEqualToString:@""]){
        [commonUtils QBSignup:[currentUser objectForKey:@"user_email"]];
    }
    else{
        [JSWaiter HideWaiter];
        [commonUtils setUserDefault:@"current_user_qb_id" withFormat:[currentUser objectForKey:@"user_qb_id"]];
        
        //QB Settings and get all users
        self.settings = Settings.instance;
        [UsersDataSource.instance loadUsersWithList:self.settings.listType];
        
        NSLog(@"current user : %@", currentUser);
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        HelpViewController* helpViewController =
//        (HelpViewController*) [storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
//        [self.navigationController pushViewController:helpViewController animated:YES];
        UserInfoViewController* userinfoViewController =
        (UserInfoViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserInfoVC"];
        [self.navigationController pushViewController:userinfoViewController animated:YES];
    }
}

- (void) requestQBID {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[commonUtils getUserDefault:@"current_user_user_id"] forKey:@"user_id"];
    [params setObject:[commonUtils getUserDefault:@"current_user_qb_id"] forKey:@"user_qb_id"];
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_QBID withJSON:(NSMutableDictionary *) params];
    
    self.isLoadingUserBase = NO;
    [JSWaiter HideWaiter];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            //QB Settings and get all users
            self.settings = Settings.instance;
            [UsersDataSource.instance loadUsersWithList:self.settings.listType];

            NSLog(@"current user : %@", appController.currentUser);
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            HelpViewController* helpViewController =
//            (HelpViewController*) [storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
//            [self.navigationController pushViewController:helpViewController animated:YES];
            
            UserInfoViewController* userinfoViewController =
                        (UserInfoViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserInfoVC"];
                        [self.navigationController pushViewController:userinfoViewController animated:YES];


        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Warning" body:msg duration:1.4];
            
        }
    }else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }

}

@end
