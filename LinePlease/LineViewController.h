//
//  LineViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/4/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Script.h"

@interface LineViewController : PFQueryTableViewController<AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) Script *script;
@property (nonatomic, retain) AVSpeechSynthesizer *speaker;

- (IBAction)openMenu:(id)sender;

@end
