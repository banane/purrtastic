//
//  ViewController.h
//  PetToGive
//
//  Created by Anna Billstrom on 3/13/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>
#import "Pet.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"


@interface ViewController : GAITrackedViewController <AVAudioPlayerDelegate> {
    IBOutlet UIImageView *petHand;
    IBOutlet UIImageView *petPhoto;
    IBOutlet UILabel *instr1;
    IBOutlet UILabel *instr2;
    IBOutlet UILabel *petName;
    IBOutlet UILabel *inactiveTitle;
    IBOutlet UILabel *inactiveTimeTil;
    IBOutlet UITextView *petDescription;
    IBOutlet UIView *loadingView;
    
 //   Pet *activePet;
    
    
    UIFont *robotoreg;
    UIFont *robotobold;
    UIFont *robotobolditalic;
    UIFont *robotoitalic;
    UIColor *grayTextColor;
    UIColor *lavender;

    UIPanGestureRecognizer *panRecognizer;
    int heartCounter;
    NSArray *heartXPositions;
    int petCount;
    int toggle;
    int totalPetCount;
    int petChoice;

    bool pettingFinished;
    
    NSTimer *timer;
    IBOutlet UIView *whiteBorderView;
    IBOutlet UIButton *moreWaysButton;
    
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *audioPlayerMeow;
    NSString *purr_sndpath;

}

@property (nonatomic, strong) IBOutlet UIImageView *petHand;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) IBOutlet UIImageView *petPhoto;
@property (nonatomic, strong) NSArray *heartXPositions;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) IBOutlet UIView *whiteBorderView;
@property int petChoice;
@property (nonatomic, strong) IBOutlet UILabel *instr1;
@property (nonatomic, strong) IBOutlet UILabel *instr2;
@property (nonatomic, strong) IBOutlet UILabel *petName;
@property (nonatomic, strong) IBOutlet UITextView *petDescription;
@property (nonatomic, strong) IBOutlet UILabel *inactiveTitle;
@property (nonatomic, strong) IBOutlet UILabel *inactiveTimeTil;
@property (nonatomic, strong) IBOutlet UIButton *moreWaysButton;
@property (nonatomic, strong) UIColor *lavender;
@property (nonatomic, strong) UIView *loadingView;

//@property (nonatomic, strong) Pet *activePet;

- (IBAction)petAction:(id)sender;
- (void)animateHearts;
- (UIView *)addHeart;
- (void)ZigZag:(UIView *)heart ;
- (void)fadeOpacity:(UIView *)heart;
- (void)animateBigHeart:(UIView *)heart;
- (void)updatePetUI;
-(void)becomeActivePet;
-(void)becomeInactivePet;
-(BOOL)isPetActionValid;
-(IBAction)viewMoreWays:(id)sender;
- (void)updateCounter:(NSTimer *)theTimer;
-(BOOL)isNextPetDateValid;
-(void)cleanUpHearts;

@end
