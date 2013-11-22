//
//  EmailLoginViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/21/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "StyleHelper.h"
#import "HTAutocompleteManager.h"

@interface EmailLoginViewController ()

@end

@implementation EmailLoginViewController

- (void)viewDidLoad
{
    self.user = [User object];
    self.alertProvider = [[AlertViewProvider alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [StyleHelper styleMyUITextField:self.emailTextField];
    [StyleHelper styleMyUITextField:self.passwordTextField];
    self.emailTextField.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    self.emailTextField.autocompleteType = HTAutocompleteTypeEmail;
    [super viewDidLoad];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginTapped:(id)sender {
    [SVProgressHUD showWithStatus:@"Signing in"];
    [self.user logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Success"];
            [self.navigationController popViewControllerAnimated:NO];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Invalid Credentials"];
            UIAlertView *alert = [self.alertProvider alertViewWithTitle:@"Cannot Login" message:@"Invalid Credentials."];
            [alert show];
        }
    }];
}

@end
