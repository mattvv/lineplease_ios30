//
//  EditLineViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/24/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"
#import "Script.h"
#import "SZTextView.h"
#import "HTAutocompleteTextField.h"

@interface EditLineViewController : UIViewController

@property (nonatomic, strong) Script *script;
@property (nonatomic, strong) Line *line;
@property (nonatomic, strong) NSArray *characters;

@property (nonatomic, strong) IBOutlet HTAutocompleteTextField *characterText;
@property (nonatomic, strong) IBOutlet SZTextView *lineText;

@property (nonatomic, strong) IBOutlet UISegmentedControl *gender;
@property (nonatomic, strong) IBOutlet UIButton *recordingButton;

- (IBAction) saveLine: (id)sender;

@end
