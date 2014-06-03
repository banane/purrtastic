//
//  AppDelegate.m
//  PetToGive
//
//  Created by Anna Billstrom on 3/13/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MoreWaysViewController.h"
#import "ThankYouViewController.h"
#import <AFNetworking.h>
#import "Constants.h"
#import "Pet.h"


@implementation AppDelegate

@synthesize navigationController, lastActiveDate, lavender, purple, grayTextColor, petDictionary, morningActiveDate, eveningActiveDate, canPet, kibbleCount, notificationsDict, sessionCount, maxSessionPetsReached, activePet, user;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    // GAI stuff
     [GAI sharedInstance].trackUncaughtExceptions = YES;
     [GAI sharedInstance].dispatchInterval = 20;
 //    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
     [[GAI sharedInstance] trackerWithTrackingId:@"UA-50154316-1"];
    // end GAI
    
    
    [self getDefaults];
    [self queueUpNextPet];

    if(!hasSeenPetChoice) {         // first time in, initialize values
        kibbleCount = 0;

        [self resetSession];
    }
    NSLog(@"in app did finish launching, sessioncount: %ld", (long)sessionCount);
    [self loadNotificationMessages];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        NSString *message = @"app launching and there is a local notification";
        NSLog(@"%@",message);
        
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }


    NSString *xibname = @"ViewController";
    CGRect frame= [[UIScreen mainScreen] bounds];
    if(frame.size.height > 480){
        xibname = [NSString stringWithFormat:@"%@_4inch", xibname];
    }
  
    ViewController *vc = [[ViewController alloc] initWithNibName:xibname bundle:nil];
    vc.petChoice = petChoice;

    
    navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    if(!hasSeenPetChoice){
        [self displayPetChoice];
    } else {
        // re-set up each time app opens to vary the message

        [self setupNotifications];
    }
    lavender = [self renderColor:253 green:244 blue:255];
    purple = [self renderColor:153 green:102 blue:204];
    grayTextColor=[self renderColor:72 green:72 blue:72];
    
    int version = [[[UIDevice currentDevice] systemVersion] intValue];
    if (version >= 7){
        self.window.tintColor = purple;
    } else {
        self.window.backgroundColor = purple;
    }
    return YES;
}

#pragma mark data calls

-(void)getLatestPet:(NSString *)idString animalType:(NSString *)animalType{
    // TODO check for animal type
    NSString *getSingle = [NSString stringWithFormat:@"%@%@.json", kAPIBaseURLString, idString];
    NSLog(@"single: %@", getSingle);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:getSingle parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *name = responseObject[@"name"];
        NSString *story = responseObject[@"description"];
        NSString *idString = responseObject[@"id"];
        NSString *imageUrl = responseObject[@"photo"];
        NSString *animalType = responseObject[@"animal_type"];
        
        activePet =  [[Pet alloc] init:name Story:story remoteId:idString animalType:animalType imageUrl:imageUrl];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"PetReceivedNotification"
                                                            object:self
                                                          userInfo:nil];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
}

-(void)queueUpNextPet{
   
     int nextPetId = [activePet.remoteId intValue]  + 1;
     NSString *nextPetIdString = [NSString stringWithFormat:@"%d", nextPetId];
    
     [self getLatestPet:nextPetIdString animalType:user.petChoiceString];

}

#pragma mark other methods

-(void)resetSession{
    // set pettable actions anew
    
    sessionCount = 0;
    maxSessionPetsReached = NO;
    lastActiveDate = nil;
}

-(void)logFlurry:(NSString *)message{
//    [Flurry logEvent:message];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString *msg;

    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
       // [self postNewPetalert];
        msg = @"receiving from active state";
    } else {
        msg = @"receiving notification from inactive state";
    }
    application.applicationIconBadgeNumber = 0;
    NSLog(@"%@",msg);
}


- (void)registerDefaults{
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"PetChoicePreference", [NSNumber numberWithBool:YES], "FirstTimeIn",nil ];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

