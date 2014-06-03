//
//  Pet.h
//  PetToGive
//
//  Created by Anna Billstrom on 3/28/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pet : NSObject {
    NSString *name;
    NSString *story;
    NSString *remoteId;
    NSString *animalType;
    UIImage *image;
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *story;
@property (nonatomic, strong) NSString *remoteId;
@property (nonatomic, strong) NSString *animalType;
@property (nonatomic, strong) UIImage *image;

-(id)init:(NSString *)mName Story:(NSString *)mStory remoteId:(NSString *)mRemoteId animalType:(NSString *)mAnimalType imageUrl:(NSString *)mImageUrl;
-(BOOL)isTypeMatch:(int)petChoice;
-(UIImage *)getImage:(NSString *)theImageUrl;

@end
