//
//  AppSettingsViewController.m
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "AppSettingsViewController.h"
#import "FeedBackViewController.h"
#import "EthnicityTableViewCell.h"

@interface AppSettingsViewController (){
    int ageMin;
    int ageMax;
    int heightMin;
    int heightMax;
    NSString* gender;
    NSString* ethnicity;
    NSString* city;
    BOOL changedFlag;
    
    NSMutableArray *clickEthnicity;
}

@end

@implementation AppSettingsViewController

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

-(void)viewWillAppear:(BOOL)animated{
    if (appController.sel_Cancel != 0) {
        _lblCity.text = appController.selectAddress;
    }
}

- (void) initData{
    
    changedFlag = NO;
    NSMutableDictionary *user_preference = [appController.currentUser objectForKey:@"user_preference"];
    if([[user_preference objectForKey:@"user_settings_gender"] intValue] == 1){
        gender = @"Male";
    }
    else{
        gender = @"Female";
    }
    ageMin = [[user_preference objectForKey:@"user_settings_age_min"] intValue];
    ageMax = [[user_preference objectForKey:@"user_settings_age_max"] intValue];
    heightMin = [[user_preference objectForKey:@"user_settings_height_min"] intValue];
    heightMax = [[user_preference objectForKey:@"user_settings_height_max"] intValue];
    ethnicity = [user_preference objectForKey:@"user_settings_ethnicity"];
    city = [user_preference objectForKey:@"user_settings_city"];
    
    clickEthnicity = [[NSMutableArray alloc] init];
    for(int i = 0; i < appController.ethnicityList.count; i++) [clickEthnicity addObject:@"0"];
    
}


- (void) initView{
    
    CGSize size = self.mainScroll.contentSize;
    size.height = 1150;
    [self.mainScroll setContentSize:size];
    
    //Alert View
    _viewAlertCon.layer.cornerRadius = 3.0f;
    _btnYes.layer.cornerRadius = 13.0f;
    _btnNo.layer.cornerRadius = 13.0f;
    _viewAlert.hidden = YES;
    
    //Ethnicity View
    _viewEthnicity.layer.cornerRadius = 7.0f;
    _viewEthnicity.layer.borderWidth = 1.0f;
    _viewEthnicity.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _btnOK.layer.cornerRadius = 5.0f;
    _viewEthnicity.hidden = YES;
    
    _swText.on = YES;
    _swEmail.on = YES;
    _swMessage.on = YES;
    _swDate.on = YES;
    
    _lblGender.text = gender;
    _lblEthnicity.text = ethnicity;
    _lblCity.text = city;
    [self configureAgeSlider];
    [self configureHeightSlider];
    
}

- (IBAction)ageRangeSlider:(id)sender {
    changedFlag = YES;
    [self updateAgeRange];
}

- (IBAction)heightRangeSlider:(id)sender {
    changedFlag = YES;
    [self updateHeightRange];
}

- (void) updateAgeRange{
    
    _lblAgeRange.text = [NSString stringWithFormat:@"%d-%d",(int)(_ageSlider.lowerValue * 100),(int)(_ageSlider.upperValue * 100)];
}

- (void) updateHeightRange{
    int ftLower = (int)(((float)_heightSlider.lowerValue * 100) / 12);
    int inLower = (int)((int)((float)_heightSlider.lowerValue * 100) % 12);
    int ftUpper = (int)(((float)_heightSlider.upperValue * 100) / 12);
    int inUpper = (int)((int)((float)_heightSlider.upperValue * 100) % 12);
    _lblHeightRange.text = [NSString stringWithFormat:@"%d' %d\"-%d' %d\"", ftLower, inLower, ftUpper, inUpper];
}

- (IBAction)onClickedGender:(id)sender {
    changedFlag = YES;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _viewPic.frame;
        _viewPic.frame = CGRectMake(0, self.view.frame.size.height - rect.size.height, rect.size.width, rect.size.height);
    }];
}
- (IBAction)onClickedDone:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _viewPic.frame;
        _viewPic.frame = CGRectMake(0, self.view.frame.size.height, rect.size.width, rect.size.height);
    }];
}

- (IBAction)onClickedEthni:(id)sender {
    _viewEthnicity.hidden = NO;
}

