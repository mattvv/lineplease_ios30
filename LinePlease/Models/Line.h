//
//  Line.h
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Line : PFObject<PFSubclassing>

+ (NSString *)parseClassName;
- (NSString *)cleanCharacter;

@end
