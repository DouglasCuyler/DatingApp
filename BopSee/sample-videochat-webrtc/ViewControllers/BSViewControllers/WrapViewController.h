//
//  WrapViewController.h
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WrapViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *viewNo;
@property (weak, nonatomic) IBOutlet UIView *viewSee;
@property (weak, nonatomic) IBOutlet UIView *viewGuess;

@property (weak, nonatomic) IBOutlet UITableView *tableSee;
@property (weak, nonatomic) IBOutlet UITableView *tableGuess;

@end
