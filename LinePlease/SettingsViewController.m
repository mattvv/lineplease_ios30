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
    
    if (![userDefaults floatForKey:@"pauseAmount"]) {
        [userDefaults setFloat:0.15 forKey:@"pauseAmount"];
    }
    
    if (![userDefaults floatForKey:@"silenceSpeed"]) {
        [userDefaults setFloat:0.5 forKey:@"silenceSpeed"];
    }
    
    self.playbackSpeedSlider.value = [userDefaults floatForKey:@"playbackSpeed"];
    self.pauseTimeSlider.value = [userDefaults floatForKey:@"pauseAmount"];
    self.silenceSpeedSlider.value = [userDefaults floatForKey:@"silenceSpeed"];
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    float value = self.silenceSpeedSlider.value;
    [userDefaults setFloat:value forKey:@"silenceSpeed"];
}

- (IBAction)pauseTimeChanged:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    float value = self.pauseTimeSlider.value;
    [userDefaults setFloat:value forKey:@"pauseAmount"];
    
}

@end
