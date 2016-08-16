//
//  ProfileViewController.m
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "ProfileViewController.h"
#import "EthnicityTableViewCell.h"

@interface ProfileViewController (){
    
    NSString *userLocation;
    NSMutableArray *clickEthnicity;
    int heightValue, userGender;
    BOOL age, height, gender, isUserPhotoChanged;
}
@end

@implementation ProfileViewController

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
        _lblLocation.text = appController.selectAddress;
    }
}
- (void) initData{
    clickEthnicity = [[NSMutableArray alloc] init];
    for(int i = 0; i < appController.ethnicityList.count; i++) [clickEthnicity addObject:@"0"];
    
}

- (void) initView{
    
    [commonUtils setCircleViewImage:_viewUserImage imageview:_imgUser borderWidth:2.0f borderColor:[UIColor lightGrayColor]];
    
    NSString* avatarImageURL = [appController.currentUser objectForKey:@"user_photo_url"];
    NSLog(@"avatar image URL : %@", avatarImageURL);
    if ([avatarImageURL isEqual:[NSNull null]]){
        [_imgUser setImage:[UIImage imageNamed:@"no_photo"]];
    }else{
        
        [commonUtils setImageViewAFNetworking:_imgUser withImageUrl:avatarImageURL withPlaceholderImage:[UIImage imageNamed:@"no_photo"]];
    }
    
    _txtName.text = [appController.currentUser objectForKey:@"user_full_name"];
    _txtDisplayName.text = [appController.currentUser objectForKey:@"user_name"];
    _txtEmail.text = [appController.currentUser objectForKey:@"user_email"];
    _lblAge.text = [appController.currentUser objectForKey:@"user_age"];
    
    heightValue = [[appController.currentUser objectForKey:@"user_height"] intValue];
    if (heightValue == 0){
        _lblHeight.text = @"";
    }
    else{
        int a = (int) heightValue / 12;
        int b = (int) heightValue % 12;
        _lblHeight.text = [NSString stringWithFormat:@"%d' %d\"", a, b];
    }
    
    userGender = [[appController.currentUser objectForKey:@"user_gender"] intValue];
    if (userGender == 1){
        _lblGender.text = @"Male";
    }
    else{
        _lblGender.text = @"Female";
    }
    
    _lblLocation.text = [appController.currentUser objectForKey:@"user_address"];
//    if (![userLocation isEqualToString:@""]){
//        NSArray *array = [userLocation componentsSeparatedByString:@","];
//        if([array count] > 1){
//            _lblLocation.text = [NSString stringWithFormat:@"%@,%@", [array objectAtIndex:1], [array objectAtIndex:2]];
//        }
//        else{
//            _lblLocation.text = @"No, Los Angeles, CA";
//        }
//    }
//    else{
//        _lblLocation.text = @"No, Los Angeles, CA";
//    }
    
    _lblEthnicity.text = [appController.currentUser objectForKey:@"user_ethnicity"];
    
    _viewEthnicity.layer.cornerRadius = 7.0f;
    _viewEthnicity.layer.borderWidth = 1.0f;
    _viewEthnicity.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _btnOK.layer.cornerRadius = 5.0f;
    _viewEthnicity.hidden = YES;
    
    age = NO;
    height = NO;
    gender = NO;
    isUserPhotoChanged = NO;
}

- (IBAction)onBackClicked:(id)sender {
    [self resetTextFeild];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onNextClicked:(id)sender {
    [self resetTextFeild];
    
    if(self.isLoadingBase) return;
    
    if([commonUtils isFormEmpty:[@[_txtName.text, _txtDisplayName.text, _txtEmail.text, _lblAge.text, _lblHeight.text, _lblEthnicity.text] mutableCopy]]) {
        [commonUtils showAlert:@"Warning" withMessage:@"Please complete the entire form"];
    }
    else{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
        [dic setObject:_txtName.text forKey:@"user_full_name"];
        [dic setObject:_txtEmail.text forKey:@"user_email"];
        [dic setObject:_txtDisplayName.text forKey:@"user_name"];
        [dic setObject:_lblAge.text forKey:@"user_age"];
        [dic setObject:[NSString stringWithFormat:@"%d", heightValue] forKey:@"user_height"];
        if([_lblGender.text isEqual:@"Male"]){
            [dic setObject:@"1" forKey:@"user_gender"];
        }
        else{
            [dic setObject:@"2" forKey:@"user_gender"];
        }
        [dic setObject:_lblLocation.text forKey:@"user_address"];
        [dic setObject:_lblEthnicity.text forKey:@"user_ethnicity"];
        
        if(isUserPhotoChanged) {
            NSString *photo = [commonUtils encodeToBase64String:appController.editProfileImage byCompressionRatio:0.3];
            [dic setObject:photo forKey:@"user_photo_data"];
        }
        self.isLoadingBase = YES;
        [JSWaiter ShowWaiter:self.view title:@"Updating..." type:0];
        [NSThread detachNewThreadSelector:@selector(requestDataUserProfileChange:) toTarget:self withObject:dic];
    }
    
    
}

#pragma mark - request data user profile change
- (void) requestDataUserProfileChange:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_PROFILE_UPDATE withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            NSLog(@"Updated User : %@", appController.currentUser);
            
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


- (IBAction)onCameraClicked:(id)sender {
    UIActionSheet *alertCamera = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take a picture",
                                  @"Select photos from camera roll", nil];
    alertCamera.tag = 1;
    [alertCamera showInView:[UIApplication sharedApplication].keyWindow];
}
- (IBAction)onClickedDone:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _viewPic.frame;
        CGRect rectBack = _viewBack.frame;
        CGRect rectTop = _viewTop.frame;
        _viewBack.frame = CGRectMake(0, rectTop.size.height, rectBack.size.width, rectBack.size.height);
        _viewPic.frame = CGRectMake(0, self.view.frame.size.height, rect.size.width, rect.size.height);
    }];
    
}

