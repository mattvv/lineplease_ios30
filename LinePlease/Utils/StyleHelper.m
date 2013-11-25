//
//  Style.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/21/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "StyleHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation StyleHelper


+ (void) styleMyUITextField: (UITextField *) textField {
    UIView *paddingView = [[UIView alloc] initWithFrame: CGRectMake(0,0,10,20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.borderColor = [[UIColor grayColor] CGColor];
    textField.layer.borderWidth = 0.5f;
}

+ (void) styleMySZTextView: (SZTextView *) textField {
//    UIView *paddingView = [[UIView alloc] initWithFrame: CGRectMake(0,0,10,20)];
//    textField.leftView = paddingView;
//    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.borderColor = [[UIColor grayColor] CGColor];
    textField.placeholderTextColor = [UIColor lightGrayColor];
    textField.layer.borderWidth = 0.5f;
    textField.contentInset = UIEdgeInsetsMake(0,20,0,0);
}

@end
