//
//  SettingsViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/23/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "SettingsViewController.h"
#import "LPNavigationController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults floatForKey:@"playbackSpeed"]) {
        [userDefaults setFloat:0.15 forKey:@"playbackSpeed"];
    }
    self.playbackSpeedSlider.value = [userDefaults floatForKey:@"playbackSpeed"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (IBAction)openMenu:(id)sender {
    LPNavigationController *nav = (LPNavigationController *)self.navigationController;
    [nav toggleMenu];
}

- (IBAction)playbackSpeedChanged:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    float value = self.playbackSpeedSlider.value;
    [userDefaults setFloat:value forKey:@"playbackSpeed"];
    
}

- (IBAction)silenceSpeedChanged:(id)sender {
    
}

@end
