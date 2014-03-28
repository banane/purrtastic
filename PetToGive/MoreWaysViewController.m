//
//  MoreWaysViewController.m
//  PetToGive
//
//  Created by Anna Billstrom on 3/18/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "MoreWaysViewController.h"
#import "AppDelegate.h"
@interface MoreWaysViewController ()

@end

@implementation MoreWaysViewController
@synthesize shopLabel, petitionLabel, articleLabel,logo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"More Ways To Help";
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        shadow = [NSShadow new];
        [shadow setShadowColor: [UIColor clearColor]];
        [shadow setShadowOffset: CGSizeMake(0.0f, 1.0f)];

        
        boldRoboto17 = [UIFont fontWithName:@"Roboto-Bold" size:17];
        purple = appDelegate.purple;
        
        lavender = appDelegate.lavender;

        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              purple,UITextAttributeTextColor,boldRoboto17,UITextAttributeFont,
                                                              nil] forState:UIControlStateNormal];
        
        [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                           NSForegroundColorAttributeName: purple,
                                                                           NSFontAttributeName: boldRoboto17,
                                                                           NSShadowAttributeName: shadow
                                                                           }];
        [self.navigationController.navigationBar setBarTintColor:lavender];
        

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:lavender];
    [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                       NSForegroundColorAttributeName: purple,
                                                                       NSFontAttributeName: boldRoboto17,
                                                                       NSShadowAttributeName: shadow
                                                                       }];

}

-(IBAction)visitARS:(id)sender{
        
    NSString* launchUrl = @"http://theanimalrescuesite.greatergood.com/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO: add font to roboto
    // try to change back button colors too
    
    shopLabel.font = boldRoboto17;
    articleLabel.font = boldRoboto17;
    petitionLabel.font = boldRoboto17;
    shopLabel.backgroundColor = lavender;
    articleLabel.backgroundColor = lavender;
    petitionLabel.backgroundColor = lavender;
    
    // shop
    int x = 10; // nice border padding left for ads (300 width)
    CGRect screenRect= [[UIScreen mainScreen] bounds];
    int y = 0;
    if(screenRect.size.height <= 480){
        y = 45;
        logo.imageView.image = [UIImage imageNamed:@"ars_ad35"];
    } else {
        y  = 78;
    }
    
    y += 50;
    int label_height = 45;
    int ad_height = 100;

    CGFloat screenWidth = screenRect.size.width;

    GADAdSize customAdSize = GADAdSizeFromCGSize(CGSizeMake(300, ad_height));

    shopLabel.frame = CGRectMake(x, y, screenWidth, label_height);
    y += label_height;
    bannerViewShop_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewShop_.adUnitID = @"/24467070/PetToGive_MoreWays-1_300x100";
    bannerViewShop_.rootViewController = self;
    [self.view addSubview:bannerViewShop_];
    [bannerViewShop_ loadRequest:[GADRequest request]];

    // petition
    y += ad_height;
    petitionLabel.frame = CGRectMake(x, y, screenWidth, label_height);
    y += label_height;
    bannerViewPetition_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewPetition_.adUnitID = @"/24467070/PetToGive_MoreWays-2_300x100";
    bannerViewPetition_.rootViewController = self;
    [self.view addSubview:bannerViewPetition_];
    [bannerViewPetition_ loadRequest:[GADRequest request]];

    // article
    y += ad_height;
    articleLabel.frame = CGRectMake(x, y, screenWidth, label_height);
    y += label_height;
    bannerViewArticle_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewArticle_.adUnitID = @"/24467070/PetToGive_MoreWays-3_300x100";
    bannerViewArticle_.rootViewController = self;
    [self.view addSubview:bannerViewArticle_];
    [bannerViewArticle_ loadRequest:[GADRequest request]];
    


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
