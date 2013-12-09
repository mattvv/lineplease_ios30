//
//  LineCell.m
//  LinePlease
//
//  Created by Matt Van Veenendaal on 12/8/13.
//  Copyright (c) 2013 lineplease. All rights reserved.
//

#import "LineCell.h"

@interface LineCell () {
    NSTimer *timer;
    int counter;
    BOOL prompted;
    BOOL animated;
    NSString *oldText;
}
@end

@implementation LineCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        counter = 0;
        oldText = nil;
        animated = NO;
        prompted = NO;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(incrementCounter) userInfo:nil repeats:YES];
        animated = false;
        oldText = self.textLabel.text;
    };
    
    if (!prompted) {
        prompted = YES;
        [UIView animateWithDuration:0.5f animations:^{
            self.layer.backgroundColor = [UIColor redColor].CGColor;
            self.textLabel.textColor = [UIColor whiteColor];
            self.textLabel.text = @"Hold until it's green to Rehearse from this line!";
        }];
    }
    
    if ((counter > 2) && !animated) {
        animated = YES;
        [UIView animateWithDuration:0.5f animations:^{
            self.layer.backgroundColor = [UIColor greenColor].CGColor;
            self.textLabel.text = @"Release to Rehearse from this line!";
        }];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (animated) {
            //we got to the green, so let's call our delegate!
            [self.playDelegate playCellPressed:self];
        }
        
        [timer invalidate];
        [UIView animateWithDuration:0.3f animations:^{
            self.layer.backgroundColor = [UIColor clearColor].CGColor;
            self.textLabel.text = oldText;
            self.textLabel.textColor = [UIColor blackColor];
        }];
    }
}

- (void)incrementCounter {
    counter++;
}


@end