- (IBAction)onClickedAge:(id)sender {
    
    age = YES;
    height = NO;
    gender = NO;
    [_pickerView reloadAllComponents];
    [self moveView];
}

- (void) moveView{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _viewPic.frame;
        CGRect rectBack = _viewBack.frame;
        CGRect rectTop = _viewTop.frame;
        _viewBack.frame = CGRectMake(0, rectTop.size.height - rect.size.height, rectBack.size.width, rectBack.size.height);
        _viewPic.frame = CGRectMake(0, self.view.frame.size.height - rect.size.height, rect.size.width, rect.size.height);
    }];
}
- (IBAction)onClickedHeight:(id)sender {
    
    age = NO;
    height = YES;
    gender = NO;
    [_pickerView reloadAllComponents];
    [self moveView];
}

- (IBAction)onClickedGender:(id)sender {
    age = NO;
    height = NO;
    gender = YES;
    [_pickerView reloadAllComponents];
    [self moveView];
}

- (IBAction)onClickedEthnicity:(id)sender {
    _viewEthnicity.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _viewPic.frame;
        CGRect rectBack = _viewBack.frame;
        CGRect rectTop = _viewTop.frame;
        _viewBack.frame = CGRectMake(0, rectTop.size.height, rectBack.size.width, rectBack.size.height);
        _viewPic.frame = CGRectMake(0, self.view.frame.size.height, rect.size.width, rect.size.height);
    }];
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
    _lblEthnicity.text = ethni;
}

- (IBAction)onClickedLocation:(id)sender {
    appController.sel_Cancel = 0;
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"findLocationPage"];
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma UIPickerViewDelegate Method
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger numRow = 0;
    if (age == YES) {
        numRow =  appController.ageList.count;
    }else if (height == YES){
        numRow = appController.heighList.count;
    }else if (gender == YES){
        numRow = appController.genderList.count;
    }
    return numRow;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *strPicker;
    if (age == YES) {
        strPicker = [appController.ageList objectAtIndex:row];
    }
    else if (height == YES){
        strPicker = [appController.heighList objectAtIndex:row];
    }else if (gender == YES){
        strPicker = [appController.genderList objectAtIndex:row];
    }
    return strPicker;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (age == YES) {
        _lblAge.text = [appController.ageList objectAtIndex:row];
    }else if (height == YES){
        _lblHeight.text = [appController.heighList objectAtIndex:row];
        heightValue = 36 + (int)row;
    }else{
        _lblGender.text = [appController.genderList objectAtIndex:row];
    }
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
    
    if (tableView == _tableEthnicity) {
        
        if([[clickEthnicity objectAtIndex:indexPath.row] isEqualToString:@"0"]){
            [clickEthnicity replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }
        else{
            [clickEthnicity replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }
        [tableView reloadData];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    switch (buttonIndex) {
            
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
            
        default:
            break;
    }
    
    NSLog(@"%ld , %ld", (long)actionSheet.tag , (long)buttonIndex);
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *imageSEL = info[UIImagePickerControllerEditedImage];
    appController.editProfileImage = imageSEL;
    isUserPhotoChanged = YES;
    [_imgUser setImage:imageSEL];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void) resetTextFeild{
    [_txtName resignFirstResponder];
    [_txtDisplayName  resignFirstResponder];
    [_txtEmail resignFirstResponder];
}

@end
