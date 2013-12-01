//
//  ForgotPasswordViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 12/1/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTEmailAutocompleteTextField.h"

@interface ForgotPasswordViewController : UIViewController

@property (nonatomic, strong) IBOutlet HTEmailAutocompleteTextField *emailText;

- (IBAction)resetPassword:(id)sender;
- (IBAction)cancel:(id)sender;

@end
