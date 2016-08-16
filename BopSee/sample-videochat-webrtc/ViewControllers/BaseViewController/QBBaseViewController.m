//
//  QBBaseViewController.m
//  BopSee
//
//  Created by John on 06.22.16.
//  Copyright (c) 2016 BopSee Team. All rights reserved.
//

#import "QBBaseViewController.h"
#import "CornerView.h"
#import "ChatManager.h"
#import "UsersDataSource.h"
#import "QBUUser+IndexAndColor.h"

@implementation QBBaseViewController

- (UIBarButtonItem *)cornerBarButtonWithColor:(UIColor *)color
                                         title:(NSString *)title
                                didTouchesEnd:(dispatch_block_t)action {
    
    return ({
        
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
            
            CornerView *cornerView = [[CornerView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            cornerView.touchesEndAction = action;
            cornerView.userInteractionEnabled = YES;
            cornerView.bgColor = color;
            cornerView.title = title;
            cornerView;
        })];
    
        backButtonItem;
    });
}

- (void)setDefaultBackBarButtonItem:(dispatch_block_t)didTouchesEndAction {
    
    UIBarButtonItem *backBarButtonItem =
    [self cornerBarButtonWithColor:UsersDataSource.instance.currentUser.color
                              title:[NSString stringWithFormat:@"%tu", UsersDataSource.instance.currentUser.index + 1]
                     didTouchesEnd:^
     {
         didTouchesEndAction();
     }];
    
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

@end
