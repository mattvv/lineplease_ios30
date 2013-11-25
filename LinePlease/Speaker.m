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
- (void)synthLine:(Line*) line {
    NSLog(@"Speaking %@", line[@"line"]);
    //setup male or female voice.
    
    AVSpeechUtterance *words = [AVSpeechUtterance speechUtteranceWithString:line[@"line"]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults floatForKey:@"playbackSpeed"]) {
        [userDefaults setFloat:0.15 forKey:@"playbackSpeed"];
    }
    
    words.rate = [userDefaults floatForKey:@"playbackSpeed"];
    
    if ([line isMale]) {
        words.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-gb"];
    }
    
    @synchronized(self) {
        playingSynth = YES;
        [self.speaker speakUtterance:words];
    }
}

- (void)speakSilence:(Line *)line {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, [line calculateSilence] * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self speechSynthesizer:self.speaker didFinishSpeechUtterance:nil];
    });
}

- (void)recordedLine:(Line *)line {
    NSString *documentDirectory = NSTemporaryDirectory();
    NSString *path = [documentDirectory stringByAppendingString:[NSString stringWithFormat:@"%@.wav", line.objectId]];
    NSData *recordingData;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NO]) {
        recordingData = [NSData dataWithContentsOfFile:path];
    } else {
        PFFile *recording = line[@"recordingFile"];
        recordingData = [recording getData];
    }
    
    /* play the file */
    
    NSError *err;
    
    self.player = [[AVAudioPlayer alloc] initWithData:recordingData error: &err];
    self.player.numberOfLoops = 0;
    self.player.delegate = self;
    
    
    @synchronized(self) {
        playingAudio = YES;
        [self.player prepareToPlay];
        [self.player play];
    }
}

- (void)playLine:(Line *) line {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults floatForKey:@"pauseAmount"]) {
        [userDefaults setFloat:0.15 forKey:@"pauseAmount"];
    }
    
    //only play the line after pause time.
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)([userDefaults floatForKey:@"pauseAmount"] * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([[line cleanCharacter] isEqualToString:character]) {
            [self.delegate highlightLine:line silent:YES];
            [self speakSilence:line];
        } else if ([line[@"recorded"] isEqualToString:@"yes"]) {
            [self.delegate highlightLine:line silent:NO];
            [self recordedLine:line];
        } else {
            [self.delegate highlightLine:line silent:NO];
            [self synthLine:line];
        }
    });
    
    
    //todo: play recorded lines
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

#pragma mark - delegates for AVAudioPlayer

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    @synchronized(self) {
        playingAudio = NO;
        
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
    @synchronized(self) {
        if (playingSynth)
            [self.speaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
        
        if (playingAudio)
            [self.player stop];
    }
    
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
