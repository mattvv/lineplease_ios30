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
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (IBAction)loginTapped:(id)sender {
    [SVProgressHUD showWithStatus:@"Logging in"];
    [self.user logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Success"];
            [self performSegueWithIdentifier:@"LoggedIn" sender:self];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Invalid Credentials"];
            UIAlertView *alert = [self.alertProvider alertViewWithTitle:@"Cannot Login" message:@"Invalid Credentials."];
            [alert show];
        }
    }];
}

@end
