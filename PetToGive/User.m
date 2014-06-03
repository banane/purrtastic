//
//  User.m
//  PetToGive
//
//  Created by Anna Billstrom on 6/3/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize petChoice, petChoiceString,lifetimeKibbleCount;

-(id)init:(int)mPetChoice kibbleCount:(int)mKibbleCount lastPetId:(int)mLastPetId{
    self = [super init];
    if(self){
        self.petChoice = mPetChoice;
        switch (mPetChoice){
            case 0:
                self.petChoiceString = @"cat";
                break;
            case 1:
                self.petChoiceString = @"dog";
                break;
            case 2:
                self.petChoiceString = @"animal lover";
                break;
            default:
                self.petChoiceString = @"dog";
                break;
        }
        self.lifetimeKibbleCount = mKibbleCount;
        self.lastPetId = mLastPetId;
    }
    return self;
}

@end
