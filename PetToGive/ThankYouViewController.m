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
@synthesize moreWaysButton, conversionPet, conversionTotal, thankYouHead, yourPetCounted, petAgainTime;

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
    [self.navigationController setNavigationBarHidden:YES];
    [self setupKibble];
    [self countDownTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate logFlurry:@"Thank You page load"];
    
    // setup ui elmeents
    UIFont *roboticBold17 = [UIFont fontWithName:@"Roboto-Bold" size:17.0];
    conversionTotal.font  = roboticBold17;
    conversionPet.font = roboticBold17;
    
    thankYouHead.font = [UIFont fontWithName:@"Roboto-Bold" size:31.0];
    yourPetCounted.font = [UIFont fontWithName:@"Roboto-Bold" size:21.0];
    petAgainTime.font = [UIFont fontWithName:@"Roboto-Regular" size:17.0];
    moreWaysButton.titleLabel.font = [UIFont fontWithName:@"Roboto-BOld" size:23.0];
    
    // setup dynamic ad banner

    int y = 166; // 3.5" position
    
    float deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGRect frame= [[UIScreen mainScreen] bounds];
    if(frame.size.height > 480){        // is 4inch
        y+= 46;
        if(deviceVersion >= 7.0){           // b/c of system bar, shift down 20
            y += 20;
        }
    }
   
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle origin:CGPointMake(10, y)];
//    bannerView_.adUnitID = @"/24467070/PetToGive_TY_300x250"
    bannerView_.adUnitID = @"ca-app-pub-5561915841385473/1065894395";
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
    }
    else{
//        secondsLeft = 16925;
    }
}

-(void)setupKibble{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.conversionTotal.text = [NSString stringWithFormat:@"Your total pets have given: %d kibbles", (int)appDelegate.kibbleCount ];
}


-(IBAction)viewMoreWaysVC:(id)sender{
        
    MoreWaysViewController *mvc = [[MoreWaysViewController alloc] initWithNibName:@"MoreWaysViewController" bundle:nil];
    [[self navigationController] pushViewController:mvc animated:YES];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate logFlurry:@"Click button view more ways"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
