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
#import "AppDelegate.h"
#import "MoreWaysViewController.h"

#define PET_THRESHHOLD ((int) 35)
#define HOURS_TO_WAIT ((int) 4)


@interface ViewController ()

@end

@implementation ViewController

@synthesize petHand, panRecognizer, petPhoto, heartXPositions, petChoice, timer, whiteBorderView, instr1, instr2, petDescription, petName, inactiveTimeTil, inactiveTitle, moreWaysButton,lavender, activePet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        grayTextColor =  appDelegate.grayTextColor;
        lavender = appDelegate.lavender;
        
        robotoreg = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
        robotobold = [UIFont fontWithName:@"Roboto-Bold" size:17.0];
        

    }
    return self;
}


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
    if([self isPetActionValid]){
        [self becomeActivePet];
    } else {
        [self becomeInactivePet];
    }

}

- (void)viewDidLoad
{
    // stupid workaround for 4"
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self switchPhoto:petChoice]; // may get redrawn on notification

    instr1.font = robotoreg;
    instr1.textColor = grayTextColor;
    instr2.font = robotoreg;
    instr2.textColor = grayTextColor;
    petName.font = robotobold;
    petName.textColor = grayTextColor;
    petDescription.font =  [UIFont fontWithName:@"Roboto-Regular" size:14.0];;
    petDescription.textColor = grayTextColor;
    inactiveTitle.font = robotoreg;
    inactiveTimeTil.font = robotoreg;
    

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
    
    // setup purr playback
    NSError *error;
    purr_sndpath = [[NSBundle mainBundle] pathForResource:@"purr" ofType:@"wav"];
    NSURL *mSoundURL = [NSURL fileURLWithPath:purr_sndpath];
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:mSoundURL
                   error:&error];
    
    if(error)
        NSLog(@"play mind music sound error: %@", [error localizedDescription]);

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
    [self pickPet];
    self.petPhoto.image = activePet.image;
    self.petDescription.text = activePet.story;
    self.petName.text = activePet.name;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark animation methods

- (void)animateHearts{

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
        [self playPurr];
        [self ZigZag:heart];

    }
}
-(void)playPurr{
    
    if(!audioPlayer.playing){
        [audioPlayer play];
    }
}

-(void)playMeow{
    // setup purr playback
    NSError *error;
    purr_sndpath = [[NSBundle mainBundle] pathForResource:@"meow" ofType:@"wav"];
    NSURL *mSoundURL = [NSURL fileURLWithPath:purr_sndpath];
    audioPlayerMeow = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:mSoundURL
                   error:&error];
    [audioPlayerMeow play];
    
    if(error)
        NSLog(@"play mind music sound error: %@", [error localizedDescription]);

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

#pragma mark inactive/active viewing methods

-(void)startWaitingPeriod{
    NSLog(@"setting pet to inactive, starting waiting period");
    //
    // after a successful petting action, set the next time user can pet again
    // this is called: lastActiveDate.
    // check this value each time displayed
    // timer wasn't valid since view is removed frequently - more consistent to put in stored default
    // push notifications also check this default, to see if petting action is valid
    //
 
    int timeInterval = 60*60*HOURS_TO_WAIT;
    // debug - remove when live
    timeInterval = 15;  // 15 seconds
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.lastActiveDate = [[NSDate date] dateByAddingTimeInterval:timeInterval];
    [appDelegate setDefaults];
    NSLog(@"just set active date: %@", appDelegate.lastActiveDate);
}

-(void)checkType:(Pet *)pet{
    
    if([pet isTypeMatch:petChoice]){
        activePet = pet;
    } else {
        [self pickPet];
    }
}

-(void)pickPet{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSArray *keys = [appDelegate.petDictionary allKeys];
    int size = [keys count];

    int petIndex = (arc4random() % size);
    petIndex += 1;
    
    
    NSLog(@"petindex: %d", petIndex);
    Pet *tempPet = [appDelegate.petDictionary objectForKey:[NSNumber numberWithInt:petIndex]];
    // recursive
    
    NSLog(@"pet type: %@", tempPet.type);
    NSLog(@"pet name: %@", tempPet.name);

    [self checkType:tempPet];
}

-(void)becomeActivePet{
    [self switchPhoto:petChoice];
    [petPhoto addGestureRecognizer:panRecognizer];
    
    // show active elements
    self.petDescription.hidden = NO;
    self.petName.hidden = NO;
    self.petHand.hidden = NO;
    self.instr1.hidden = NO;
    self.instr2.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    // hide inactive view
    self.inactiveTitle.hidden = YES;
    self.inactiveTimeTil.hidden = YES;
    self.moreWaysButton.hidden = YES;
    
}
-(void)becomeInactivePet{
    NSString *imageName = @"cat";
    if(petChoice == 1){
        imageName = @"dog";
    }
    self.petPhoto.image = [UIImage imageNamed:imageName];
    
    // hide active view
    
    self.petName.hidden = YES;
    self.petDescription.hidden = YES;
    self.petHand.hidden = YES;
    self.instr1.hidden = YES;
    self.instr2.hidden = YES;
    self.view.backgroundColor = [self renderColor:253 green:244 blue:255];
    // TODO: findout why this property is rendering black
    // self.view.backgroundColor = lavender;
    
    
    // show active view
    self.inactiveTimeTil.hidden = NO; //TODO update time with real values
    self.inactiveTitle.hidden = NO;
    self.moreWaysButton.hidden = NO;
    
    // turn off gesture
    [petPhoto removeGestureRecognizer:panRecognizer];
}

#pragma mark petting action methods

-(BOOL)isPetActionValid{
    NSLog(@"in 'is pet action valid' method");
    BOOL retValue = NO;
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSDate *validActionDate = appDelegate.lastActiveDate; // add interval
    NSDate *today = [NSDate date];
    NSLog(@"today: %@, valid action date: %@", today, validActionDate);

    if(validActionDate == nil){
        retValue = YES;
    } else {
    
        //TODO add logic to compare dates
        switch ([today compare:validActionDate]){
            case NSOrderedDescending:
                NSLog(@"nsorderdescending");
                retValue = YES;
                break;
            case NSOrderedAscending:
                NSLog(@"nsorder ascending");
                retValue = NO;
                break;
            case NSOrderedSame:
                NSLog(@"nsordered same");
                retValue = NO;
                break;
        }
    }

    
    return retValue;
}

-(IBAction)viewMoreWays:(id)sender{
    MoreWaysViewController *mvc = [[MoreWaysViewController alloc] initWithNibName:@"MoreWaysViewController" bundle:nil];
    [[self navigationController] pushViewController:mvc animated:YES];    
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
        [self playMeow];
        [self startWaitingPeriod];
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

#pragma mark utilities

-(UIColor *)renderColor:(int)red green:(int)green blue:(int)blue{
    return [UIColor colorWithRed:((float)red/255.0f) green:((float)green/255.0f) blue:((float)blue/255.0f) alpha:1.0f];
}


@end
