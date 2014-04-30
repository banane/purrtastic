//
//  AppDelegate.h
//  PetToGive
//
//  Created by Anna Billstrom on 3/13/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIActionSheetDelegate> {
    UINavigationController * navigationController;
    BOOL hasSeenPetChoice;
    int petChoice;  // 0 is cat, 1 is dog, 2 is animal lover
    NSDate *lastActiveDate;
    UIColor *lavender;
    UIColor *purple;
    UIColor *grayTextColor;
    NSDictionary *petDictionary;
    NSDate *morningActiveDate;
    NSDate *eveningActiveDate;
    NSInteger kibbleCount;
    NSDictionary *notificationsDict;
    BOOL canPet;
    NSInteger sessionCount;
    BOOL maxSessionPetsReached;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDate *lastActiveDate;
@property (strong, nonatomic) UIColor *lavender;
@property (strong, nonatomic) UIColor *purple;
@property (strong, nonatomic) UIColor *grayTextColor;
@property (strong, nonatomic) NSDictionary *petDictionary;
@property (strong, nonatomic) NSDictionary *notificationsDict;
@property (strong, nonatomic) NSDate *morningActiveDate;
@property (strong, nonatomic) NSDate *eveningActiveDate;
@property NSInteger kibbleCount;
@property BOOL canPet;
@property NSInteger sessionCount;
@property BOOL maxSessionPetsReached;

@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;

-(void)displayPetChoice;
-(void)setDefaults;
-(void)getDefaults;
-(void)fireNotification:(int)hour;
-(NSDate *)getDateFromHour:(int)hour;
-(int)petAgainTime;
-(void)resetSession;
//-(void)logFlurry:(NSString *)message;


@end
