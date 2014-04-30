//
//  ThankYouViewController.m
//  PetToGive
//
//  Created by Anna Billstrom on 3/18/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "ThankYouViewController.h"
#import "MoreWaysViewController.h"
#import "AppDelegate.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController
@synthesize moreWaysButton, conversionPet, conversionTotal, thankYouHead, yourPetCounted, petAgainTime, petAgainButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"Thank You Screen";
    [self.navigationController setNavigationBarHidden:YES];
    [self setupKibble];
    [self setupButton];
    [self setupCountButton];
}

-(void)setupCountButton{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSLog(@"******** in setupcountbutton, sessioncoutn: %ld", (long)appDelegate.sessionCount);

    self.petAgainButton.hidden = NO;
    self.petAgainTime.hidden = YES;
    
    
    if(appDelegate.sessionCount == 1){
        [petAgainButton setTitle:@"2 Pets left- Pet Again!"forState:UIControlStateNormal];
    } else if(appDelegate.sessionCount == 2){
        [petAgainButton setTitle:@"1 Pet left- Pet Again!"forState:UIControlStateNormal];
    } else if(appDelegate.sessionCount == 3){
        [self updateViewToWaitingForPetAction];
    } else {
        [self updateViewToWaitingForPetAction];
    }
}
-(void)updateViewToWaitingForPetAction{
    self.petAgainTime.hidden = NO;
    self.petAgainButton.hidden = YES;
    [self countDownTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup ui elmeents
    UIFont *roboticBold17 = [UIFont fontWithName:@"Roboto-Bold" size:17.0];
    conversionTotal.font  = roboticBold17;
    conversionPet.font = roboticBold17;
    
    thankYouHead.font = [UIFont fontWithName:@"Roboto-Bold" size:31.0];
    yourPetCounted.font = [UIFont fontWithName:@"Roboto-Bold" size:21.0];
    petAgainTime.font = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
    moreWaysButton.titleLabel.font = [UIFont fontWithName:@"Roboto-BOld" size:23.0];
    
    // setup dynamic ad banner

    // int y = 166; // 3.5" position
    
    int y = 176; // 3.5" position
    
    float deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGRect frame= [[UIScreen mainScreen] bounds];
    if(frame.size.height > 480){        // is 4inch
        y+= 46;
        if(deviceVersion >= 7.0){           // b/c of system bar, shift down 20
            y += 20;
        }
    }
   
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle origin:CGPointMake(10, y)];
    bannerView_.adUnitID = @"/24467070/PetToGive_TY_300x250";
//    bannerView_.adUnitID = @"ca-app-pub-5561915841385473/1065894395";
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    [bannerView_ loadRequest:[GADRequest request]];

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
        petAgainTime.text = [NSString stringWithFormat:@"Pet again in: %02dh %02dm %02ds", hours, minutes, seconds];
        petAgainTime.hidden = NO;
    } else {
        [appDelegate resetSession];
        [self viewPetActionVC:nil];
    }
}


-(void)setupKibble{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.conversionTotal.text = [NSString stringWithFormat:@"Your total pets have given: %d kibbles", (int)appDelegate.kibbleCount ];
}


-(IBAction)viewMoreWaysVC:(id)sender{
        
    MoreWaysViewController *mvc = [[MoreWaysViewController alloc] initWithNibName:@"MoreWaysViewController" bundle:nil];
    [[self navigationController] pushViewController:mvc animated:YES];
//    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//    [appDelegate logFlurry:@"Click button view more ways"];

}

-(IBAction)viewPetActionVC:(id)sender{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(UIColor *)renderColor:(int)red green:(int)green blue:(int)blue{
    return [UIColor colorWithRed:((float)red/255.0f) green:((float)green/255.0f) blue:((float)blue/255.0f) alpha:1.0f];
}

@end
