//
//  Line.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 10/3/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "Line.h"
#import <Parse/PFObject+Subclass.h>

@implementation Line

+ (NSString *)parseClassName {
    return @"Line";
}

- (NSString *)cleanCharacter {
    return [[self[@"character"] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL)isMale {
    return [self[@"gender"] isEqualToString:@"male"];
}

- (double) calculateSilence {
    NSScanner *scanner = [NSScanner scannerWithString:self[@"line"]];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSCharacterSet *nonWhitespace = [whiteSpace invertedSet];
    float count = 0;
    
    while(![scanner isAtEnd])
    {
        [scanner scanUpToCharactersFromSet:nonWhitespace intoString:nil];
        [scanner scanUpToCharactersFromSet:whiteSpace intoString:nil];
        count++;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults floatForKey:@"silenceSpeed"]) {
        [userDefaults setFloat:0.5 forKey:@"silenceSpeed"];
    }
    
    
    count = count * 520 / 1000 * 2 * [userDefaults floatForKey:@"silenceSpeed"];
    //todo: silence time.
    
    NSLog(@"Silence Time is %f", count);
    return count; //to miliseconds
}
@end
