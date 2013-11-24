//
//  LineViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/4/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Script.h"
#import "Speaker.h"

@interface LineViewController : PFQueryTableViewController<SpeakerDelegate>

@property (nonatomic, strong) Script *script;
@property (nonatomic, strong) Speaker *speaker;

- (IBAction)openMenu:(id)sender;

@end
