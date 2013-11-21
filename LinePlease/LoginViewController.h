//
//  ViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "AlertViewProvider.h"

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) AlertViewProvider *alertProvider;

- (IBAction)loginTapped:(id)sender;

@end
