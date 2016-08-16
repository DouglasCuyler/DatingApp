//
//  ViewController.m
//  Mixl
//
//  Created by admin on 4/6/16.
//  Copyright © 2016 John. All rights reserved.
//

#import "ViewController.h"
#import "Settings.h"

@interface ViewController ()
@property (strong, nonatomic) Settings *settings;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.settings = Settings.instance;
}

- (void) viewWillAppear:(BOOL)animated {
    [self initView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initView {
    
    [commonUtils setUserDefault:@"QBLogin" withFormat:@"0"];
    _activeIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    _activeIndicator.color = [UIColor whiteColor];
    [_activeIndicator startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_activeIndicator stopAnimating];
        [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
    });

}

@end
