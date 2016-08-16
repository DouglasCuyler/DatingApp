//
//  AppController.m


#import "AppController.h"

static AppController *_appController;

@implementation AppController

+ (AppController *)sharedInstance {
    static dispatch_once_t predicate;
    if (_appController == nil) {
        dispatch_once(&predicate, ^{
            _appController = [[AppController alloc] init];
        });
    }
    return _appController;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Utility Data
        _appMainColor = RGBA(239, 238, 226, 1.0f);
        _appTextColor = RGBA(41, 43, 48, 1.0f);
        _appThirdColor = RGBA(61, 155, 196, 1.0f);
        
        _vAlert = [[DoAlertView alloc] init];
        _vAlert.nAnimationType = 2;  // there are 5 type of animation
        _vAlert.dRound = 7.0;
        _vAlert.bDestructive = NO;  // for destructive mode
        
        
        // Intro Images
        _introSliderImages = (NSMutableArray *) @[
                                                  @"intro1",
                                                  @"intro2",
                                                  @"intro3",
                                                  @"intro4",
                                                  @"intro5"
                                                  ];
        
        _settingsList = (NSMutableArray *) @[     @"How We Work",
                                                  @"Edit Profile",
                                                  @"Settings",
                                                  ];
        

        _ageList = [[NSMutableArray alloc] init];
        _heighList = [[NSMutableArray alloc] init];
        _genderList = [[NSMutableArray alloc] init];
        _ethnicityList = [[NSMutableArray alloc] init];
        
        for(int i = 18; i < 111; i++) [_ageList addObject:[NSString stringWithFormat:@"%d", i]];
        for(int j = 36; j < 108; j++){
            int a = (int) (j / 12);
            int b = (int) (j % 12);
            [_heighList addObject:[NSString stringWithFormat:@"%d' %d\"", a, b]];
        }
        _genderList = [@[
                        @"Male",
                        @"Female"
                        ] mutableCopy];

        _ethnicityList  = [@[
                             @"Asian",
                             @"Middle Eastern",
                             @"Black",
                             @"Native American",
                             @"Hispanic/Latin",
                             @"Pacific Islander",
                             @"Indian",
                             @"White",
                             @"Two or more races"
                             ] mutableCopy];
        
        _locationList  = [@[
                             @"New York",
                             @"Los Angeles",
                             @"Chicago",
                             @"Houston",
                             @"Philadelphia",
                             @"Phoenix",
                             @"San Antonio",
                             @"San Diego",
                             @"Dallas",
                             @"San Jose",
                             @"Austin",
                             @"San Francisco",
                             @"Denver",
                             @"Seattle",
                             @"Washington, DC"
                             ] mutableCopy];
        
        _scheduledSessions = [[NSMutableArray alloc] init];
        _availabilitySessions = [[NSMutableArray alloc] init];
        _matchedUsers = [[NSMutableArray alloc] init];


        _seeUsers = [[NSMutableArray alloc] init];
//        _seeUsers = [@[
//                           [@{@"image" : @"user1", @"name" : @"Dean Decarlo"} mutableCopy],
//                           [@{@"image" : @"user2", @"name" : @"John Hose"} mutableCopy],
//                           ] mutableCopy];
        
        _guessUsers = [[NSMutableArray alloc] init];
        _guessUsers = [@[
                       [@{@"image" : @"user1", @"name" : @"Dean Decarlo"} mutableCopy],
                       [@{@"image" : @"user2", @"name" : @"John Hose"} mutableCopy],
                       [@{@"image" : @"user3", @"name" : @"Joe Done"} mutableCopy],
                       ] mutableCopy];
        
        _isFromSignUpSecondPage = NO;
        _isNewBarkUploaded = NO;
        _isMyProfileChanged = NO;
        
        // Data
        _currentUser = [[NSMutableDictionary alloc] init];
        _callUser = [[NSMutableDictionary alloc] init];
        _nextsessionNumber = 0;
        _sel_Cancel = 0;
        _incomingstate = @"0";

    }
    return self;
}

@end
