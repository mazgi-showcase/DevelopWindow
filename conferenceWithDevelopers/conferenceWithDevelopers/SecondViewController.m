//
//  SecondViewController.m
//  conferenceWithDevelopers
//
//  Created by MATSUKI Hidenori on 2/22/13.
//  Copyright (c) 2013 MATSUKI Hidenori. All rights reserved.
//

#import "SecondViewController.h"

#ifdef DEBUG
@interface UIView (Develop)
- (NSString *)recursiveDescription;
@end
#endif

@interface SecondViewController ()
- (IBAction)viewDumpButtonDidTouchUpInside:(id)sender;
- (IBAction)sendButtonDidTouchUpInside:(id)sender;
@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    ConsoleLog(@"%@", textField.text);
    [textField resignFirstResponder];
    textField.text = nil;
    return YES;
}

#pragma mark - ui events

- (IBAction)viewDumpButtonDidTouchUpInside:(id)sender {
#ifdef DEBUG
    ConsoleLog(@"\n%@", [sender subviews]);
#endif
}

- (IBAction)sendButtonDidTouchUpInside:(id)sender {
    ConsoleLog(@"\n"
               " _____ _                 _    \n"
               "|_   _| |__   __ _ _ __ | | __\n"
               "  | | | '_ \\ / _` | '_ \\| |/ /\n"
               "  | | | | | | (_| | | | |   < \n"
               "  |_| |_| |_|\\__,_|_| |_|_|\\_\\\n"
               "__   __            _ _ \n"
               "\\ \\ / /__  _   _  | | |\n"
               " \\ V / _ \\| | | | | | |\n"
               "  | | (_) | |_| | |_|_|\n"
               "  |_|\\___/ \\__,_| (_|_)\n"
               "                       \n"
               );
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%@#%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.nextResponder motionBegan:motion withEvent:event];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%@#%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.nextResponder motionEnded:motion withEvent:event];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%@#%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.nextResponder motionCancelled:motion withEvent:event];
}

@end
