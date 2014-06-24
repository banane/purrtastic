//
//  AnimalChoiceTableViewController.h
//  PetToGive
//
//  Created by Anna Billstrom on 6/23/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimalChoiceTableViewController : UITableViewController {
    NSArray *petChoices;
}

@property (nonatomic, strong) NSArray *petChoices;

@end
