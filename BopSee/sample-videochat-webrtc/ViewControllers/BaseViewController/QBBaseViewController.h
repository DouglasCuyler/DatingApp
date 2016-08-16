//
//  QBBaseViewController.h
//  BopSee
//
//  Created by John on 06.22.16.
//  Copyright (c) 2016 BopSee Team. All rights reserved.
//

@import UIKit;

@class IAButton;

@interface QBBaseViewController : UIViewController

@property (strong, nonatomic) NSArray *users;

/**
 *  Create custom UIBarButtonItem instance
 */
- (UIBarButtonItem *)cornerBarButtonWithColor:(UIColor *)color
                                         title:(NSString *)title
                                didTouchesEnd:(dispatch_block_t)action;
/**
 *  Default back button
 */
- (void)setDefaultBackBarButtonItem:(dispatch_block_t)didTouchesEndAction;

@end
