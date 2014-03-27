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

}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDate *lastActiveDate;

@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;

-(void)postNewPetalert;
-(void)displayPetChoice;
-(void)setDefaults;
-(void)getDefaults;

@end
