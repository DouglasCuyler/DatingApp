//
//  AppSettingsViewController.h
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppSettingsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableEthnicity;
@property (weak, nonatomic) IBOutlet UIView *viewEthnicity;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@property (weak, nonatomic) IBOutlet UIView *viewPic;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIView *viewBack;

@property (weak, nonatomic) IBOutlet UIView *viewAlert;
@property (weak, nonatomic) IBOutlet UIView *viewAlertCon;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;

@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblAgeRange;
@property (weak, nonatomic) IBOutlet UILabel *lblHeightRange;
@property (weak, nonatomic) IBOutlet UILabel *lblEthnicity;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet NMRangeSlider *ageSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *heightSlider;

@property (weak, nonatomic) IBOutlet UISwitch *swText;
@property (weak, nonatomic) IBOutlet UISwitch *swEmail;
@property (weak, nonatomic) IBOutlet UISwitch *swMessage;
@property (weak, nonatomic) IBOutlet UISwitch *swDate;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;


@end
