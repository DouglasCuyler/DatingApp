//
//  ThinkViewController.m
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "ThinkViewController.h"

@interface ThinkViewController (){
    NSString* nextTime;
    NSString* see;
}

@end

@implementation ThinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData{
    nextTime = @"1:00";
}

- (void) initView{
    _lblNextTime.text = nextTime;
    _lblDateName.text = [appController.callUser objectForKey:@"user_full_name"];
    [_imgDate setImage:[UIImage imageNamed:[_dateInfo objectForKey:@"image"]]];
    
    if([[appController.callUser objectForKey:@"user_gender"] isEqualToString:@"1"]){
        if ([[appController.callUser objectForKey:@"user_photo_url"] isEqualToString:@""]){
            [_imgDate setImage:[UIImage imageNamed:@"person1"]];
        }else{
            [commonUtils setImageViewAFNetworking:_imgDate withImageUrl:[appController.callUser objectForKey:@"user_photo_url"] withPlaceholderImage:[UIImage imageNamed:@"person1"]];
        }
    }
    else{
        if ([[appController.callUser objectForKey:@"user_photo_url"] isEqual:[NSNull null]]){
            [_imgDate setImage:[UIImage imageNamed:@"person4"]];
        }else{
            [commonUtils setImageViewAFNetworking:_imgDate withImageUrl:[appController.callUser objectForKey:@"user_photo_url"] withPlaceholderImage:[UIImage imageNamed:@"person4"]];
        }
    }

}

- (IBAction)onBopClicked:(id)sender {
    see = @"2";
    [self thinkResult];
}

- (IBAction)onSeeClicked:(id)sender {
    see = @"1";
    [self thinkResult];
}

- (void) thinkResult{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [dic setObject:[appController.callUser objectForKey:@"user_id"] forKey:@"ref_user_id"];
    [dic setObject:see forKey:@"see"];
    
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [NSThread detachNewThreadSelector:@selector(requestBopSee:) toTarget:self withObject:dic];

}

#pragma mark - request bop see
- (void) requestBopSee:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_BOP_SEE withJSON:params];
    
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            __weak __typeof(self)weakSelf = self;
            [weakSelf.delegate thinkViewController:weakSelf];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Sorry, We can't found the session users";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}



    
//    WaitingRoomViewController *waitingRoomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WatingRoomVC"];
//    waitingRoomViewController.session_id = appController.session_id;
//    [self presentViewController:waitingRoomViewController animated:NO completion:nil];
    
//    NSMutableArray *sees = [[NSMutableArray alloc] init];
//    sees = appController.seeUsers;
//    if([see isEqualToString:@"1"]){
//        [sees addObject:_dateInfo];
//    }
//    else{
//        [sees removeObject:_dateInfo];
//    }
//    appController.seeUsers = sees;
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    WrapViewController* wrapViewViewController =
//    (WrapViewController*) [storyboard instantiateViewControllerWithIdentifier:@"WrapVC"];
//    [self.navigationController pushViewController:wrapViewViewController animated:YES];



@end
