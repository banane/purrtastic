//
//  AppDelegate.m
//  PetToGive
//
//  Created by Anna Billstrom on 3/13/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window, navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"efaad550-b037-40bb-9e98-d4702170af04"];
    
    firstTimeIn = YES; // TODO save to settings and set to value
    petChoice = 2; // animal lover
    
    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    window.rootViewController = self.navigationController;
    [window makeKeyAndVisible];
    [self displayPetChoice];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)displayPetChoice{
    if(firstTimeIn == YES){
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Which do you most relate to?:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:
                                @"Cats",
                                @"Dogs",
                                @"Animal Lover",
                                nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
        
        //TODO: handle response
    }
    firstTimeIn = NO;
            
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
        default:
            break;
    }
    
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

@end
