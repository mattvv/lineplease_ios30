//
//  AddScriptViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/23/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "AddScriptViewController.h"
#import "LPNavigationController.h"

@interface AddScriptViewController ()

@end

@implementation AddScriptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)openMenu:(id)sender {
    LPNavigationController *nav = (LPNavigationController *)self.navigationController;
    [nav toggleMenu];
}



@end
