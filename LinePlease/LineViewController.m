//
//  LineViewController.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/4/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "LineViewController.h"

@interface LineViewController ()

@end

@implementation LineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.speaker = [[AVSpeechSynthesizer alloc] init];
    [self.speaker setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)speakHelloWorld:(id)sender {
    NSLog(@"Speaking words");
    AVSpeechUtterance *words = [AVSpeechUtterance speechUtteranceWithString:@"Hello World! Testing new Line Please Voice"];
    [self.speaker speakUtterance:words];
}

@end
