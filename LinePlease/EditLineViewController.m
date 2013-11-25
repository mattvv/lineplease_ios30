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

@end
