//
//  MoreWaysViewController.h
//  PetToGive
//
//  Created by Anna Billstrom on 3/18/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface MoreWaysViewController : UIViewController {
    GADBannerView *bannerViewShop_;
    GADBannerView *bannerViewPetition_;
    GADBannerView *bannerViewArticle_;
    IBOutlet UILabel *shopLabel;
    IBOutlet UILabel *petitionLabel;
    IBOutlet UILabel *articleLabel;
    UIColor *purple;
    UIColor *lavender;
    UIFont *boldRoboto17;
    NSShadow *shadow;
    IBOutlet UIButton *logo;
}

@property (nonatomic, strong) IBOutlet UILabel *shopLabel;
@property (nonatomic, strong) IBOutlet UILabel *petitionLabel;
@property (nonatomic, strong)  IBOutlet UILabel *articleLabel;
@property (nonatomic, strong) IBOutlet UIButton *logo;

-(IBAction)visitARS:(id)sender;


@end
