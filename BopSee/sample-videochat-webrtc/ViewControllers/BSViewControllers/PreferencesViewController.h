//
//  PreferencesViewController.h
//  Bopsee
//
//  Created by Admin on 6/13/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@interface PreferencesViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblAgeRange;
@property (weak, nonatomic) IBOutlet UILabel *lblHeightRange;
@property (weak, nonatomic) IBOutlet UILabel *lblEthnicity;

@property (weak, nonatomic) IBOutlet NMRangeSlider *ageSlider;
@property (weak, nonatomic) IBOutlet NMRangeSlider *heightSlider;

@property (weak, nonatomic) IBOutlet UITableView *tableGender;
@property (weak, nonatomic) IBOutlet UITableView *tableEthnicity;

@property (weak, nonatomic) IBOutlet UIView *viewEthnicity;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@property (weak, nonatomic) IBOutlet UIView *viewPic;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIView *viewBack;

@end
