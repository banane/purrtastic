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

@synthesize petHand, panRecognizer, petPhoto, heartXPositions;

-(void)petAction{
    NSLog(@"pet action");
    petHand.hidden = YES;

    CGPoint translatedPoint = [(UIPanGestureRecognizer*)panRecognizer translationInView:petPhoto];
    NSLog(@"%f, %f", translatedPoint.x, translatedPoint.y);
    if(abs(translatedPoint.x) > 20 || abs(translatedPoint.y) > 20){
        if(petCount == 4){
            NSLog(@"valid pet");
            [self animateHearts];
            petCount = 0;
        } else {
            petCount += 1;
        }
    }
}

- (void)viewDidLoad
{
    petCount = 0;
    petHand.hidden = NO;
    heartCounter = 1;
    
    heartXPositions = [[NSArray alloc] initWithObjects:
                       [NSNumber numberWithInteger:150],
                       [NSNumber numberWithInteger:140],
                       [NSNumber numberWithInteger:210],
                       [NSNumber numberWithInteger:230],
                       [NSNumber numberWithInteger:190],
                       [NSNumber numberWithInteger:260],
                       [NSNumber numberWithInteger:200],
                       [NSNumber numberWithInteger:130], nil];

    [super viewDidLoad];
	panRecognizer = [[UIPanGestureRecognizer alloc]
                       initWithTarget:self action:@selector(petAction)];
    
    [petPhoto addGestureRecognizer:panRecognizer];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)animateHearts{
    UIView *heart = [self addHeart];
    
    NSLog(@"heart x: %f, heart y: %f", heart.frame.origin.x, heart.frame.origin.y);
    [self ZigZag:heart];
    NSLog(@"heart x: %f, heart y: %f", heart.frame.origin.x, heart.frame.origin.y);
    
    
}
- (void)fadeOpacity:(UIView *)heart{
    float targetAlpha = heart.alpha - 0.2;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{heart.alpha = targetAlpha;}
                     completion:^(BOOL finished){
                         [self ZigZag:heart];
                     }];
}

- (UIView *)addHeart{
    // create 1-8 hearts (later include stars)
    int x = [[heartXPositions objectAtIndex:(heartCounter-1)] intValue];
    UIImageView *heart=[[UIImageView alloc] initWithFrame:CGRectMake(x, 300, 40, 40)];
    heart.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d", heartCounter]];
    [self.view addSubview:heart];
    
    // reset heartcounter values
    if(heartCounter == 8){
        heartCounter = 1;
    } else {
        heartCounter += 1;
    }
    return heart;
}


-(void)ZigZag:(UIView *)heart{
    toggle ^= 1;
    
    CGRect newFrame = heart.frame;
    if(toggle == 0){
        newFrame.origin.x = heart.frame.origin.x - 50;
    } else {
        newFrame.origin.x = heart.frame.origin.x + 50;
    }
    newFrame.origin.y = heart.frame.origin.y - 50;
    
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         heart.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         if(heart.frame.origin.y > 0){  // do until top of window
                             [self fadeOpacity:heart];
                         }
                     }
     ];
}


@end
