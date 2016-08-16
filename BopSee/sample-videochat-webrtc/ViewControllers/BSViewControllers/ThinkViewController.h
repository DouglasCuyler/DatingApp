//
//  ThinkViewController.h
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol ThinkViewControllerDelegate;

@interface ThinkViewController : UIViewController

@property (weak, nonatomic) id <ThinkViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lblNextTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDateName;
@property (weak, nonatomic) IBOutlet UIImageView *imgDate;

@property (strong, nonatomic) NSMutableDictionary   *dateInfo;

@end

@protocol ThinkViewControllerDelegate <NSObject>

- (void)thinkViewController:(ThinkViewController *)vc;

@end
