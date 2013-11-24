//
//  Speaker.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/24/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "Speaker.h"

@interface Speaker () {
    BOOL paused;
    NSMutableArray *lines;
    NSString *character;
    Line *currentLine;
    BOOL playingSynth;
    BOOL playingAudio;
}
@end

@implementation Speaker

- (id) init {
    if (self = [super init]) {
        self.speaker = [[AVSpeechSynthesizer alloc] init];
        [self.speaker setDelegate:self];
        paused = NO;
    }
    return self;
}

#pragma mark - types of speaking
- (void)recordedLine:(Line*) line {
    //nslog todo:
}

- (void)synthLine:(Line*) line {
    NSLog(@"Speaking %@", line[@"line"]);
    //setup male or female voice.
    
    AVSpeechUtterance *words = [AVSpeechUtterance speechUtteranceWithString:line[@"line"]];
    
    if ([line isMale]) {
        words.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-gb"];
    }
    
    @synchronized(self) {
        playingSynth = YES;
        [self.speaker speakUtterance:words];
    }
}

- (void)playLine:(Line *) line {
    if ([[line cleanCharacter] isEqualToString:character]) {
        [self.delegate highlightLine:line silent:YES];
    } else {
        [self.delegate highlightLine:line silent:NO];
    }
    
    //todo: work out silence, synth line, etc.
    [self synthLine:line];
}


- (void)playNextLine {
    if (paused)
        return;
    
    if ([lines count] > 0) {
        currentLine = lines[0];
        [lines removeObject:currentLine];
        [self playLine:currentLine];
    } else {
        lines = nil;
        character = nil;
        currentLine = nil;
        [self.delegate finishedSpeaking];
    }
    
}
#pragma mark - delegates for AVSpeechSynth

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    @synchronized(self) {
        playingSynth = NO;
        
        if (!paused) {
            [self playNextLine];
        }
    }
}


#pragma mark - control methods
- (void) pauseSpeaking {
    @synchronized(self) {
        if (playingSynth)
            [self.speaker pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        
        paused = YES;
    }
}

- (void) unpauseSpeaking {
    @synchronized(self) {
        paused = NO;
        if (playingSynth) {
            [self.speaker continueSpeaking];
        } else if (playingAudio) {
            //todo: playing audio resume
        } else {
            [self playNextLine];
        }
    }
}

- (void) stopSpeaking {
    [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    
    lines = nil;
    character = nil;
    currentLine = nil;
    [self.delegate finishedSpeaking];
}

- (void) startSpeaking:(NSArray *)chosenLines withCharacter:(NSString *)chosenCharacter {
    lines = [NSMutableArray arrayWithArray:chosenLines];
    character = chosenCharacter;
    [self playNextLine];
}

@end
