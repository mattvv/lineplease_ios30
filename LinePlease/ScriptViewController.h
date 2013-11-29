//
//  ScriptViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Script.h"

@interface ScriptViewController : PFQueryTableViewController

@property (nonatomic, strong) IBOutlet UIView *helpView;

- (IBAction)openMenu:(id)sender;

@end
