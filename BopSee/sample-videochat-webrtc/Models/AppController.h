//  AppController.h
//  Created by BE

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DoAlertView.h"

@interface AppController : NSObject

@property (nonatomic, strong) NSMutableArray *introSliderImages, *settingsList;
@property (nonatomic, strong) NSMutableArray *ageList, *heighList, *genderList, *ethnicityList, *locationList;
@property (nonatomic, strong) NSMutableDictionary *currentUser, *apnsMessage, *callUser;
@property (nonatomic, strong) NSMutableArray *scheduledSessions, *availabilitySessions, *matchedUsers, *seeUsers, *guessUsers;

//Bopsee Variables
@property (nonatomic, strong) UIImage *editProfileImage;
@property (nonatomic, strong) NSString *sm_id, *incomingstate, *selectAddress;
@property (nonatomic) int nextsessionNumber, sel_Cancel;

// Temporary Variables
@property (nonatomic, strong) NSString *currentMenuTag, *avatarUrlTemp, *facebookPhotoUrlTemp;
@property (nonatomic, strong) NSMutableDictionary *currentNavBark, *currentNavBarkStat;
@property (nonatomic, assign) BOOL isFromSignUpSecondPage, isNewBarkUploaded, isMyProfileChanged;
@property (nonatomic, strong) NSString *statsVelocityHistoryPeriod, *password, *latestMessageId;

// Utility Variables
@property (nonatomic, strong) UIColor *appMainColor, *appTextColor, *appThirdColor;
@property (nonatomic, strong) DoAlertView *vAlert;
//@property (nonatomic, strong) QBUUser *userQB;

+ (AppController *)sharedInstance;

@end