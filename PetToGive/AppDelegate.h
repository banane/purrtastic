//
//  AppDelegate.h
//  PetToGive
//
//  Created by Anna Billstrom on 3/13/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestFlight.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIActionSheetDelegate> {
    UINavigationController * navigationController;
    BOOL firstTimeIn;
    int petChoice;  // 0 is cat, 1 is dog

}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;

@end
