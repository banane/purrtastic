//
//  AnimalChoiceTableViewController.m
//  PetToGive
//
//  Created by Anna Billstrom on 6/23/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "AnimalChoiceTableViewController.h"
#import "AppDelegate.h"

@interface AnimalChoiceTableViewController ()

@end

@implementation AnimalChoiceTableViewController
@synthesize petChoices;

- (void)viewDidLoad
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    petChoices = app.petChoices;
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0:
            return [petChoices count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(app.user.petChoice == [indexPath row]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [petChoices objectAtIndex:[indexPath row]];
    
    
    return cell;
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clearAllChecks];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.user.petChoice = [indexPath row];
    app.user.petChoiceString = [app.user getPetChoiceString:app.user.petChoice];
    NSLog(@"setting pet choice: %d", app.user.petChoice);
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
}

-(void)clearAllChecks{
    for (int row = 0, rowCount = [self.tableView numberOfRowsInSection:0]; row < rowCount; ++row) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
}


@end
