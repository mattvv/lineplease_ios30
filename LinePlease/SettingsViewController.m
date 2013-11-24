//
//  SettingsViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/23/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "SettingsViewController.h"
#import "LPNavigationController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)openMenu:(id)sender {
    LPNavigationController *nav = (LPNavigationController *)self.navigationController;
    [nav toggleMenu];
}

@end
