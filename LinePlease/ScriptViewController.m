//
//  ScriptViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "ScriptViewController.h"

@interface ScriptViewController ()
@end

@implementation ScriptViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [User logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
