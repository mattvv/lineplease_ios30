//
//  ViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewProvider.h"

@interface LoginViewController : UIViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) AlertViewProvider *alertProvider;

- (IBAction)loginTapped:(id)sender;

@end
