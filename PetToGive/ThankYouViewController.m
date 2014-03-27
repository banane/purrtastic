//
//  ThankYouViewController.m
//  PetToGive
//
//  Created by Anna Billstrom on 3/18/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "ThankYouViewController.h"
#import "MoreWaysViewController.h"

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
    bannerView_.adUnitID = @"/24467070/PetToGive_TY_300x250";
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    [bannerView_ loadRequest:[GADRequest request]];

    
}

-(IBAction)viewMoreWaysVC:(id)sender{
    MoreWaysViewController *mvc = [[MoreWaysViewController alloc] initWithNibName:@"MoreWaysViewController" bundle:nil];
    [[self navigationController] pushViewController:mvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
