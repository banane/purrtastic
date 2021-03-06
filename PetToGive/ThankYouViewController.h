//
//  ThankYouViewController.h
//  PetToGive
//
//  Created by Anna Billstrom on 3/18/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GAITrackedViewController.h"

@interface ThankYouViewController : GAITrackedViewController{
     GADBannerView *bannerView_;
    IBOutlet UILabel *thankYouHead;
    IBOutlet UILabel *yourPetCounted;
    IBOutlet UILabel *conversionPet;
    IBOutlet UILabel *conversionTotal;
    IBOutlet UILabel *petAgainTime;
    IBOutlet UIButton *moreWaysButton;
    IBOutlet UIButton *petAgainButton;
    NSTimer *timer;
}

@property (nonatomic, strong) IBOutlet UILabel *thankYouHead;
@property (nonatomic, strong) IBOutlet UILabel *yourPetCounted;
@property (nonatomic, strong) IBOutlet UILabel *conversionPet;
@property (nonatomic, strong) IBOutlet UILabel *conversionTotal;
@property (nonatomic, strong) IBOutlet UILabel *petAgainTime;
@property (nonatomic, strong) IBOutlet UIButton *moreWaysButton;
@property (nonatomic, strong) IBOutlet UIButton *petAgainButton;


-(IBAction)viewMoreWaysVC:(id)sender;
-(void)setupCountButton;
-(void)updateViewToWaitingForPetAction;

@end
