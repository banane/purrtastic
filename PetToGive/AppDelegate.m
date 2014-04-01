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
#import "Pet.h"


@implementation AppDelegate

@synthesize navigationController, lastActiveDate, lavender, purple, grayTextColor, petDictionary, morningActiveDate, eveningActiveDate, canPet, kibbleCount;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self getDefaults];
    if(!hasSeenPetChoice) {         // first time in, initialize values
        [self setupNotifications];
        kibbleCount = 0;
    }
    [self loadPetDictionary];

    //debugging
    //[self testNotification];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        NSLog(@"app launching and there is a local notification");
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
        // TODO show invalid petting action view, if invalid
    }


    NSString *xibname = @"ViewController";
    CGRect frame= [[UIScreen mainScreen] bounds];
    if(frame.size.height > 480){
        xibname = [NSString stringWithFormat:@"%@_4inch", xibname];
    }
  
    ViewController *vc = [[ViewController alloc] initWithNibName:xibname bundle:nil];
    vc.petChoice = petChoice;

//    ThankYouViewController *tvc = [[ThankYouViewController alloc] initWithNibName:@"ThankYouViewController" bundle:nil];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    if(!hasSeenPetChoice){
        [self displayPetChoice];
        [self setupNotifications];
    }
    lavender = [self renderColor:253 green:244 blue:255];
    purple = [self renderColor:153 green:102 blue:204];
    grayTextColor=[self renderColor:72 green:72 blue:72];
    self.window.tintColor = purple;
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"receiving from local notification");

    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        [self postNewPetalert];
        application.applicationIconBadgeNumber = 0;
        NSLog(@"receiving from active state");
    } else {
        NSLog(@"receiving from inactive state");
    }
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
    NSLog(@"pet choice defaults: %d", petChoice);
}

- (void)setDefaults{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:hasSeenPetChoice forKey:@"hasSeenPetChoice"];
    [defaults setInteger:petChoice forKey:@"PetChoicePreference"];
    [defaults setObject:lastActiveDate forKey:@"lastActiveDate"];
    [defaults setInteger:kibbleCount forKey:@"kibbleCount"];
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

-(void)postNewPetalert{
/*    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"There's a new animal to pet!" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil ];
    popup.tag = 2;
    [popup showInView:[UIApplication sharedApplication].keyWindow];*/
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
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
    NSDictionary *userinfoObject = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:choice]
                                                 forKey:@"petchoice"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PetPhotoChoiceNotification"
                                                        object:self
                                                      userInfo:userinfoObject];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupNotifications{
   
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self fireNotification:10];
    [self fireNotification:19];
    
}

-(void)testNotification{
    UILocalNotification* notif = [[UILocalNotification alloc] init];
    notif.alertBody = @"There's a new animal for you to pet!";
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:15];
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];

}

-(void)loadPetDictionary{

    NSString *namepath = [[NSBundle mainBundle] pathForResource:@"petnames" ofType:@"xml"];
	NSDictionary *namesDict =[[NSDictionary alloc] initWithContentsOfFile:namepath];
    
    NSLog(@"%@ namesdict", namesDict);
    
    NSString *storypath =[[NSBundle mainBundle] pathForResource:@"stories" ofType:@"xml"];
    NSDictionary *storiesDict = [[NSDictionary alloc] initWithContentsOfFile:storypath];
    
    NSString *typepath =[[NSBundle mainBundle] pathForResource:@"pettype" ofType:@"xml"];
    NSDictionary *typesDict = [[NSDictionary alloc] initWithContentsOfFile:typepath];
    
    NSMutableDictionary *tmpD = [[NSMutableDictionary alloc] init];
    // key is id, keyNum is nsnumber id as key in nsdictionary, keyInt is integer value for interpolation
    
    for(id key in namesDict){
        NSString *name = [namesDict objectForKey:key];
        NSLog(@"%@ key %@ name", key, name);
        NSNumber *keyNum = [NSNumber numberWithInt:[key intValue]];
        NSString *keyStr = key;
        
        int keyInt = [key intValue];
        Pet *pet = [[Pet alloc] init:name Key:[key intValue]];
        pet.story = [storiesDict objectForKey:keyStr];
        pet.type = [typesDict objectForKey:keyStr];
        
        NSLog(@"%@ key %@ type", key, pet.type);
        NSLog(@"%@ key %@ story", key, pet.story);

        
        pet.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%d_1x",pet.type, keyInt]];
        [tmpD setObject:pet forKey:keyNum];
        // add image
    }
    petDictionary = tmpD;
    // test:
    Pet *petTest = [petDictionary objectForKey:[NSNumber numberWithInt:2]];
    NSLog(@"pet name, should be Fido: %@", petTest.name);
    NSLog(@"pet type should be dog: %@", petTest.type);
    

}

-(void)fireNotification:(int)hour{
    UILocalNotification* notif = [[UILocalNotification alloc] init];
    notif.alertBody = @"There's a new animal for you to pet!";
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

-(NSString *)petAgainTime{
    NSDate *today = [NSDate date];
    NSDateComponents *components;
    
    components = [[NSCalendar currentCalendar] components: NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                                 fromDate: today toDate: lastActiveDate options: 0];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    NSLog(@"Hour:%d Minute:%d Second:%d ", (int)hour, (int)minute, (int)second);
    NSString *returnString = [NSString stringWithFormat:@"Pet again in: %dh %dm %dsec", (int)hour, (int)minute, (int)second];
    return returnString;
}


@end
