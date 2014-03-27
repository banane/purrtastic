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
        self.title = @"More Ways To Help";
           }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
     UIColor *lavender = [self renderColor:253 green:244 blue:255];
    [self.navigationController.navigationBar setBarTintColor:lavender];

}

-(IBAction)visitARS:(id)sender{
        
    NSString* launchUrl = @"http://theanimalrescuesite.greatergood.com/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO: add font to roboto
    // color background of labels are same lavendar
    // navbar font color is dark purple (same as label)
    // try to change back button colors too
    
    // shop
    int x = 10; // nice border padding left for ads (300 width)
    int y = 78 + 50;
//    int label_height = 45;
    int label_height = 24;
    int ad_height = 100;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;

    GADAdSize customAdSize = GADAdSizeFromCGSize(CGSizeMake(300, ad_height));

    shopLabel.frame = CGRectMake(x, y, screenWidth, label_height);
    y += label_height;
    bannerViewShop_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewShop_.adUnitID = @"/91636279/shop_ad_300x100";
    bannerViewShop_.rootViewController = self;
    [self.view addSubview:bannerViewShop_];
    [bannerViewShop_ loadRequest:[GADRequest request]];

    // petition
    y += ad_height;
    petitionLabel.frame = CGRectMake(x, y, screenWidth, label_height);
    y += label_height;
    bannerViewPetition_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewPetition_.adUnitID = @"/91636279/petition_300x100";
    bannerViewPetition_.rootViewController = self;
    [self.view addSubview:bannerViewPetition_];
    [bannerViewPetition_ loadRequest:[GADRequest request]];

    // article
    y += ad_height;
    articleLabel.frame = CGRectMake(x, y, screenWidth, label_height);
    y += label_height;
    bannerViewArticle_ = [[GADBannerView alloc] initWithAdSize:customAdSize origin:CGPointMake(x, y)];
    bannerViewArticle_.adUnitID = @"/91636279/articles_300x100";
    bannerViewArticle_.rootViewController = self;
    [self.view addSubview:bannerViewArticle_];
    [bannerViewArticle_ loadRequest:[GADRequest request]];
    


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIColor *)renderColor:(int)red green:(int)green blue:(int)blue{
    return [UIColor colorWithRed:((float)red/255.0f) green:((float)green/255.0f) blue:((float)blue/255.0f) alpha:1.0f];
}


@end
