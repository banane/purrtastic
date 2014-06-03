//
//  pet.m
//  PetToGive
//
//  Created by Anna Billstrom on 3/28/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "Pet.h"

@implementation Pet
@synthesize name, story, remoteId, animalType, image;

-(id)init:(NSString *)mName Story:(NSString *)mStory remoteId:(NSString *)mRemoteId animalType:(NSString *)mAnimalType imageUrl:(NSString *)mImageUrl{
    self = [super init];
    if (self) {
        // Initialize self.
        
        self.remoteId = mRemoteId;
        self.name = mName;
        self.story = mStory;
        self.animalType = mAnimalType;
        self.image = [self getImage:mImageUrl];
    }
    return self;
}

-(UIImage *)getImage:(NSString *)theImageUrl{    
    UIImage *petImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:theImageUrl]]];
    return petImage;
}


// evaluate random choices to see if matches user's pet choice

-(BOOL)isTypeMatch:(int)petChoice{
    BOOL retValue = NO;
    
    switch (petChoice) {
        case 0:
            if ([self.animalType isEqualToString:@"cat"])
            retValue = YES;
            break;
        case 1:
            if ([self.animalType isEqualToString:@"dog"])
                retValue = YES;
            break;
            
        case 2:
            retValue=YES;
            
        default:
            break;
    }
    return retValue;
}
@end
