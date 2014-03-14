//
//  ViewController.h
//  PetToGive
//
//  Created by Anna Billstrom on 3/13/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UIImageView *petHand;
    UIPanGestureRecognizer *panRecognizer;
    IBOutlet UIImageView *petPhoto;

    
    
}

@property (nonatomic, strong) IBOutlet UIImageView *petHand;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) IBOutlet UIImageView *petPhoto;

- (void)petAction;

@end
