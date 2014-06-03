//
//  User.h
//  PetToGive
//
//  Created by Anna Billstrom on 6/3/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    int petChoice;
    NSString *petChoiceString;
    int lifetimeKibbleCount;
    int lastPetId;
}

@property int petChoice;
@property NSString *petChoiceString;
@property int lifetimeKibbleCount;
@property int lastPetId;

-(id)init:(int)mPetChoice kibbleCount:(int)mKibbleCount lastPetId:(int)mLastPetId;
-(NSString *)getPetChoiceString:(int)mPetChoice;

@end
