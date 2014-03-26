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
    IBOutlet UIImageView *petPhoto;
    IBOutlet UILabel *instr1;
    IBOutlet UILabel *instr2;
    IBOutlet UILabel *petName;
    IBOutlet UITextView *petDescription;


    UIPanGestureRecognizer *panRecognizer;
    int heartCounter;
    NSArray *heartXPositions;
    int petCount;
    int toggle;
    int totalPetCount;
    int petChoice;

    bool pettingFinished;
    
    IBOutlet UIView *whiteBorderView;

}

@property (nonatomic, strong) IBOutlet UIImageView *petHand;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) IBOutlet UIImageView *petPhoto;
@property (nonatomic, strong) NSArray *heartXPositions;
@property (nonatomic, strong) IBOutlet UIView *whiteBorderView;
@property int petChoice;
@property (nonatomic, strong) IBOutlet UILabel *instr1;
@property (nonatomic, strong) IBOutlet UILabel *instr2;
@property (nonatomic, strong) IBOutlet UILabel *petName;
@property (nonatomic, strong) IBOutlet UITextView *petDescription;
- (IBAction)petAction:(id)sender;
- (void)animateHearts;
- (UIView *)addHeart;
- (void)ZigZag:(UIView *)heart ;
- (void)fadeOpacity:(UIView *)heart;
- (void)animateBigHeart:(UIView *)heart;
- (void)switchPhoto:(int)thePetChoice;


@end
