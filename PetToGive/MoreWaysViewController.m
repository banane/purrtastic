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

        int version = [[[UIDevice currentDevice] systemVersion] intValue];
        if (version >= 7){
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

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.screenName = @"More Ways Screen";
    [self.navigationController setNavigationBarHidden:NO];
    int version = [[[UIDevice currentDevice] systemVersion] intValue];
    if (version >= 7){

        [self.navigationController.navigationBar setBarTintColor:lavender];
        [self.navigationController.navigationBar setTitleTextAttributes: @{
                                                                           NSForegroundColorAttributeName: purple,
                                                                           NSFontAttributeName: boldRoboto17,
                                                                           NSShadowAttributeName: shadow
                                                                           }];
    }
}

-(IBAction)visitARS:(id)sender{
// AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
  //  [appDelegate logFlurry:@"Click visit ARS from More Ways"];
    
    NSString* launchUrl = @"http://m.theanimalrescuesite.greatergood.com/clickToGive/ars/home?origin=P2G_MOREWAYS_ARSHEADER";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    float deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

    shopLabel.font = boldRoboto17;
    articleLabel.font = boldRoboto17;
    petitionLabel.font = boldRoboto17;
    shopLabel.backgroundColor = lavender;
    articleLabel.backgroundColor = lavender;
    petitionLabel.backgroundColor = lavender;
    
    CGRect screenRect= [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    
    int logo_3inch_height = 44;         // 3-1/2 inch
    int logo_4inch_height_diff = 34;
    int nav_bar_height = 44;
    int x = 10;                         // nice border padding left for ads (300 width)
    int label_height = 42;              // 4inch
    int ad_height = 100;
    int label_width = screenWidth - 20;

    int y = nav_bar_height;
    
    int new_logo_height = logo_3inch_height;
    if(screenRect.size.height <= 480){  // 3-1/2
        [logo setImage:[UIImage imageNamed:@"ars_ad35x"] forState:UIControlStateNormal];
        label_height = 24;
    } else {                            // 4"
        new_logo_height += logo_4inch_height_diff;
    }

    if(deviceVersion >= 7.0){
        y += 20;
    } else {
        y -= 40;
    }
    
    logo.frame = CGRectMake(0, y, 320, new_logo_height);


    GADAdSize customAdSize = GADAdSizeFromCGSize(CGSizeMake(300, ad_height));

    y = y +  new_logo_height;
    
    shopLabel.frame = CGRectMake(x, y, label_width, label_height);

    y += label_height;
    bannerViewShop_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewShop_.adUnitID = @"/24467070/PetToGive_MoreWays-1_300x100";
    bannerViewShop_.rootViewController = self;
    [self.view addSubview:bannerViewShop_];
    [bannerViewShop_ loadRequest:[GADRequest request]];

    // petition
    y += ad_height;
    petitionLabel.frame = CGRectMake(x, y, label_width, label_height);
    y += label_height;
    bannerViewPetition_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewPetition_.adUnitID = @"/24467070/PetToGive_MoreWays-2_300x100";
    bannerViewPetition_.rootViewController = self;
    [self.view addSubview:bannerViewPetition_];
    [bannerViewPetition_ loadRequest:[GADRequest request]];

    // article
    y += ad_height;
    articleLabel.frame = CGRectMake(x, y, label_width, label_height);
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
