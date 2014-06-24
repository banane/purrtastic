//
//  SettingsTableViewController.m
//  PetToGive
//
//  Created by Anna Billstrom on 6/23/14.
//  Copyright (c) 2014 Anna Billstrom. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppDelegate.h"
#import "AnimalChoiceTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    self.title = @"Your Pet Photos";
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:NO];
    [self.tableView reloadData];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Let me pet:";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    cell.textLabel.text = [app.petChoices objectAtIndex:app.user.petChoice];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnimalChoiceTableViewController *actv = [[AnimalChoiceTableViewController alloc] initWithNibName:@"AnimalChoiceTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:actv animated:YES];
}

@end
