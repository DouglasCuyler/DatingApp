//
//  FindLocationViewController.m
//  BopSee
//
//  Created by Admin on 7/26/16.
//  Copyright © 2016 John Team. All rights reserved.
//

#import "FindLocationViewController.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "AppDelegate.h"

@interface FindLocationViewController ()<UISearchBarDelegate, UITableViewDataSource,UITextViewDelegate, UITableViewDelegate, CLLocationManagerDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;

@property (strong, nonatomic) IBOutlet UIView *viewCurrentLocation;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lblUnderLine;

@end

@implementation FindLocationViewController{

    SPGooglePlacesAutocompleteQuery *searchQuery;
    BOOL shouldBeginEditing;
    NSArray *searchResultPlaces;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self.viewCurrentLocation setHidden:YES];
    
    self.searchBar.delegate = self;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.searchBar.placeholder = @"Enter address or city";
   
    [self.tableView setHidden:YES];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.searchBar becomeFirstResponder];

    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] init];
    searchQuery.radius = 150000.0;
    shouldBeginEditing = YES;
    searchQuery.language = @"en";
    [searchQuery initWithApiKey:@"AIzaSyBwOtFY6g4golooMzJ9NjU41ccofQepMdY"];
        
}

-(void)viewWillLayoutSubviews{
    
//    CGRect frame;
//    
//        frame = CGRectMake(0, 0, self.viewCurrentLocation.frame.size.width, self.tableView.frame.size.height + self.viewCurrentLocation.frame.size.height);
//        frame.origin.x = 0;
//        frame.origin.y = self.viewCurrentLocation.frame.origin.y;
//        
//        [self.tableView setFrame:frame];

}
- (IBAction)onCancelBtn:(id)sender {
    appController.sel_Cancel = 0;
    [self dismissSelf];
}

- (IBAction)onCurrentLocation:(id)sender {
    
        [JSWaiter ShowWaiter:self.view title:nil type:0];
    
        CLGeocoder *geocoder;
        
        geocoder = [[CLGeocoder alloc] init];
        
        CLLocationCoordinate2D tapPoint;
        tapPoint.latitude = [[commonUtils getUserDefault:@"currentLatitude"] doubleValue];
        tapPoint.longitude = [[commonUtils getUserDefault:@"currentLongitude"] doubleValue];
        
        __block BOOL isGetAdressSuccess;
        
        NSLog(@"Resolving the Address");
        
        __block NSString *returnAddress = @"";
        
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:(float)tapPoint.latitude longitude:(float)tapPoint.longitude];
        
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark *userSpotPlaceMark;
            
            if (error == nil) {
                
                NSLog(@"Resolved");
                userSpotPlaceMark = [placemarks lastObject];
                returnAddress = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 userSpotPlaceMark.subThoroughfare, userSpotPlaceMark.thoroughfare,
                                 userSpotPlaceMark.postalCode, userSpotPlaceMark.locality,
                                 userSpotPlaceMark.administrativeArea,
                                 userSpotPlaceMark.country];
                appController.sel_Cancel = 1;
                appController.selectAddress = [NSString stringWithFormat:@"%@, %@", userSpotPlaceMark.locality, userSpotPlaceMark.administrativeArea];
                
                [JSWaiter HideWaiter];
                
                [self dismissSelf];
                
            } else {
                
                [JSWaiter HideWaiter];
                NSLog(@"%@", error.debugDescription);
                isGetAdressSuccess = NO;
                appController.sel_Cancel = 0;
                [commonUtils showAlert:@"Warning" withMessage:@"Please check your network connection"];
                
           }
            
        }];
    
}

-(void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger nReturn;
    nReturn = [searchResultPlaces count];
    return nReturn;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *simpleCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"simpleCell"];
    
    if (simpleCell == nil) {
        simpleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"simpleCell"];
    }
    
    [simpleCell.textLabel setFont:[UIFont fontWithName:@"arial-rounded-mt-light" size: 16.0f]];
    
    
        simpleCell.imageView.image = [UIImage imageNamed:@"cityicon"];
        simpleCell.textLabel.text = [self placeAtIndexPath:indexPath].name;
        

    return simpleCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    appController.sel_Cancel = 1;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *myString=cell.textLabel.text;
    
    if ([myString rangeOfString:@","].location != NSNotFound) {
        NSRange range = [myString rangeOfString:@"," options:NSBackwardsSearch range:NSMakeRange(0, [myString length])];
        //    NSLog(@"range.location: %lu", range.location);
        appController.selectAddress = [myString substringToIndex:range.location];
        NSLog(@"-----address:%@", appController.selectAddress);
        
    } else {
        appController.selectAddress = myString;
    }
    
    [self dismissSelf];
    
}

#pragma search bar delegate

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self handleSearchForSearchString:searchText];
        
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}
//==== google search =====

- (void)handleSearchForSearchString:(NSString *)searchString {
    
    searchQuery.location = [AppDelegate sharedAppDelegate].locationManager.location.coordinate;
    searchQuery.input = searchString;
    
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            
            [commonUtils showVAlertSimple:@"Warning" body:@"There is no such place" duration:0.5];
            
        } else {
            
            [self.tableView setHidden:NO];
            searchResultPlaces = places;
            [self.tableView reloadData];
            
        }
    }];
}
- (SPGooglePlacesAutocompletePlace *)placeAtIndexPath:(NSIndexPath *)indexPath {
    return [searchResultPlaces objectAtIndex:indexPath.row];
}

@end
