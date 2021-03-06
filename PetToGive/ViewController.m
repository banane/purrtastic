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
        robotoitalic = [UIFont fontWithName:@"Roboto-Italic" size:17.0];
        robotobolditalic = [UIFont fontWithName:@"Roboto-BoldItalic" size:17.0];
        
    }
    return self;
}

- (void)countDownTimer{
    
    if([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

- (void)updateCounter:(NSTimer *)theTimer {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    int secondsLeft = [appDelegate petAgainTime];
    
    
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        int hours = secondsLeft / 3600;
        int minutes = (secondsLeft % 3600) / 60;
        int seconds = (secondsLeft %3600) % 60;
        inactiveTimeTil.text = [NSString stringWithFormat:@"Pet again in: %02dh %02dm %02ds", hours, minutes, seconds];
        inactiveTimeTil.hidden = NO;
    }
    else{
        
        [self becomeActivePet];
        [timer invalidate];
        timer = nil;
    }
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
    
     self.screenName = @"Pet Action Screen";
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
    [self setupButton];

    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
   // [self switchPhoto:petChoice]; // may get redrawn on notification

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
    

    petHand.hidden = NO;

    /* pet control constants */
    pettingFinished = NO;
    petCount = 0;
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

-(void)promptPetting{
//    instr1.font = robotoitalic;
//    instr1.font = robotobolditalic;
    instr1.font = [UIFont italicSystemFontOfSize:17.0f];
    instr1.textColor = grayTextColor;
    instr1.text = @"Keep petting!";

    instr2.hidden = YES;
}
-(void)calculateKibble{
    instr1.text = @"Calculating kibble...";
//    instr1.font = robotoitalic;
}

-(void)receivePetChoice:(NSNotification *)notification{
    if ([[notification name] isEqualToString:@"PetPhotoChoiceNotification"]){
        NSLog (@"Successfully received the test notification!");
        NSLog(@"userinfo: %@", [notification userInfo]);
    }
    petChoice = [[[notification userInfo] objectForKey:@"petchoice"] intValue];
    if((petChoice < 2) && ![activePet isTypeMatch:petChoice]){
        [self switchPhoto:petChoice];
    }
}

-(void)switchPhoto:(int)thePetChoice{
    
    [self pickPet];
    self.petPhoto.image = activePet.image;
    self.petDescription.text = activePet.story;
    self.petName.text = activePet.name;
    [self setupAudio];
}

-(void)setupButton{

    UIColor *dark = [self renderColor:153 green:102 blue:204];
    UIColor *light = [self renderColor:216 green:193 blue:234];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[moreWaysButton layer] bounds];
    gradient.cornerRadius = 5;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)light.CGColor,
                       (id)dark.CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.7f],
                          nil];
    gradient.borderColor = [dark CGColor];
    
    [[moreWaysButton layer] insertSublayer:gradient atIndex:0];
}

-(void)setupAudio{
    // setup purr playback
    NSString *soundfile;
    if([activePet.type isEqualToString:@"cat"]){
            soundfile = @"purr";
    } else {
        soundfile = @"pant";
    }
    NSError *error;
    purr_sndpath = [[NSBundle mainBundle] pathForResource:soundfile ofType:@"wav"];
    NSURL *mSoundURL = [NSURL fileURLWithPath:purr_sndpath];
    audioPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:mSoundURL
                   error:&error];
    
    if(error)
        NSLog(@"play mind music sound error: %@", [error localizedDescription]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark animation methods

- (void)animateHearts{

    if(heartCounter == PET_THRESHHOLD ){
        [self calculateKibble];
        
        if(pettingFinished == NO){
            pettingFinished = YES;
            UIView *heart = [self addHeart];
            [self logFinish];
            [self animateBigHeart:heart];
        } else {
            // do nothing, termination is in animation
        }
    } else {
        if(heartCounter > 1 && heartCounter < 10){
            [self promptPetting];
        }
        heartCounter += 1;
        UIView *heart = [self addHeart];
        heart.tag = 1000 + heartCounter; // for deleting later
        [self playPurr];
        [self ZigZag:heart];

    }
}

-(void)logFinish{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"PetToGive"     // Event category (required)
                                                          action:@"pet"  // Event action (required)
                                                           label:activePet.type           // Event label
                                                           value:nil] build]];    // Event value
}
-(void)playPurr{
    
//    if(!audioPlayer.playing){
        [audioPlayer play];
//    }
}
-(void)stopPurr{
    if(audioPlayer.playing){
        [audioPlayer stop];
    }
}

-(void)playMeow{
    // setup purr playback
    NSError *error;
    NSString *soundfile;
     if([activePet.type isEqualToString:@"cat"]){
         soundfile = [[NSBundle mainBundle] pathForResource:@"meow" ofType:@"wav"];
     } else {
         soundfile = [[NSBundle mainBundle] pathForResource:@"bark" ofType:@"wav"];
     }
    NSURL *mSoundURL = [NSURL fileURLWithPath:soundfile];
    audioPlayerMeow = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:mSoundURL
                   error:&error];
    [audioPlayerMeow play];
    
    if(error)
        NSLog(@"play bark/meow  sound error: %@", [error localizedDescription]);

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
                         if(finished){
                             NSLog(@"big heart  finished.");
                         } else {
                             NSLog(@"big heart not finished.");

                         }
                         heart.hidden = YES;
                         [self viewThankYou];

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
    // 7pm day of or 10am day of
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate setKibbleCount:(appDelegate.kibbleCount += 10)];

    NSDate *morningDate = [appDelegate getDateFromHour:10];
    NSDate *eveningDate = [appDelegate getDateFromHour:19];
    
    NSDate *today = [NSDate date];
    // comparisons
    // if morning date is next, set that, else check evening date
    NSDate *targetDate;
    if([self compareDates:morningDate dateTo:today]){
        targetDate = morningDate;
        NSLog(@"morning date is next active");
    } else if([self compareDates:eveningDate dateTo:today]) {
        targetDate = eveningDate;
        NSLog(@"evening date is next active");
    } else {
        // tomorrow morning
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        NSDateComponents* components = [[NSDateComponents alloc] init];
        components.day = 1;
        targetDate = [calendar dateByAddingComponents: components toDate: morningDate options: 0];
    }
    
    
    //debugging
 /*
    NSCalendar* calendar2 = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents* components2 = [[NSDateComponents alloc] init];
    components2.second = 60;
    targetDate = [calendar2 dateByAddingComponents: components2 toDate: today options: 0];
  */
    // end debugging
   
    appDelegate.lastActiveDate = targetDate;
    [appDelegate setDefaults];
 //   NSLog(@"just set active date: %@", appDelegate.lastActiveDate);
}

