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
        if(petCount == 3){
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
                       [NSNumber numberWithInteger:270],
                       [NSNumber numberWithInteger:100],
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
    
    [self ZigZag:heart];
    
}
- (void)fadeOpacity:(UIView *)heart{
    heart.alpha = heart.alpha - 0.15;
    [self ZigZag:heart];
}

- (UIView *)addHeart{
    int r = arc4random() % 10;          // random index for x starting point
    int x = [[heartXPositions objectAtIndex:r] intValue];
    UIImageView *heart=[[UIImageView alloc] initWithFrame:CGRectMake(x, 300, 40, 40)];
    int a = arc4random() % 5;   // random image stars and hearts combined, 0..5
    if(a <= 1){                 // do stars if 0,1- convert to 1,2 for names of images
        heart.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%d", a + 1]];
    } else {                    // all other indexes hearts, go down 1 to get image name right 1..4
        heart.image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d", (a - 1) ]];
    }
    [self.view addSubview:heart];
    heartCounter += 1;          // to set limit at some point
    
    
    return heart;
}


-(void)ZigZag:(UIView *)heart{
    toggle ^= 1;
    
    CGRect newFrame = heart.frame;
    if(toggle == 0){    // to go left or right
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
                         if(heart.frame.origin.y > -40){  // do until top of window
                             [self fadeOpacity:heart];
                         }
                     }
     ];
}


@end
