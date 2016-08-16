//
//  AbuseViewController.m
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "AbuseViewController.h"

@interface AbuseViewController (){
    NSString* remainTime;
    NSString* cow, *books, *art, *hiking;
}

@end

@implementation AbuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initView{
    
    _btnAbuse.layer.cornerRadius = 5.0f;
    remainTime = @"30";
    cow = @"0";
    books = @"0";
    art = @"0";
    hiking = @"0";
    _lblTitle.text = [NSString stringWithFormat:@"Date #%@", _dateNumber];
    _lblName.text = [_dateInfo objectForKey:@"name"];
    [_imgDate setImage:[UIImage imageNamed:[_dateInfo objectForKey:@"image"]]];
    _lblTime.text = [NSString stringWithFormat:@"%@ Seconds Remaining", remainTime];
    
}

- (IBAction)onCowClicked:(id)sender {
//    if([cow isEqualToString:@"0"]){
//        [_btnCow setImage:[UIImage imageNamed:@"cow_on"] forState:UIControlStateNormal];
//        cow = @"1";
//    }
//    else{
//        [_btnCow setImage:[UIImage imageNamed:@"cow_off"] forState:UIControlStateNormal];
//        cow = @"0";
//    }
}

- (IBAction)onBooksClicked:(id)sender {
//    if([books isEqualToString:@"0"]){
//        [_btnBooks setImage:[UIImage imageNamed:@"books_on"] forState:UIControlStateNormal];
//        books = @"1";
//    }
//    else{
//        [_btnBooks setImage:[UIImage imageNamed:@"books_off"] forState:UIControlStateNormal];
//        books = @"0";
//    }
}

- (IBAction)onArtClicked:(id)sender {
//    if([art isEqualToString:@"0"]){
//        [_btnArt setImage:[UIImage imageNamed:@"art_on"] forState:UIControlStateNormal];
//        art = @"1";
//    }
//    else{
//        [_btnArt setImage:[UIImage imageNamed:@"art_off"] forState:UIControlStateNormal];
//        art = @"0";
//    }
}

- (IBAction)onHikingClicked:(id)sender {
//    if([hiking isEqualToString:@"0"]){
//        [_btnHiking setImage:[UIImage imageNamed:@"hiking_on"] forState:UIControlStateNormal];
//        hiking = @"1";
//    }
//    else{
//        [_btnHiking setImage:[UIImage imageNamed:@"hiking_off"] forState:UIControlStateNormal];
//        hiking = @"0";
//    }
}

- (IBAction)onAbuseClicked:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ThinkViewController* thinkController =
    (ThinkViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ThinkVC"];
    thinkController.dateInfo = _dateInfo;
    [self.navigationController pushViewController:thinkController animated:YES];
}
@end
