//
//  FirstViewController.m
//  conferenceWithDevelopers
//
//  Created by MATSUKI Hidenori on 2/22/13.
//  Copyright (c) 2013 MATSUKI Hidenori. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()
@property (retain, nonatomic) IBOutlet UIButton *mallocButton;
@property (retain, nonatomic) IBOutlet UIButton *freeButton;
- (IBAction)nextButtonDidTouchUpInside:(id)sender;
- (IBAction)mallocButtonDidTouchUpInside:(id)sender;
- (IBAction)freeButtonDidTouchUpInside:(id)sender;
@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        allocates = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.freeButton.hidden = ![allocates count];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ui events

- (IBAction)nextButtonDidTouchUpInside:(id)sender {
    SecondViewController *nextViewController = [[SecondViewController alloc]initWithNibName:nil bundle:nil];
    [[self navigationController]pushViewController:nextViewController animated:YES];
}

- (IBAction)mallocButtonDidTouchUpInside:(id)sender {
    const size_t unit = 1024 * 1024;
    void *obj = malloc(unit);
    if (obj) {
        memset(obj, 'X', unit);
        [allocates addObject:[NSValue valueWithPointer:obj]];
        NSLog(@"allocated: %zu bytes", [allocates count] * unit);
        ConsoleLog(@"allocated: %zu bytes", [allocates count] * unit);
    }
    self.freeButton.hidden = ![allocates count];
}

- (IBAction)freeButtonDidTouchUpInside:(id)sender {
    NSValue *last = [allocates lastObject];
    if (last) {
        [allocates removeObject:last];
        free([last pointerValue]);
        NSLog(@"freed");
        ConsoleLog(@"freed");
    }
    self.freeButton.hidden = ![allocates count];
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