- (IBAction)onClickedCity:(id)sender {
    appController.sel_Cancel = 0;
    changedFlag = YES;
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"findLocationPage"];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)onClickedOK:(id)sender {
    _viewEthnicity.hidden = YES;
    NSString *ethni = @" ";
    for(int i = 0; i < appController.ethnicityList.count; i++){
        if([[clickEthnicity objectAtIndex:i] isEqualToString:@"1"]){
            if([ethni isEqualToString:@" "]){
                ethni = [NSString stringWithFormat:@"%@", [appController.ethnicityList objectAtIndex:i]];
            }else{
                ethni = [NSString stringWithFormat:@"%@, %@", ethni, [appController.ethnicityList objectAtIndex:i]];
            }
        }
    }
    ethnicity = ethni;
    _lblEthnicity.text = ethnicity;
}


- (IBAction)onBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender {
    if(self.isLoadingBase) return;
    
    if(!changedFlag){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        if([commonUtils isFormEmpty:[@[_lblGender.text, _lblEthnicity.text, _lblCity.text] mutableCopy]]) {
            [commonUtils showAlert:@"Warning" withMessage:@"Please complete the entire form"];
        }
        else{
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
            [dic setObject:[NSString stringWithFormat:@"%d", (int)((float)_ageSlider.lowerValue * 100)] forKey:@"user_settings_age_min"];
            [dic setObject:[NSString stringWithFormat:@"%d", (int)((float)_ageSlider.upperValue * 100)] forKey:@"user_settings_age_max"];
            [dic setObject:[NSString stringWithFormat:@"%d", (int)((float)_heightSlider.lowerValue * 100)] forKey:@"user_settings_height_min"];
            [dic setObject:[NSString stringWithFormat:@"%d", (int)((float)_heightSlider.upperValue * 100)] forKey:@"user_settings_height_max"];
            [dic setObject:_lblEthnicity.text forKey:@"user_settings_ethnicity"];
            [dic setObject:_lblCity.text forKey:@"user_settings_city"];
            if([_lblGender.text isEqual:@"Male"]){
                [dic setObject:@"1" forKey:@"user_settings_gender"];
            }
            else{
                [dic setObject:@"2" forKey:@"user_settings_gender"];
            }
            self.isLoadingBase = YES;
            [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
            [NSThread detachNewThreadSelector:@selector(requestUpdateSettings:) toTarget:self withObject:dic];
        }
        
    }
}

#pragma mark - request data user settings change
- (void) requestUpdateSettings:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_PREFERENCE_UPDATE withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefault:@"settingChanged" withFormat:@"1"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            NSLog(@"------------user info updated setting : %@", appController.currentUser);
            appController.scheduledSessions = [[NSMutableArray alloc] init];
            appController.matchedUsers = [[NSMutableArray alloc] init];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DashboardViewController* dashboardViewController =
            (DashboardViewController*) [storyboard instantiateViewControllerWithIdentifier:@"DashboardVC"];
            [self.navigationController pushViewController:dashboardViewController animated:YES];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}



- (IBAction)onDisableClicked:(id)sender {
    _viewAlert.hidden = NO;
}

- (IBAction)onYESClicked:(id)sender {
    
    _viewAlert.hidden = YES;
  
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    
    self.isLoadingBase = YES;
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [NSThread detachNewThreadSelector:@selector(requestDisable:) toTarget:self withObject:dic];
}

#pragma mark - request disable account
- (void) requestDisable:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_DISABLE withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            [commonUtils removeUserDefaultDic:@"current_user"];
            appController.currentUser = [[NSMutableDictionary alloc] init];
            [commonUtils setUserDefault:@"logged_out" withFormat:@"1"];
            appController.scheduledSessions = [[NSMutableArray alloc] init];
            appController.matchedUsers = [[NSMutableArray alloc] init];
           // NSLog(@"QB current User %@", [UsersDataSource.instance.currentUser]);
            
            [QBRequest deleteCurrentUserWithSuccessBlock:^(QBResponse *response) {
                // Successful response with user
                NSLog(@"success QB account delete");
            } errorBlock:^(QBResponse *response) {
                // Handle error
            }];
            [commonUtils QBlogout];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"We can't remove the your account";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}

- (IBAction)onNOClicked:(id)sender {
    _viewAlert.hidden = YES;
}


- (IBAction)onLogoutClicked:(id)sender {
    
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
   
    self.isLoadingBase = YES;
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [NSThread detachNewThreadSelector:@selector(requestLogout:) toTarget:self withObject:dic];
}

#pragma mark - request scheduled sessions
- (void) requestLogout:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_LOGOUT withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            [commonUtils removeUserDefaultDic:@"current_user"];
            appController.currentUser = [[NSMutableDictionary alloc] init];
            [commonUtils setUserDefault:@"logged_out" withFormat:@"1"];
            appController.scheduledSessions = [[NSMutableArray alloc] init];
            appController.matchedUsers = [[NSMutableArray alloc] init];
            
            [commonUtils QBlogout];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"We can't remove the your account";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}

