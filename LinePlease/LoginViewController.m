//
//  ViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    //todo: figure out how to mock class methods
    self.user = [User object];
    self.alertProvider = [[AlertViewProvider alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([User currentUser]) {
        //we have a current user so lets move on
        [self performSegueWithIdentifier:@"Scripts" sender:self];
    }
    [super viewWillAppear:animated];
}

- (IBAction)loginTapped:(id)sender {
    NSArray *permissions = nil;
    [SVProgressHUD show];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            NSLog(@"Error is %@", [error localizedDescription]);
            [SVProgressHUD showErrorWithStatus:@"Facebook login failed."];
        } else {
            [SVProgressHUD dismiss];
            [self performSegueWithIdentifier:@"Scripts" sender:self];
            NSLog(@"User logged in through Facebook!");
        }
    }];
}

@end
