//
//  displayLargeViewController.m
//  displayLarge
//
//  Created by Pei Shi Yong on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "displayLargeViewController.h"

@interface displayLargeViewController () <UITextFieldDelegate>

@end

@implementation displayLargeViewController{
    UIScrollView *_scrollView;
    UITextField *_textField;
}

- (void)loadView
{
    CGRect viewFrame = self.navigationController.view.frame;
    UIView *view = [[UIView alloc] initWithFrame:viewFrame];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat landscapeScreenWidth = screenRect.size.height;
    CGFloat landscapeScreenHeight = screenRect.size.width;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, landscapeScreenWidth, landscapeScreenHeight)];
    _scrollView.backgroundColor = [UIColor yellowColor];
    
    CGFloat marginSide = 25;
    CGFloat marginTop = 90;
    CGFloat textFieldWidth = landscapeScreenWidth - (2*marginSide);
    CGFloat textFieldHeight = 110;
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(marginSide, 
                                                              marginTop, 
                                                              textFieldWidth, 
                                                              textFieldHeight
                                                              )];
    _textField.clearsOnBeginEditing = YES;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.backgroundColor = [UIColor lightGrayColor];
    _textField.minimumFontSize = 10;
    _textField.font = [UIFont systemFontOfSize:100];
    _textField.adjustsFontSizeToFitWidth = YES;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.textAlignment = UITextAlignmentCenter;
    _textField.delegate = self;
    
    [_scrollView addSubview:_textField];
    [view addSubview:_scrollView];
    
    self.view = view;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat landscapeKeyboardHeight = kbSize.width;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, landscapeKeyboardHeight);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect viewFrame = self.view.frame;
    CGRect landscapeViewFrameWithKeyboard = CGRectMake(viewFrame.origin.y,
                                           viewFrame.origin.x,
                                           viewFrame.size.height,
                                           viewFrame.size.width-landscapeKeyboardHeight);

    CGFloat textFieldLowerLeftY = _textField.frame.origin.y+_textField.frame.size.height;
    CGFloat textFieldMarginBottom = 35;

    CGPoint lowerLeftPointToBeShown = CGPointMake(_textField.frame.origin.x,
                                       textFieldLowerLeftY + textFieldMarginBottom);

    BOOL shouldScroll = !CGRectContainsPoint(landscapeViewFrameWithKeyboard, lowerLeftPointToBeShown);

    if (shouldScroll) {
        CGPoint scrollPoint = CGPointMake(0.0,
                                          lowerLeftPointToBeShown.y - landscapeKeyboardHeight);
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}

@end
