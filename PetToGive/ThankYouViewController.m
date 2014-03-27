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
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle origin:CGPointMake(10, 166)];
    bannerView_.adUnitID = @"/91636279/thank_you_page";
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
