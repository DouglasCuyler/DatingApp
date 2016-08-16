//
//  FeedBackViewController.m
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewFeed.layer.borderWidth = 1.0f;
    _viewFeed.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _viewFeed.layer.cornerRadius = 7.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBackClicked:(id)sender {
    [self resetTextFeild];
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSendClicked:(id)sender {
    [self resetTextFeild];
    [commonUtils showAlert:@"FeedBack" withMessage:@"Thank you for your feedback!"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) resetTextFeild{
    [_txtSubject resignFirstResponder];
    [_txtComment  resignFirstResponder];
 }

@end
