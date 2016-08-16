//
//  SettingsViewController.m
//  Bopsee
//
//  Created by Admin on 6/14/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "FeedBackViewController.h"

@interface SettingsViewController (){
    NSMutableArray* settingsList;
}


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData{
    settingsList = appController.settingsList;
}

- (void) initView{
    
    
    [commonUtils setCircleViewImage:_viewUserImage imageview:_imgUser borderWidth:0.0f borderColor:[UIColor clearColor]];
    
    NSString* avatarImageURL = [appController.currentUser objectForKey:@"user_photo_url"];
    NSLog(@"avatar image URL : %@", avatarImageURL);
    if ([avatarImageURL isEqual:[NSNull null]]){
        [_imgUser setImage:[UIImage imageNamed:@"no_photo"]];
        [_imgBack setImage:[UIImage imageNamed:@"user1"]];
    }else{
        
        [commonUtils setImageViewAFNetworking:_imgUser withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"no_photo"]];
        [commonUtils setImageViewAFNetworking:_imgBack withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"user1"]];
    }

    
    CGFloat cornerRadius = MAX(_imgUser.frame.size.width, _imgUser.frame.size.height);
    _imgUser.layer.cornerRadius = cornerRadius/2;
    _imgUser.clipsToBounds = YES;
    
    NSString* fullName = [appController.currentUser objectForKey:@"user_full_name"];
    if (fullName != nil){
        _lblName.text = fullName;
    }
    else{
        _lblName.text = @" ";
    }
    
}

- (IBAction)onBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickedEditProfile:(id)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ProfileViewController* profileViewController =
//    (ProfileViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
//    [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [settingsList count];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsTableViewCell"];
    
    cell.lblSettings.text = [settingsList objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MachesViewController* matchesViewController =
//    (MachesViewController*) [storyboard instantiateViewControllerWithIdentifier:@"MatchesVC"];
//    
//    PreferencesViewController* preferenceViewController =
//    (PreferencesViewController*) [storyboard instantiateViewControllerWithIdentifier:@"PreferencesVC"];
//    
//    FeedBackViewController* feedbackViewController =
//    (FeedBackViewController*) [storyboard instantiateViewControllerWithIdentifier:@"FeedBackVC"];
    
    AppSettingsViewController* appSettingsViewController =
    (AppSettingsViewController*) [storyboard instantiateViewControllerWithIdentifier:@"AppSettingsVC"];
    
    HelpViewController* helpViewController =
    (HelpViewController*) [storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
    
    ProfileViewController* profileViewController =
    (ProfileViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
    
    switch ((int)indexPath.row) {
        case HELP_SUPPORT:
            [self.navigationController pushViewController:helpViewController animated:YES];
            break;
            
        case EDIT_PROFILE:
            [self.navigationController pushViewController:profileViewController animated:YES];
            break;

        case APPSETTINGS:
            [self.navigationController pushViewController:appSettingsViewController animated:YES];
            break;

        default:
            break;
    }
    
}

@end
