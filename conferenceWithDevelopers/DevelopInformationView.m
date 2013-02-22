//
//  DevelopInformationView.m
//  conferenceWithDevelopers
//
//  Created by Matsuki Hidenori on 12/08/25.
//  Copyright (c) 2012年 Matsuki Hidenori. All rights reserved.
//

#import "DevelopInformationView.h"
#import <QuartzCore/QuartzCore.h>
#import <mach/mach.h>

static NSString * const MemoryLabelFormat = @"memory > %u KiB";
static NSString * const LogLabelText =  @"log >";
static NSString * const LogTextFormat = @"[%@] %@";

@interface LogTextView : UITextView
@end
@implementation LogTextView
- (BOOL)canBecomeFirstResponder { return NO; }
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(receiveLog:)
                                                    name:CONSOLE_LOG_NOTIFICATION_KEY
                                                  object:nil];
    }
    return self;
}
- (void)receiveLog:(NSNotification *)n
{
    NSString *log = nil;
    if ([n.object isKindOfClass:[NSString class]])
        log = [NSString stringWithFormat:LogTextFormat, [NSDate date], n.object];
    if (!log || !log.length) return;
    if (!self.text.length) {
        self.text = log;
    } else {
        self.text = [NSString stringWithFormat:@"%@\n%@", self.text, log];
    }
    [self scrollRangeToVisible:NSMakeRange(self.text.length - 1, 1)];
}
@end

@interface DevelopInformationView ()
@property (strong, nonatomic, readonly) UILabel *memoryLabel;
@property (strong, nonatomic, readonly) UITextView *logTextView;
@end

@implementation DevelopInformationView
@synthesize memoryLabel = _memoryLabel;
@synthesize logTextView = _logTextView;

- (id)init
{
    self = [super initWithFrame:(CGRect){{20.0f, 120.0f}, {280.0f, 320.0f}}];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
        self.layer.cornerRadius = 8.0f;
        CGPoint nextPoint = {8.0f, 8.0f};
        // init memory label
        _memoryLabel = [[UILabel alloc]initWithFrame:(CGRect){nextPoint, CGSizeZero}];
        _memoryLabel.backgroundColor = [UIColor clearColor];
        _memoryLabel.textColor = [UIColor greenColor];
        _memoryLabel.text = MemoryLabelFormat;
        [_memoryLabel sizeToFit];
        nextPoint.y += _memoryLabel.frame.size.height;
        [self addSubview:_memoryLabel];
        // init log label
        {
            CGSize size = self.frame.size;
            size.width -= nextPoint.x * 2;
            UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){nextPoint, CGSizeZero}];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor greenColor];
            label.text = LogLabelText;
            [label sizeToFit];
            nextPoint.y += label.frame.size.height;
            [self addSubview:label];
        }
        // init log text view
        {
            CGSize size = self.frame.size;
            size.width -= nextPoint.x * 2;
            size.height -= nextPoint.y + 8.0f;
            _logTextView = [[LogTextView alloc]initWithFrame:(CGRect){nextPoint, size}];
            _logTextView.backgroundColor = [UIColor clearColor];
            _logTextView.textColor = [UIColor greenColor];
            NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Courier New"]);
            NSLog(@"font: %@", [UIFont fontWithName:@"CourierNewPSMT" size:12]);
            NSLog(@"font: %@", _logTextView.font);
            _logTextView.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:12];
            [self addSubview:_logTextView];
        }
        // init timer
        queue = dispatch_queue_create("QueueMemoryInformationTimer", DISPATCH_QUEUE_SERIAL);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_event_handler(timer, ^{
            [self updateMemoryInformation];
        });
        dispatch_source_set_cancel_handler(timer, ^{
            NSLog(@"cancelled");
        });
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1);
        uint64_t interval = NSEC_PER_SEC / 5;
        uint64_t leeway = 0;
        dispatch_source_set_timer(timer, start, interval, leeway);
        self.hidden = NO;
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

#pragma mark - ui events

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *v = [super hitTest:point withEvent:event];
    if (v != self.logTextView) {
        return nil;
    }
    return v;
}

#pragma mark -

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if ([self isHidden]) {
        dispatch_suspend(timer);
    } else {
        dispatch_resume(timer);
    }
}

#pragma mark - memory information

- (void)updateMemoryInformation
{
    struct task_basic_info basic_info = {0};
    mach_msg_type_number_t task_info_count = TASK_BASIC_INFO_COUNT;
    errno = 0;
    if (task_info(current_task(), TASK_BASIC_INFO, (task_info_t)&basic_info, &task_info_count)) {
        NSLog(@"Err:%s", strerror(errno));
    }
    vm_size_t rss = basic_info.resident_size;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.memoryLabel.text = [NSString stringWithFormat:MemoryLabelFormat, rss / 1024];
        [self.memoryLabel sizeToFit];
    });
}

@end
