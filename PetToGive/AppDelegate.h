//
//  AppDelegate.h
//  PetToGive
//
//  Created by Anna Billstrom on 3/13/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIActionSheetDelegate> {
    UINavigationController * navigationController;
    BOOL hasSeenPetChoice;
    int petChoice;  // 0 is cat, 1 is dog, 2 is animal lover
    NSDate *lastActiveDate;
    UIColor *lavender;
    UIColor *purple;
    UIColor *grayTextColor;
    NSDictionary *petDictionary;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDate *lastActiveDate;
@property (strong, nonatomic) UIColor *lavender;
@property (strong, nonatomic) UIColor *purple;
@property (strong, nonatomic) UIColor *grayTextColor;
@property (strong, nonatomic) NSDictionary *petDictionary;

@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;

-(void)postNewPetalert;
-(void)displayPetChoice;
-(void)setDefaults;
-(void)getDefaults;
-(void)fireNotification:(int)hour;

@end
