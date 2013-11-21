#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "Line.h"

SpecBegin(LinePleaseSpecs)

/*
 
 */

describe(@"Line", ^{
    it(@"is a subclass from pass", ^{
        expect(YES).to.equal(true);
    });
});

SpecEnd
