//
//  ViewController.h
//  PetToGive
//
//  Created by Anna Billstrom on 3/13/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UIImageView *petHand;
    UIPanGestureRecognizer *panRecognizer;
    IBOutlet UIImageView *petPhoto;
    int heartCounter;
    NSArray *heartXPositions;
    int petCount;
    int toggle;
    int totalPetCount;
    IBOutlet UIImageView *explodingHeart;
    bool pettingFinished;

}

@property (nonatomic, strong) IBOutlet UIImageView *petHand;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) IBOutlet UIImageView *petPhoto;
@property (nonatomic, strong) NSArray *heartXPositions;
@property (nonatomic, strong) IBOutlet UIImageView *explodingHeart;

- (void)petAction;
- (void)animateHearts;
- (UIView *)addHeart;
- (void)ZigZag:(UIView *)heart ;
- (void)fadeOpacity:(UIView *)heart;
- (void)animateBigHeart:(UIView *)heart;
//- (void)checkViews;

@end
