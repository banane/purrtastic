//
//  ViewController.m
//  PetToGive
//
//  Created by Anna Billstrom on 3/13/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "ViewController.h"
#import "ThankYouViewController.h"
#import <QuartzCore/QuartzCore.h>

#define PET_THRESHHOLD ((int) 70)


@interface ViewController ()

@end

@implementation ViewController

@synthesize petHand, panRecognizer, petPhoto, heartXPositions, petChoice, whiteBorderView, instr1, instr2, petDescription, petName;

-(IBAction)petAction:(id)sender{
    
    petHand.hidden = YES;
    totalPetCount += 1;
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)panRecognizer translationInView:petPhoto];
    if(abs(translatedPoint.x) > 20 || abs(translatedPoint.y) > 20){
        if(petCount == 3){
            [self animateHearts];
            petCount = 0;
        } else {
            petCount += 1;
        }
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

}

- (void)viewDidLoad
{
    // stupid workaround for 4"
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self switchPhoto:petChoice]; // may get redrawn on notification

    UIColor *grayText =      [self renderColor:72   green:72   blue:72];

    UIFont *robotoreg = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
    UIFont *robotobold = [UIFont fontWithName:@"Roboto-Bold" size:17.0];

    instr1.font = robotoreg;
    instr1.textColor = grayText;
    instr2.font = robotoreg;
    instr2.textColor = grayText;
    petName.font = robotobold;
    petName.textColor = grayText;
    petDescription.font =  [UIFont fontWithName:@"Roboto-Regular" size:14.0];;
    petDescription.textColor = grayText;

    UIColor *grayBorder =      [self renderColor:208 green:208   blue:208];
    
    whiteBorderView.layer.borderColor = grayBorder.CGColor;
    whiteBorderView.layer.borderWidth = 1.0f;
    
    pettingFinished = NO;

    petCount = 0;
    petHand.hidden = NO;
    totalPetCount = 0;
    heartCounter = 1;
    
    heartXPositions = [[NSArray alloc] initWithObjects:
                       [NSNumber numberWithInteger:150],
                       [NSNumber numberWithInteger:140],
                       [NSNumber numberWithInteger:210],
                       [NSNumber numberWithInteger:230],
                       [NSNumber numberWithInteger:190],
                       [NSNumber numberWithInteger:260],
                       [NSNumber numberWithInteger:200],
                       [NSNumber numberWithInteger:270],
                       [NSNumber numberWithInteger:100],
                       [NSNumber numberWithInteger:130], nil];
    

    [super viewDidLoad];
	panRecognizer = [[UIPanGestureRecognizer alloc]
                     initWithTarget:self action:@selector(petAction:)];
    
    [petPhoto addGestureRecognizer:panRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePetChoice:)
                                                 name:@"PetPhotoChoiceNotification"
                                               object:nil];
}

-(void)receivePetChoice:(NSNotification *)notification{
    if ([[notification name] isEqualToString:@"PetPhotoChoiceNotification"]){
        NSLog (@"Successfully received the test notification!");
        NSLog(@"userinfo: %@", [notification userInfo]);
    }
    petChoice = [[[notification userInfo] objectForKey:@"petchoice"] intValue];
    [self switchPhoto:petChoice];
    
}

-(void)switchPhoto:(int)thePetChoice{
    switch (thePetChoice) {
        case 0:
            self.petPhoto.image = [UIImage imageNamed:@"umlaut_kitty"];
            break;
        case 1:
            self.petPhoto.image = [UIImage imageNamed:@"puppy"];
            // other cases irrelevant - could be either pet
            // TODO the mix-up of animal photos
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)animateHearts{

//    NSLog(@"heartcounter: %d", heartCounter);
    if(heartCounter == PET_THRESHHOLD ){
        
        if(pettingFinished == NO){
            pettingFinished = YES;
            UIView *heart = [self addHeart];
            [self animateBigHeart:heart];
        } else {
            // do nothing, termination is in animation
        }
    } else {
        heartCounter += 1;
        UIView *heart = [self addHeart];

        [self ZigZag:heart];

    }
}


- (void)fadeOpacity:(UIView *)heart{
    heart.alpha = heart.alpha - 0.15;
    if(heart.alpha <= 0.0){
        [heart removeFromSuperview];
    } else {
        [self ZigZag:heart];
    }
}

-(void)animateBigHeart:(UIView  *)heart{
 

    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         heart.transform = CGAffineTransformMakeScale(15.0, 15.0);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"big heart completion");
                         if(finished){
                             NSLog(@"big heart  finished.");
                             [self viewThankYou];
                         } else {
                             NSLog(@"big heart not finished.");
                         }
                     }
     ];
    
}

- (UIView *)addHeart{
   
    totalPetCount += 1;
    int r = arc4random() % 10;          // random index for x starting point
    int x = [[heartXPositions objectAtIndex:r] intValue];
    UIImageView *heart=[[UIImageView alloc] initWithFrame:CGRectMake(x, 300, 40, 40)];
    if(pettingFinished){
        heart.image = [UIImage imageNamed:@"exploding_heart"];
        heart.contentMode = UIViewContentModeScaleAspectFit;
        heart.center = CGPointMake(160, 300);
    } else {
        int a = arc4random() % 5;   // random image stars and hearts combined, 0..5
        if(a <= 1){                 // do stars if 0,1- convert to 1,2 for names of images
            heart.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%d", a + 1]];
        } else {                    // all other indexes hearts, go down 1 to get image name right 1..4
            heart.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d", (a - 1) ]];
        }
    }
    [self.view addSubview:heart];
    return heart;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

-(void)viewThankYou{
    NSLog(@"in self view thank you");
    
    NSString *xibname = @"ThankYouViewController";
    CGRect frame= [[UIScreen mainScreen] bounds];
    if(frame.size.height > 480){
        xibname = [NSString stringWithFormat:@"%@_4inch", xibname];
    }
    
    ThankYouViewController *tvc = [[ThankYouViewController alloc] initWithNibName:xibname bundle:nil];
    [[self navigationController] pushViewController:tvc animated:NO];
}


-(void)ZigZag:(UIView *)heart{
    toggle ^= 1;
    
    CGRect newFrame = heart.frame;
    if(toggle == 0){    // to go left or right
        newFrame.origin.x = heart.frame.origin.x - 50;
    } else {
        newFrame.origin.x = heart.frame.origin.x + 50;
    }
    newFrame.origin.y = heart.frame.origin.y - 50;
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         heart.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             if(heart.frame.origin.y > -40){  // do until top of window
                                 [self fadeOpacity:heart];
                             }
                         } else {
                         }
                     }
     ];
}

-(UIColor *)renderColor:(int)red green:(int)green blue:(int)blue{
    return [UIColor colorWithRed:((float)red/255.0f) green:((float)green/255.0f) blue:((float)blue/255.0f) alpha:1.0f];
}


@end
