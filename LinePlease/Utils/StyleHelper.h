//
//  Style.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 11/21/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTextView.h"

@interface StyleHelper : NSObject

+ (void) styleMyUITextField: (UITextField *) textField;
+ (void) styleMySZTextView: (SZTextView *) textField;

@end