- (void)getDefaults{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    petChoice = (int)[defaults integerForKey:@"PetChoicePreference"];
    hasSeenPetChoice = [defaults boolForKey:@"hasSeenPetChoice"];
    lastActiveDate = [defaults objectForKey:@"lastActiveDate"];
    kibbleCount = [defaults integerForKey:@"kibbleCount"];
    sessionCount = [defaults integerForKey:@"sessionCount"];
    maxSessionPetsReached = [defaults boolForKey:@"maxSessionPetsReached"];
    lastPetId = [defaults integerForKey:@"lastPetId"];
    self.user = [[User alloc] init:petChoice kibbleCount:kibbleCount lastPetId:lastPetId];
    NSLog(@"pet choice defaults: %d", petChoice);
}

- (void)setDefaults{
    //TODO move other vars to user object?
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:hasSeenPetChoice forKey:@"hasSeenPetChoice"];
    [defaults setInteger:user.petChoice forKey:@"PetChoicePreference"];
    [defaults setObject:lastActiveDate forKey:@"lastActiveDate"];
    [defaults setInteger:user.lifetimeKibbleCount forKey:@"kibbleCount"];
    [defaults setInteger:sessionCount forKey:@"sessionCount"];
    [defaults setBool:maxSessionPetsReached forKey:@"maxSessionPetsReached"];
    [defaults setInteger:user.lastPetId forKey:@"lastPetId"];
    [defaults synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

-(void)displayPetChoice{
    if(hasSeenPetChoice == NO){
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Which do you most relate to?:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:
                                @"Cats",
                                @"Dogs",
                                @"Animal Lover",
                                nil];
        popup.tag = 1;
         [popup showInView:[UIApplication sharedApplication].keyWindow];
        
    }
    hasSeenPetChoice = YES;
    [self setDefaults];

}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
//    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    petChoice = 0;

                    [self sendChoice:petChoice];
                    break;
                case 1:
                    petChoice = 1;
                    [self sendChoice:petChoice];
                    break;
                case 2:
                    petChoice = 2;
                    [self sendChoice:petChoice];
                    break;
                default:
                    break;
            }
            break;
        }
        case 2:{
            NSLog(@"in new animal to view");
            break;
        }
        default:
            break;
    }
    [self setDefaults]; // store new petchoice
    
}
-(void)sendChoice:(int)choice{
    
    [self setupNotifications];

    NSDictionary *userinfoObject = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:choice]
                                                 forKey:@"petchoice"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PetPhotoChoiceNotification"
                                                        object:self
                                                      userInfo:userinfoObject];

}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)setupNotifications{
   
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self fireNotification:10];
    [self fireNotification:19];
    
}

-(void)loadNotificationMessages{
    NSString *namepath = [[NSBundle mainBundle] pathForResource:@"notifications" ofType:@"xml"];
	notificationsDict =[[NSDictionary alloc] initWithContentsOfFile:namepath];
    
}

-(void)testNotification{
    UILocalNotification* notif = [[UILocalNotification alloc] init];
    notif.alertBody = @"There's a new animal for you to pet!";
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:15];
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];

}



-(void)fireNotification:(int)hour{
    UILocalNotification* notif = [[UILocalNotification alloc] init];
    int max = 10;
    int randomNum = arc4random() % max;
    
    
    if(petChoice == 1){
        randomNum += 10;
    } else if (petChoice == 2){
        randomNum += 20;
    }
    NSString *key= [NSString stringWithFormat:@"%d", randomNum];
    NSString *message = [notificationsDict objectForKey:key];
    
    
    NSLog(@"notification is: %@", message);
    
    notif.alertBody = message;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    
    notif.repeatInterval = kCFCalendarUnitDay;
    NSDate *fireDate = [self getDateFromHour:(int)hour];
    notif.fireDate = fireDate;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}

-(UIColor *)renderColor:(int)red green:(int)green blue:(int)blue{
    return [UIColor colorWithRed:((float)red/255.0f) green:((float)green/255.0f) blue:((float)blue/255.0f) alpha:1.0f];
}

-(NSDate *)getDateFromHour:(int)hour{
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDate *today = [NSDate date];
    
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:today];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    
    [dateComps setDay:dateComponents.day];
    [dateComps setMonth:dateComponents.month];
    [dateComps setYear:dateComponents.year];
    
    [dateComps setHour:hour];
    [dateComps setMinute:00];
    [dateComps setSecond:00];
    
    NSDate  *date = [calendar dateFromComponents:dateComps];

    return date;
}

-(int)petAgainTime{
    return [lastActiveDate timeIntervalSinceNow];
}


@end
