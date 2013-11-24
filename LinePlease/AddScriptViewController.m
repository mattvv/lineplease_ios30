//
//  AddScriptViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/23/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "AddScriptViewController.h"
#import "LPNavigationController.h"
#import "Script.h"
#import "StyleHelper.h"

@interface AddScriptViewController ()

@end

@implementation AddScriptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [StyleHelper styleMyUITextField:self.scriptName];
}

- (IBAction)openMenu:(id)sender {
    LPNavigationController *nav = (LPNavigationController *)self.navigationController;
    [nav toggleMenu];
}

- (IBAction)create:(id)sender {
    Script *script = [[Script alloc] init];
    script[@"name"] = self.scriptName.text;
    script[@"username"] = [User currentUser][@"username"];
    script[@"user"] = [User currentUser];
    
    [SVProgressHUD showWithStatus:@"Saving"];
    [script saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"Created Script"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Could not create Script"];
        }
    }];
    
}



@end
