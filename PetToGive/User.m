//
//  User.m
//  PetToGive
//
//  Created by Anna Billstrom on 6/3/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize petChoice, petChoiceString,lifetimeKibbleCount, lastPetId;

-(id)init:(int)mPetChoice kibbleCount:(int)mKibbleCount lastPetId:(int)mLastPetId{
    self = [super init];
    if(self){
        self.petChoice = mPetChoice;
        self.petChoiceString = [self getPetChoiceString:mPetChoice];
        self.lifetimeKibbleCount = mKibbleCount;
        self.lastPetId = mLastPetId;
    }
    return self;
}

-(NSString *)getPetChoiceString:(int)mPetChoice{
    NSString *tmpString = @"";
    switch (mPetChoice){
        case 0:
            tmpString = @"cat";
            break;
        case 1:
            tmpString = @"dog";
            break;
        case 2:
            tmpString = @"animal lover";
            break;
        default:
            tmpString = @"dog";
            break;
    }
    return tmpString;
}

@end
