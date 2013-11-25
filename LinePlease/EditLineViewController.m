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
        
    } else {
        self.title = @"Create Line";
        self.lineText.placeholder = @"Enter your line";
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
//    /* if the file has been recorded, delete the existing local copy */
//    
//    NSString *documentDirectory = NSTemporaryDirectory();
//    NSString *path = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", self.line.objectId]];
//    
//    //delete file if exists
//    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
//        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
//    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    NSError *err = nil;
//    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
//    if(err)
//        return;
//    
//    [audioSession setActive:YES error:&err];
//    if(err)
//        return;
//    
//    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//    [recordSetting setValue:[NSNumber numberWithFloat:32000.0] forKey:AVSampleRateKey];
//    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
//    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
//    
//    NSURL *url = [NSURL fileURLWithPath:path];
//    err = nil;
//    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
//    if(!self.recorder){
//        return;
//    }
//    
//    
//    //prepare to record
//    [self.recorder setDelegate:self];
//    [self.recorder prepareToRecord];
//    self.recorder.meteringEnabled = YES;
//    
//    BOOL audioHWAvailable = audioSession.inputAvailable;
//    if (!audioHWAvailable) {
//        return;
//    }
//    
//    [self.recorder recordForDuration:(NSTimeInterval) 1000];
    
    [self.recordingView setHidden:NO];
}

- (IBAction)stop:(id)sender {
//    [self.recorder stop];
    [self.recordingView setHidden:YES];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    [self saveRecording];
}

- (void) saveRecording {
//    NSLog(@"Saving recording");
//    NSString *documentDirectory = NSTemporaryDirectory();
//    NSString *path = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", lineObject.objectId]];
//    [recordingView.cancelButton setHidden:YES];
//    [recordingView.loadingLabel setText:@"Saving..."];
//    
//    
//    NSLog(@"getting data from file");
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    PFFile *file = [PFFile fileWithName:@"resume.mp3" data:data];
//    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        NSLog(@"getting data from file");
//        if (!error) {
//            NSLog(@"associating");
//            [lineObject setObject:file forKey:@"recordingFile"];
//            NSLog(@"Set Object");
//            [lineObject setObject:@"yes" forKey:@"recorded"];
//            NSLog(@"Set Recorded");
//            [lineObject saveInBackgroundWithBlock:^(BOOL success, NSError *errNope) {
//                NSLog(@"associated");
//                [recordingView hideLoadingView:self.view];
//                [lineObject refresh];
//                [play setEnabled:YES];
//                [remove setEnabled:YES];
//            }];
//        } else {
//            [recordingView hideLoadingView:self.view];
//        }
//    }];
//
}


#pragma mark - Playing



@end
