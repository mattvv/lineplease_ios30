//
//  Speaker.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/24/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Line.h"

@protocol SpeakerDelegate

- (void)highlightLine: (Line *)line silent: (BOOL) silent;
- (void)finishedSpeaking;

@end


@interface Speaker : NSObject<AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate>

@property (nonatomic, retain) AVSpeechSynthesizer *speaker;
@property (nonatomic, strong) id <SpeakerDelegate> delegate;
@property (nonatomic, strong) AVAudioPlayer *player;

- (void) startSpeaking:(NSArray *)chosenLines withCharacter:(NSString *)chosenCharacter;
- (void) pauseSpeaking;
- (void) unpauseSpeaking;
- (void) stopSpeaking;

@end
