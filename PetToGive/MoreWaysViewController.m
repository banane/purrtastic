//
//  MoreWaysViewController.m
//  PetToGive
//
//  Created by Anna Billstrom on 3/18/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "MoreWaysViewController.h"

@interface MoreWaysViewController ()

@end

@implementation MoreWaysViewController
@synthesize shopLabel, petitionLabel, articleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"More Ways";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}

-(IBAction)visitARS:(id)sender{
        
    NSString* launchUrl = @"http://theanimalrescuesite.greatergood.com/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // shop
    int x = 10; // nice border padding left for ads (300 width)
    int y = 78 + 50;
    int label_height = 45;
    int ad_height = 100;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;

    GADAdSize customAdSize = GADAdSizeFromCGSize(CGSizeMake(300, ad_height));

    bannerViewShop_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewShop_.adUnitID = @"/91636279/shop_ad_300x100";
    bannerViewShop_.rootViewController = self;
    [self.view addSubview:bannerViewShop_];
    [bannerViewShop_ loadRequest:[GADRequest request]];
    y += ad_height;
    shopLabel.frame = CGRectMake(x, y, screenWidth, label_height);

    // petition
    y += label_height;
    bannerViewPetition_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewPetition_.adUnitID = @"/91636279/petition_300x100";
    bannerViewPetition_.rootViewController = self;
    [self.view addSubview:bannerViewPetition_];
    [bannerViewPetition_ loadRequest:[GADRequest request]];
    y += ad_height;
    petitionLabel.frame = CGRectMake(x, y, screenWidth, label_height);

    // article
    y += label_height;
    bannerViewArticle_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewArticle_.adUnitID = @"/91636279/articles_300x100";
    bannerViewArticle_.rootViewController = self;
    [self.view addSubview:bannerViewArticle_];
    [bannerViewArticle_ loadRequest:[GADRequest request]];
    y += ad_height;
    articleLabel.frame = CGRectMake(x, y, screenWidth, label_height);


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
