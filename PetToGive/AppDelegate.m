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

#define HOURS_TO_WAIT ((int) 4)

@implementation AppDelegate

@synthesize navigationController, lastActiveDate, lavender, purple;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self getDefaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        NSLog(@"app launching and there is a local notification");
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
        // TODO show invalid petting action view, if invalid
    }

    [[UIApplication sharedApplication] cancelAllLocalNotifications];

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
        [self setupNotifications];
    }
    lavender = [self renderColor:253 green:244 blue:255];
    purple = [self renderColor:153 green:102 blue:204];
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
    petChoice = [defaults integerForKey:@"PetChoicePreference"];
    hasSeenPetChoice = [defaults boolForKey:@"hasSeenPetChoice"];
    lastActiveDate = [defaults objectForKey:@"lastActiveDate"];
}

- (void)setDefaults{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:hasSeenPetChoice forKey:@"hasSeenPetChoice"];
    [defaults setInteger:petChoice forKey:@"PetChoicePreference"];
    [defaults setObject:lastActiveDate forKey:@"lastActiveDate"];
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
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"There's a new animal to pet!" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:nil ];
    popup.tag = 2;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
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
    // 4 hours
    // int timeInterval = 60*60*4;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
/*
    int timeInterval = 10;
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    localNotification.repeatInterval = NSMinuteCalendarUnit;
    localNotification.alertBody = @"There's a new animal for you to pet!";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
*/
    UILocalNotification* notif = [[UILocalNotification alloc] init];
    notif.alertBody = @"There's a new animal for you to pet!";
    notif.timeZone = [NSTimeZone defaultTimeZone];

    NSDate *now = [NSDate date];
    int timeInterval = 60*60*HOURS_TO_WAIT;
    
    // 3 messages
    for( int i = 1; i <= 3;i++)
    {
        notif.fireDate = [NSDate dateWithTimeInterval:timeInterval*i sinceDate:now];
        [[UIApplication sharedApplication] scheduleLocalNotification: notif];
    }
}

-(UIColor *)renderColor:(int)red green:(int)green blue:(int)blue{
    return [UIColor colorWithRed:((float)red/255.0f) green:((float)green/255.0f) blue:((float)blue/255.0f) alpha:1.0f];
}


@end
