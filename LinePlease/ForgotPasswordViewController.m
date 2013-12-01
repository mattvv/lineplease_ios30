//
//  ForgotPasswordViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 12/1/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "StyleHelper.h"
#import "HTAutocompleteManager.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [StyleHelper styleMyUITextField:self.emailText];
    self.emailText.autocompleteDataSource = [HTAutocompleteManager sharedManager];
    self.emailText.autocompleteType = HTAutocompleteTypeEmail;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)resetPassword:(id)sender {
    if ([self.emailText.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please enter your Email/Username"];
        return;
    }
    
    [SVProgressHUD show];
    [PFUser requestPasswordResetForEmailInBackground:self.emailText.text];
    [SVProgressHUD showSuccessWithStatus:@"Please check your e-mail"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
