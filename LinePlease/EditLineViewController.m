//
//  EditLineViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/24/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "EditLineViewController.h"
#import "StyleHelper.h"
#import "HTAutocompleteManager.h"
#import "AMBlurView.h"

@interface EditLineViewController ()

@end

@implementation EditLineViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [StyleHelper styleMyUITextField:self.characterText];
    [StyleHelper styleMySZTextView:self.lineText];

    //todo: autocomplete helper with list of characters @ self.characters
    HTAutocompleteManager *htm = [HTAutocompleteManager sharedManager];
    htm.characters = self.characters;
    self.characterText.autocompleteType = HTAutocompleteTypeCharacter;
    self.characterText.autocompleteDataSource = htm;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    AMBlurView *blurView = [AMBlurView new];
    [blurView setFrame:self.recordingView.frame];
    [self.recordingView insertSubview:blurView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.line) {
        self.title = @"Edit Line";
        self.characterText.text = [self.line cleanCharacter];
        self.lineText.text = self.line[@"line"];
        if (self.line[@"gender"] != nil && [self.line[@"gender"] isEqualToString:@"male"]) {
            [self.gender setSelectedSegmentIndex:1];
        }
        if ([self.line[@"recorded"] isEqualToString:@"yes"]) {
            [self.recordingButton setTitle:@"Remove Recording" forState:UIControlStateNormal];
            self.playButton.hidden = NO;
        } else {
            [self.recordingButton setTitle:@"Record Line" forState:UIControlStateNormal];
            self.playButton.hidden = YES;
        }
        
    } else {
        self.title = @"Create Line";
        self.lineText.placeholder = @"Enter your line. Add .. to your line to add a pause.";
        self.line = [[Line alloc] init];
        self.line[@"scriptId"] = self.script.objectId;
    }
}

- (IBAction)saveLine:(id)sender {
    if ([self.characterText.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please enter a Character"];
        return;
    }
    
    if ([self.lineText.text length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please enter a Line"];
        return;
    }
    
    self.line[@"character"] = self.characterText.text;
    self.line[@"character"] = [self.line cleanCharacter];
    self.line[@"line"] = self.lineText.text;
    
    self.line[@"gender"] = self.gender.selectedSegmentIndex == 1 ? @"male" : @"female";

    [SVProgressHUD showWithStatus:@"Saving"];
    [self.line saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"Saved"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Could not save"];
        }
    }];
}

#pragma mark - Recording 
- (IBAction)record:(id)sender {
    if ([self.line[@"recorded"] isEqualToString:@"yes"]) {
        self.line[@"recorded"] = @"no";
        [self.recordingButton setTitle:@"Record Line" forState:UIControlStateNormal];
        self.playButton.hidden = YES;
        [SVProgressHUD showSuccessWithStatus:@"Recording Deleted"];
        return;
    }
    
    /* if the file has been recorded, delete the existing local copy */
    
    NSString *documentDirectory = NSTemporaryDirectory();
    NSString *path = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", self.line.objectId]];
    
    //delete file if exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err)
        return;
    
    [audioSession setActive:YES error:&err];
    if(err)
        return;
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:32000.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    err = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!self.recorder){
        return;
    }
    
    
    //prepare to record
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputAvailable;
    if (!audioHWAvailable) {
        return;
    }
    
    [self.recorder recordForDuration:(NSTimeInterval) 1000];
    self.whileRecordingButton.enabled = YES;
    [self.whileRecordingButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
    [self.recordingView setHidden:NO];
}

- (IBAction)stop:(id)sender {
    [self.recorder stop];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    [self saveRecording];
}

- (void) saveRecording {
    NSString *documentDirectory = NSTemporaryDirectory();
    NSString *path = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", self.line.objectId]];
    
    self.whileRecordingButton.hidden = YES;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    PFFile *file = [PFFile fileWithName:@"resume.mp3" data:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.whileRecordingButton.hidden = NO;
        [self.recordingView setHidden:YES];
        if (!error) {
            [self.line setObject:file forKey:@"recordingFile"];
            [self.line setObject:@"yes" forKey:@"recorded"];
            [self.recordingButton setTitle:@"Remove Recording" forState:UIControlStateNormal];
            self.playButton.hidden = NO;
        } else {
            [SVProgressHUD showErrorWithStatus:@"Could not save Recording"];
        }
    }];

}

#pragma mark - Playing

- (IBAction)play:(id)sender {
    self.whileRecordingButton.hidden = YES;
    self.recordingView.hidden = NO;

    NSString *documentDirectory = NSTemporaryDirectory();
    NSString *path = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", self.line.objectId]];
    
    NSData *recordingData;
    
    //play cached file if exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        recordingData = [NSData dataWithContentsOfFile:path];
    } else {
        PFFile *recording = [self.line objectForKey:@"recordingFile"];
        recordingData = [recording getData];
    }
    
    // set to output to speaker
//    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    /* play the file */
    
    NSError *err;
    
    self.player = [[AVAudioPlayer alloc] initWithData:recordingData error: &err];
    if (err)
        NSLog(@"Error %@", err.localizedDescription);
    self.player.numberOfLoops = 0;
    self.player.delegate = self;
    
    [self.player prepareToPlay];
    [self.player play];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"Decode Error occurred %@", error.localizedDescription);
    [SVProgressHUD showErrorWithStatus:@"Could not play line"];
    self.recordingView.hidden = YES;
    self.whileRecordingButton.hidden = NO;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)xplayer successfully:(BOOL)flag {
    NSLog(@"Finished Playing Audio");
    self.recordingView.hidden = YES;
    self.whileRecordingButton.hidden = NO;
}


@end
