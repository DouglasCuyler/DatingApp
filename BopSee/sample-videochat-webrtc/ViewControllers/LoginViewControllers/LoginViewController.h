//
//  LoginViewController.h
//  Mixl
//
//  Created by admin on 4/6/16.
//  Copyright © 2016 John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UserBaseViewController

@property (nonatomic, strong) IBOutlet UIButton*    btnFaceBook;
@property (weak, nonatomic) IBOutlet UIView *termsView;
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end
