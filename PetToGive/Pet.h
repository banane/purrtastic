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
    int key;
    NSString *type; // 1 cat 2 dog
    UIImage *image;
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *story;
@property int key;
@property  (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIImage *image;

-(id)init:(NSString *)theName Story:(NSString *)theStory Key:(int)theKey Type:(NSString *)theType Image:(UIImage *)theImage;
-(id)init:(NSString *)theName Key:(int)theKey;
-(BOOL)isTypeMatch:(int)petChoice;
-(UIImage *)getImage;

@end
