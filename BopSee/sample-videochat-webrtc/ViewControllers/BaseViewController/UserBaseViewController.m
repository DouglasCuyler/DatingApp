//
//  UserBaseViewController.m
//  Woof
//
//  Created by John on 1/9/15.
//  Copyright (c) 2015 BopSee. All rights reserved.
//

#import "UserBaseViewController.h"

@interface UserBaseViewController ()

@property (strong, nonatomic) Settings *settings;

@end

@implementation UserBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getAllUsersNoti:)
                                                 name:APP_GetAllUsers
                                               object:nil];


    if([commonUtils getUserDefault:@"current_user_user_id"] != nil && [commonUtils getUserDefault:@"current_user_qb_id"] != nil) {
        appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
        NSLog(@"current user : %@", appController.currentUser);
        
        //QB Settings and get all users
        self.settings = Settings.instance;
        [UsersDataSource.instance loadUsersWithList:self.settings.listType];
     
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DashboardViewController* dashBoardViewController =
        (DashboardViewController*) [storyboard instantiateViewControllerWithIdentifier:@"DashboardVC"];
        [self.navigationController pushViewController:dashBoardViewController animated:YES];
        
        return;
    }
    
    if([[commonUtils getUserDefault:@"logged_out"] isEqualToString:@"1"]) {
        [commonUtils removeUserDefault:@"logged_out"];
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
       // [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    self.isLoadingUserBase = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    return NO;
}

#pragma mark - Nagivate Events
- (void) navToMainView {
    appController.currentMenuTag = @"1";
   
}

#pragma mark - Did Receive Unread Message
- (void)getAllUsersNoti:(NSNotification*) noti {
    [self QBLoginVideoChatWithUser];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:APP_GetAllUsers object:nil];
}

/////////////////////////// QB Video chat login /////////////////////
#pragma Login in chat

- (void)QBLoginVideoChatWithUser{
    
    if([commonUtils getUserDefault:@"current_user_qb_id"] != nil){
        
        NSNumber *currentUserQBID = [NSNumber numberWithUnsignedInteger:[commonUtils getUserDefault:@"current_user_qb_id"].integerValue];
        QBUUser *user = [UsersDataSource.instance userWithID:currentUserQBID];
        [[ChatManager instance] logInWithUser:user completion:^(BOOL error) {
            
            if (!error) {
                
                [self applyConfiguration];
                NSLog(@"QB Login chat Success!", nil);
                [commonUtils showAlert:@"Success" withMessage:@"You have been login to use chat API."];
                [commonUtils setUserDefault:@"QBLogin" withFormat:@"1"];
            }
            else {
                
                NSLog(@"QB Login chat error!", nil);
            }
        } disconnectedBlock:^{
            
            NSLog(@"QB Chat disconnected. Attempting to reconnect!!!", nil);
            
        } reconnectedBlock:^{
            
            NSLog(@"Chat reconnected!!!", nil);
        }];
    }
    else{
        [commonUtils setUserDefault:@"QBLogin" withFormat:@"0"];
        NSLog(@"QB Login chat error!(there is user_qb_id)", nil);
    }
}


- (void)applyConfiguration {
    
    NSMutableArray *iceServers = [NSMutableArray array];
    
    for (NSString *url in self.settings.stunServers) {
        
        QBRTCICEServer *server = [QBRTCICEServer serverWithURL:url username:@"" password:@""];
        [iceServers addObject:server];
    }
    
    [iceServers addObjectsFromArray:[self quickbloxICE]];
    
    [QBRTCConfig setICEServers:iceServers];
    [QBRTCConfig setMediaStreamConfiguration:self.settings.mediaConfiguration];
    [QBRTCConfig setStatsReportTimeInterval:1.f];
}

- (NSArray *)quickbloxICE {
    
    NSString *password = @"baccb97ba2d92d71e26eb9886da5f1e0";
    NSString *userName = @"quickblox";
    
    QBRTCICEServer * stunServer = [QBRTCICEServer serverWithURL:@"stun:turn.quickblox.com"
                                                       username:@""
                                                       password:@""];
    
    QBRTCICEServer * turnUDPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=udp"
                                                          username:userName
                                                          password:password];
    
    QBRTCICEServer * turnTCPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=tcp"
                                                          username:userName
                                                          password:password];
    
    
    return@[stunServer, turnTCPServer, turnUDPServer];
}

@end
