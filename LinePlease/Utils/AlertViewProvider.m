//
//  AlertViewProvider.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "AlertViewProvider.h"

@implementation AlertViewProvider

- (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message {
    return [[UIAlertView alloc] initWithTitle:title
                                      message:message
                                     delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];
}
@end
