//
//  pet.m
//  PetToGive
//
//  Created by Anna Billstrom on 3/28/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "Pet.h"

@implementation Pet
@synthesize name, story, key, type,image;

-(id)init:(NSString *)theName Story:(NSString *)theStory Key:(int)theKey Type:(NSString *)theType Image:(UIImage *)theImage{
    self.key = theKey;
    self.name = theName;
    self.story = theStory;
    self.type = theType;
    self.image = [self getImage];
    return self;
}

-(UIImage *)getImage{
    NSString *imageName = [NSString stringWithFormat:@"%@_%d_1x", self.type, self.key];
    UIImage *petImage = [UIImage imageNamed:imageName];
    return petImage;
}

-(id)init:(NSString *)theName Key:(int)theKey{
    self.key = theKey;
    self.name = theName;
    return self;
}

// evaluate random choices to see if matches user's pet choice

-(BOOL)isTypeMatch:(int)petChoice{
    BOOL retValue = NO;
    
    switch (petChoice) {
        case 0:
            if ([self.type isEqualToString:@"cat"])
            retValue = YES;
            break;
        case 1:
            if ([self.type isEqualToString:@"dog"])
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
