//
//  LineViewController.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/4/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LineViewController : UIViewController<AVSpeechSynthesizerDelegate>

@property (nonatomic, retain) AVSpeechSynthesizer *speaker;

@end
