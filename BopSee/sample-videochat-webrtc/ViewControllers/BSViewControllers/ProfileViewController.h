//
//  ProfileViewController.h
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface ProfileViewController : BaseViewController < UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *viewUserImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtDisplayName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (weak, nonatomic) IBOutlet UILabel *lblHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblEthnicity;

@property (weak, nonatomic) IBOutlet UITableView *tableAge;
@property (weak, nonatomic) IBOutlet UITableView *tableHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableGender;
@property (weak, nonatomic) IBOutlet UITableView *tableEthnicity;

@property (weak, nonatomic) IBOutlet UIView *viewEthnicity;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@property (weak, nonatomic) IBOutlet UIView *viewPic;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *viewBack;
@property (weak, nonatomic) IBOutlet UIView *viewTop;

@end
