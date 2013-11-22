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
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signupTapped:(id)sender {
    //todo:
}


@end
