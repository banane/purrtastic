//
//  ViewController.m
//  PetToGive
//
//  Created by Anna Billstrom on 3/13/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize petHand, panRecognizer, petPhoto;

-(void)petAction{
    NSLog(@"pet action");
    petHand.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	panRecognizer = [[UIPanGestureRecognizer alloc]
                       initWithTarget:self action:@selector(petAction)];
    [petPhoto addGestureRecognizer:panRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