- (IBAction)clickedSWText:(id)sender {
}

- (IBAction)clickedSWEmail:(id)sender {
}

- (IBAction)clickedSWMessage:(id)sender {
}

- (IBAction)clickedSWDate:(id)sender {
}

- (IBAction)onClickedHelp:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HelpViewController* helpViewController =
    (HelpViewController*) [storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
    [self.navigationController pushViewController:helpViewController animated:YES];
}

- (IBAction)onClickedFeedback:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedBackViewController* feedbackViewController =
    (FeedBackViewController*) [storyboard instantiateViewControllerWithIdentifier:@"FeedBackVC"];
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}

- (IBAction)onClickedFB:(id)sender {
}

- (IBAction)onClickedTwitter:(id)sender {
}

- (IBAction)onClickedInstagram:(id)sender {
}


#pragma mark -

#pragma mark - Age Slider
- (void) configureMyThemeForSlider:(NMRangeSlider *)slider
{
    UIImage* image = nil;
    
    image = [UIImage imageNamed:@"slider-my-trackBackground"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    slider.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:@"slider-my-track"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    slider.trackImage = image;
    
    image = [UIImage imageNamed:@"slider-my-handle"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 1, 1, 1)];
    slider.lowerHandleImageNormal = image;
    slider.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:@"slider-my-handle-highlighted"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 1, 1, 1)];
    slider.lowerHandleImageHighlighted = image;
    slider.upperHandleImageHighlighted = image;
    
    slider.minimumValue = 0.18f;
    slider.maximumValue = 1.10f;
    slider.minimumRange = 0.01f;
    
}

- (void) configureAgeSlider
{
    [self configureMyThemeForSlider:_ageSlider];
    
    if(ageMin < 18) ageMin = 18;
    if(ageMax > 110) ageMax = 110;
    
    _ageSlider.lowerValue = (float) ageMin / 100;
    _ageSlider.upperValue = (float) ageMax / 100 ;
    
    [self updateAgeRange];
}

#pragma mark - Height Slider
- (void) configureMy1ThemeForSlider:(NMRangeSlider *)slider
{
    UIImage* image = nil;
    
    image = [UIImage imageNamed:@"slider-my1-trackBackground"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    slider.trackBackgroundImage = image;
    
    image = [UIImage imageNamed:@"slider-my1-track"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    slider.trackImage = image;
    
    image = [UIImage imageNamed:@"slider-my1-handle"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 1, 1, 1)];
    slider.lowerHandleImageNormal = image;
    slider.upperHandleImageNormal = image;
    
    image = [UIImage imageNamed:@"slider-my1-handle-highlighted"];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(-1, 1, 1, 1)];
    slider.lowerHandleImageHighlighted = image;
    slider.upperHandleImageHighlighted = image;
    
    slider.minimumValue = 0.36f;
    slider.maximumValue = 1.07f;
    slider.minimumRange = 0.01f;
}

- (void) configureHeightSlider
{
    [self configureMy1ThemeForSlider:_heightSlider];
    
    if(heightMin < 36) heightMin = 36;
    if(heightMax > 107) heightMax = 107;
    
    _heightSlider.lowerValue = (float) heightMin / 100;
    _heightSlider.upperValue = (float) heightMax / 100 ;
    
    [self updateHeightRange];
}

#pragma UIPickerViewDelegate Method
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger numRow = 0;
    numRow = appController.genderList.count;
    return numRow;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *strPicker;
    strPicker = [appController.genderList objectAtIndex:row];
    return strPicker;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _lblGender.text = [appController.genderList objectAtIndex:row];
    changedFlag = YES;
}


#pragma UITableViewDelegate Method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numRow;
    numRow = appController.ethnicityList.count;
    return numRow;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EthnicityTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EthnicityTableViewCell"];
    cell.ethnicityName.text = [appController.ethnicityList objectAtIndex:indexPath.row];
    if([[clickEthnicity objectAtIndex:indexPath.row] isEqualToString:@"0"]) cell.imgCheck.hidden = YES;
    else cell.imgCheck.hidden = NO;
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    changedFlag = YES;
    
    if([[clickEthnicity objectAtIndex:indexPath.row] isEqualToString:@"0"]){
        [clickEthnicity replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
    else{
        [clickEthnicity replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    [tableView reloadData];
}


@end
