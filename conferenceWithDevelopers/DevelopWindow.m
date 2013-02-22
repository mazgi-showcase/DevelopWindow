//
//  DevelopWindow.m
//  conferenceWithDevelopers
//
//  Created by Matsuki Hidenori on 12/08/25.
//  Copyright (c) 2012年 Matsuki Hidenori. All rights reserved.
//

#import "DevelopWindow.h"
#import "DevelopInformationView.h"

@interface DevelopWindow ()
@property (retain, nonatomic, readonly) UIView *informationView;
@end

@implementation DevelopWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.informationView];
//        self.informationView.center = self.center;
        self.informationView.hidden = YES;
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

#pragma mark - ui event

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    [self bringSubviewToFront:self.informationView];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%@#%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.nextResponder motionBegan:motion withEvent:event];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%@#%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.informationView.hidden = !self.informationView.hidden;
    [self.nextResponder motionEnded:motion withEvent:event];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%@#%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self.nextResponder motionCancelled:motion withEvent:event];
}

#pragma mark - develop information

- (UIView *)informationView
{
    static DevelopInformationView *informationView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        informationView = [[DevelopInformationView alloc]init];
    });
    return informationView;
}

@end
