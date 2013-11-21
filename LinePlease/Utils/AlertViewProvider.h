//
//  AlertViewProvider.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertViewProvider : NSObject

- (UIAlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message;

@end
