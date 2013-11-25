//
//  SettingsViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/23/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UISlider *playbackSpeedSlider;
@property (nonatomic, strong) IBOutlet UISlider *silenceSpeedSlider;
@property (nonatomic, strong) IBOutlet UISlider *pauseTimeSlider;

- (IBAction)openMenu:(id)sender;
- (IBAction)playbackSpeedChanged:(id)sender;
- (IBAction)silenceSpeedChanged:(id)sender;
- (IBAction)pauseTimeChanged:(id)sender;

@end
