#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"
#import "LoginViewController.h"
#import "ScriptViewController.h"

SpecBegin(LoginViewControllerSpec)

describe(@"LoginViewController", ^{
    __block LoginViewController *_lvc;
    
    beforeEach(^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UINavigationController *nav = [mainStoryboard instantiateInitialViewController];
        _lvc = (LoginViewController *)[nav visibleViewController];
        
        UIView *view = _lvc.view;
        expect(view).toNot.beNil();
    });
    
    it(@"should be instantiated from the storyboard", ^{
        expect(_lvc).toNot.beNil();
        expect(_lvc).to.beInstanceOf([LoginViewController class]);
    });
    
    it(@"should have an outlet for the username field", ^{
        expect(_lvc.usernameTextField).toNot.beNil();
    });
    
    it(@"should have an outlet for the password field", ^{
        expect(_lvc.passwordTextField).toNot.beNil();
    });
    
    it(@"should have wire up the login button action", ^{
        UIButton *button = _lvc.loginButton;
        NSArray *actions = [button actionsForTarget:_lvc forControlEvent:UIControlEventTouchUpInside];
        expect(actions[0]).to.equal(@"loginTapped:");
    });
    
    describe(@"logging in", ^{
        __block id _mockUser;
        
        beforeEach(^{
            _mockUser = [OCMockObject mockForClass:[User class]];
            _lvc.user = _mockUser;
        });
        
        afterEach(^{
            [_mockUser verify];
        });
        
        it(@"should verify username & password with parse", ^{
            [[_mockUser expect] logInWithUsernameInBackground:@"user1"
                                       password:@"password1"
                                          block:[OCMArg any]];

            
            
            _lvc.usernameTextField.text = @"user1";
            _lvc.passwordTextField.text = @"password1";
            
            //act
            [_lvc loginTapped:nil];
        });
        
        context(@"with invalid credentials", ^{
            __block id _alertProvider;
            
            beforeEach(^{
                _alertProvider = [OCMockObject mockForClass:[AlertViewProvider class]];
                _lvc.alertProvider = _alertProvider;
                
                [[_mockUser stub] logInWithUsernameInBackground:[OCMArg any]
                                                       password:[OCMArg any]
                                                          block:[OCMArg checkWithBlock:^BOOL(PFUserResultBlock block) {
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:@"Invalid Credentials" forKey:NSLocalizedDescriptionKey];
                    NSError *error = [NSError errorWithDomain:@"Error" code:200 userInfo:details];
                    block(nil, error);
                    return YES;
                }]];
            });
            
            it(@"should show an alert ", ^{
                id mockAlert = [OCMockObject mockForClass: [UIAlertView class]];
                [[[_alertProvider expect] andReturn: mockAlert] alertViewWithTitle:[OCMArg any]
                                                    message:[OCMArg any]];
                [[mockAlert expect] show];
                
                [_lvc loginTapped:nil];
                [_alertProvider verify];
                [mockAlert verify];
            });
        });
        
        context(@"valid credentials", ^{
            beforeEach(^{
                [[_mockUser stub] logInWithUsernameInBackground:[OCMArg any]
                                                       password:[OCMArg any]
                                                          block:[OCMArg checkWithBlock:^BOOL(PFUserResultBlock block) {
                    block(_mockUser, nil);
                    return YES;
                }]];
            });
            
            it(@"should push the script view controller", ^{
                [_lvc loginTapped:nil];
                
                expect(_lvc.navigationController.visibleViewController).to.beInstanceOf([ScriptViewController class]);
            });

        });
    });
});

SpecEnd