//
//  ProfileViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/23/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "ProfileViewController.h"
#import "LPNavigationController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (IBAction)openMenu:(id)sender {
    LPNavigationController *nav = (LPNavigationController *)self.navigationController;
    [nav toggleMenu];
}

- (IBAction)signOut:(id)sender {
    [User logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