-(BOOL)compareDates:(NSDate *)dateFrom dateTo:(NSDate *)dateTo{
//    NSLog(@"from date: %@, to date: %@", dateFrom, dateTo);
    
    BOOL retValue = NO; // earlier
    switch ([dateFrom compare:dateTo]){
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
    return retValue;

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
    int size = (int)[keys count];

    int petIndex = (arc4random() % size);
    petIndex += 1;
    
    
    Pet *tempPet = [appDelegate.petDictionary objectForKey:[NSNumber numberWithInt:petIndex]];

    [self checkType:tempPet];
}

-(void)becomeActivePet{
    
    petCount = 0;
    totalPetCount = 0;
    heartCounter = 1;
    pettingFinished = NO;
    
    [self switchPhoto:petChoice];
    
    [petPhoto addGestureRecognizer:panRecognizer];
    
    // reset, might have been shifted down in inactive view
    CGRect frame= [[UIScreen mainScreen] bounds];
    if (frame.size.height == 480 && self.petPhoto.frame.origin.y != 167){
        self.petPhoto.frame = CGRectMake(self.petPhoto.frame.origin.x, 167, self.petPhoto.frame.size.width, self.petPhoto.frame.size.height);
    }

    
    // show active elements
    self.petDescription.hidden = NO;
    self.petName.hidden = NO;
    self.petHand.hidden = NO;
    self.instr1.hidden = NO;
    self.instr1.text = @"Use your finger to pet me";
    self.instr1.font = robotoreg;
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
    
    CGRect frame= [[UIScreen mainScreen] bounds];
    NSLog(@"height: %f", frame.size.height);
    if (frame.size.height == 480 && self.petPhoto.frame.origin.y == 167){
        self.petPhoto.frame = CGRectMake(self.petPhoto.frame.origin.x, self.petPhoto.frame.origin.y -70, self.petPhoto.frame.size.width, self.petPhoto.frame.size.height);
    }
    
    // hide active view
    
    petName.hidden = YES;
    petDescription.hidden = YES;
    petHand.hidden = YES;
    instr1.hidden = YES;
    instr2.hidden = YES;
//    self.view.backgroundColor = [self renderColor:253 green:244 blue:255];
    // TODO: findout why this property is rendering black
    // self.view.backgroundColor = lavender;
    
    
    // show active view
    inactiveTitle.hidden = NO;
    moreWaysButton.hidden = NO;
    inactiveTimeTil.hidden = NO;
    
    // turn off gesture
    [petPhoto removeGestureRecognizer:panRecognizer];
    
    [self countDownTimer];
}

#pragma mark petting action methods

-(BOOL)isPetActionValid{
    BOOL retValue = NO;
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if([self isNextPetDateValid]){        // date is in past, reset session
        retValue = YES;
        [appDelegate resetSession];
        NSLog(@"valid date in past, reset values");
    } else {
        NSLog(@"max sessions pet reached: %d", appDelegate.maxSessionPetsReached);
        if((appDelegate.sessionCount < 3) && (!appDelegate.maxSessionPetsReached)){
            //  date invalid but leftovers from earlier session
            retValue = YES;
            NSLog(@"valid date in future, but countdown left");
        } else {
            NSLog(@"valid date in future, no countdown left");

        }
    }
    
    return retValue;
}

-(BOOL)isNextPetDateValid{
    BOOL retValue = NO;

    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSDate *validActionDate = appDelegate.lastActiveDate; // add interval
    NSDate *today = [NSDate date];

    if(validActionDate == nil){
        retValue = YES;
    } else {
    
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
        [self stopPurr];
        [self playMeow];
        [self finishedPetAction];
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

-(void)finishedPetAction{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.sessionCount += 1;
    if(appDelegate.sessionCount == 3){
        appDelegate.sessionCount = 0; //reset
        appDelegate.maxSessionPetsReached = YES;
    }
    [self startWaitingPeriod];

    NSLog(@"in finishedPetAction sessioncount: %ld", (long)appDelegate.sessionCount);
}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self cleanUpHearts];
}

-(void)cleanUpHearts{
    for (UIView *subview in [[self view ] subviews])
    {
        if (subview.tag > 1000){  // is a heart
            [subview removeFromSuperview];
        }
    }
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
                             [self fadeOpacity:heart];
                         }
                     }
     ];
}

#pragma mark utilities

-(UIColor *)renderColor:(int)red green:(int)green blue:(int)blue{
    return [UIColor colorWithRed:((float)red/255.0f) green:((float)green/255.0f) blue:((float)blue/255.0f) alpha:1.0f];
}


@end
