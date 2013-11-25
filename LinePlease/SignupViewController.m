//
//  SignupViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/21/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "SignupViewController.h"
#import "StyleHelper.h"
#import "HTAutocompleteManager.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signupTapped:(id)sender {
    if ([self.emailTextField.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please enter your Email/Username"];
        return;
    }
    
    if ([self.passwordTextField.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please enter a Password"];
        return;
    }
    
    User *user = [[User alloc] init];
    user.email = self.emailTextField.text;
    user.username = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    [SVProgressHUD showWithStatus:@"Signing up"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"Success"];
            [self.navigationController popViewControllerAnimated:NO];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Error!"];
//            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
        }
    }];
}


@end
