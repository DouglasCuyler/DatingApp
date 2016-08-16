//
//  UserImportViewController.m
//  Bopsee
//
//  Created by Admin on 6/13/16.
//  Copyright © 2016 John. All rights reserved.
//

#import "UserImportViewController.h"

@interface UserImportViewController ()

@end

@implementation UserImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initView{
    
    self.btnAccept.layer.cornerRadius = 25.0f;
    self.btnDecline.layer.cornerRadius = 25.0f;
   
    [commonUtils setCircleViewImage:_viewUserImage imageview:_imgUser borderWidth:2.0f borderColor:[UIColor lightGrayColor]];
    
    NSString* avatarImageURL = [self.userFBInfo objectForKey:@"user_photo_url"];
    NSLog(@"avatar image URL : %@", avatarImageURL);
    if ([avatarImageURL isEqual:[NSNull null]]){
        [_imgUser setImage:[UIImage imageNamed:@"no_photo"]];
    }else{
        
        [commonUtils setImageViewAFNetworking:_imgUser withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"no_photo"]];
    }

}


- (IBAction)onClickedAccept:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserInfoViewController* userInfoViewController =
            (UserInfoViewController*) [storyboard instantiateViewControllerWithIdentifier:@"UserInfoVC"];
    [self.navigationController pushViewController:userInfoViewController animated:YES];

}

- (IBAction)onClickedDecline:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


@end
