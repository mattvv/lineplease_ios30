//
//  AddScriptViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/23/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddScriptViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *scriptName;

- (IBAction)openMenu:(id)sender;
- (IBAction)create:(id)sender;
@end
