//
//  EmailLoginViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/21/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewProvider.h"
#import "HTEmailAutocompleteTextField.h"

@interface EmailLoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet HTEmailAutocompleteTextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) AlertViewProvider *alertProvider;

- (IBAction)loginTapped:(id)sender;
- (IBAction)cancel:(id)sender;

@end
